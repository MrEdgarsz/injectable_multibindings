import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:injectable_multibindings/injectable_multibindings.dart';
import 'package:source_gen/source_gen.dart';
import 'package:glob/glob.dart';

/// Custom builder that generates a single file with all multibindings.
class MultibindingBuilder implements Builder {
  @override
  Map<String, List<String>> get buildExtensions => {
    '.dart': ['.multibindings.dart'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    // Only generate for files with @InjectableInit
    final hasInit = await _hasInjectableInit(buildStep);
    if (!hasInit) {
      return;
    }

    // Generate multibindings file
    final content = await _generateMultibindings(buildStep);

    if (content.isNotEmpty) {
      final outputId = buildStep.inputId.changeExtension('.multibindings.dart');
      await buildStep.writeAsString(outputId, content);
    }
  }

  Future<bool> _hasInjectableInit(BuildStep buildStep) async {
    try {
      final library = await buildStep.resolver.libraryFor(buildStep.inputId);

      for (final unit in library.units) {
        for (final func in unit.functions) {
          // Check for @InjectableInit by annotation name since we don't want to depend on injectable package
          for (final annotation in func.metadata) {
            final annotationValue = annotation.computeConstantValue();
            if (annotationValue == null) continue;

            final annotationElement = annotationValue.type?.element;
            if (annotationElement == null) continue;

            // Check if it's InjectableInit annotation by name
            if (annotationElement.name == 'InjectableInit') {
              return true;
            }
          }
        }
      }
    } catch (e) {
      // Fallback: check if file name suggests it's a configuration file
      final fileName = buildStep.inputId.path.toLowerCase();
      return fileName.contains('app') || fileName.contains('main') || fileName.contains('di');
    }
    return false;
  }

  Future<String> _generateMultibindings(BuildStep buildStep) async {
    // Collect all multibinding classes from all libraries
    final multibindingClasses = <ClassElement>[];

    // Scan ALL Dart files in the lib directory, not just imports
    final allAssets = await buildStep.findAssets(Glob('lib/**/*.dart')).toList();

    for (final asset in allAssets) {
      try {
        final library = await buildStep.resolver.libraryFor(asset);

        for (final unit in library.units) {
          for (final element in unit.classes) {
            const typeChecker = TypeChecker.fromRuntime(MultiBinding);
            bool hasMultiBinding = false;

            for (final annotation in element.metadata) {
              final annotationValue = annotation.computeConstantValue();
              if (annotationValue == null) continue;

              final annotationElement = annotationValue.type?.element;
              if (annotationElement == null) continue;

              if (typeChecker.isExactly(annotationElement)) {
                hasMultiBinding = true;
                break;
              }
            }

            if (hasMultiBinding) {
              multibindingClasses.add(element);
            }
          }
        }
      } catch (e) {
        // Skip files that can't be resolved
        continue;
      }
    }

    if (multibindingClasses.isEmpty) {
      return '';
    }

    // Group by interface type
    final bindingsByType = <String, List<String>>{};

    for (final classElement in multibindingClasses) {
      final implementedTypes =
          classElement.allSupertypes
              .where((type) => type.element != classElement)
              .map((type) => type.element)
              .whereType<InterfaceElement>()
              .toList();

      for (final interface in implementedTypes) {
        final typeName = interface.name;
        final className = classElement.name;

        if (!bindingsByType.containsKey(typeName)) {
          bindingsByType[typeName] = [];
        }
        bindingsByType[typeName]!.add(className);
      }
    }

    // Collect imports
    final imports = <String>{};
    for (final element in multibindingClasses) {
      final source = element.source;
      final uri = source.uri;
      if (uri.isScheme('package')) {
        final package = uri.pathSegments.first;
        final path = uri.pathSegments.skip(1).join('/');
        imports.add("import 'package:$package/$path';");
      } else if (uri.isScheme('file')) {
        final path = uri.path;
        if (path.contains('lib/')) {
          final relativePath = path.substring(path.indexOf('lib/') + 4);
          imports.add("import '$relativePath';");
        }
      }

      // Add imports for interfaces
      final implementedTypes =
          element.allSupertypes
              .where((type) => type.element != element)
              .map((type) => type.element)
              .whereType<InterfaceElement>()
              .toList();

      for (final interface in implementedTypes) {
        final source = interface.source;
        final uri = source.uri;
        if (uri.isScheme('package')) {
          final package = uri.pathSegments.first;
          final path = uri.pathSegments.skip(1).join('/');
          imports.add("import 'package:$package/$path';");
        } else if (uri.isScheme('file')) {
          final path = uri.path;
          if (path.contains('lib/')) {
            final relativePath = path.substring(path.indexOf('lib/') + 4);
            imports.add("import '$relativePath';");
          }
        }
      }
    }

    // Generate modules
    final buffer = StringBuffer();
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY MANUALLY');
    buffer.writeln('// Multibinding modules');
    buffer.writeln();
    buffer.writeln("import 'package:get_it/get_it.dart' as i1;");

    // Add collected imports
    for (final import in imports) {
      buffer.writeln(import);
    }

    buffer.writeln();
    buffer.writeln('final getIt = i1.GetIt.instance;');
    buffer.writeln();

    // Generate configureMultibindings extension method using GetIt's native support
    buffer.writeln('// Extension to configure multibindings');
    buffer.writeln(
      '// IMPORTANT: Call getIt.enableRegisteringMultipleInstancesOfOneType() before calling configureMultibindings()',
    );
    buffer.writeln('extension ConfigureMultibindings on i1.GetIt {');
    buffer.writeln('  void configureMultibindings() {');

    // For each interface type, register each implementation as the interface type
    // This creates aliases: EmailService instance is also accessible as NotificationService
    // Skip Object since everything implements it
    for (final entry in bindingsByType.entries) {
      final interfaceName = entry.key;
      if (interfaceName == 'Object') continue; // Skip Object

      final implementations = entry.value;

      buffer.writeln('    // Register multibindings for $interfaceName');
      for (final impl in implementations) {
        // Register each implementation type as the interface type
        // Using Factory here - getIt<Impl>() respects the original registration strategy
        buffer.writeln('    registerFactory<$interfaceName>(() => getIt<${impl}>());');
      }

      // Register factory for Iterable<T> using getAll
      buffer.writeln('    registerFactory<Iterable<$interfaceName>>(() => getAll<$interfaceName>());');
      buffer.writeln();
    }

    buffer.writeln('  }');
    buffer.writeln('}');

    return buffer.toString();
  }
}
