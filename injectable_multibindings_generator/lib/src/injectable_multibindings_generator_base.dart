import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:injectable_multibindings/injectable_multibindings.dart';
import 'package:source_gen/source_gen.dart';

/// Generator for multibinding modules.
class MultibindingGenerator extends Generator {
  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    // Find all classes annotated with @MultiBinding
    final multibindingClasses = <ClassElement>[];

    for (final element in library.allElements) {
      if (element is ClassElement) {
        final annotation = _getMultiBindingAnnotation(element);
        if (annotation != null) {
          multibindingClasses.add(element);
        }
      }
    }

    if (multibindingClasses.isEmpty) {
      return '';
    }

    // Validate and collect bindings
    final bindingsByType = <String, List<_BindingInfo>>{};

    for (final classElement in multibindingClasses) {
      if (classElement.isAbstract) {
        throw InvalidGenerationSourceError(
          'Abstract classes cannot be annotated with @MultiBinding',
          element: classElement,
        );
      }

      // Get all implemented interfaces
      final implementedTypes =
          classElement.allSupertypes
              .where((type) => type.element != classElement)
              .map((type) => type.element)
              .whereType<InterfaceElement>()
              .toList();

      if (implementedTypes.isEmpty) {
        throw InvalidGenerationSourceError(
          'Classes annotated with @MultiBinding must implement at least one interface',
          element: classElement,
        );
      }

      // Extract scope from @injectable annotation
      final scope = _extractScope(classElement);

      // Add to bindings map
      for (final interface in implementedTypes) {
        final fullTypeName = _getFullTypeName(interface);
        final className = classElement.name;
        final fullClassName = _getFullTypeName(classElement);

        if (!bindingsByType.containsKey(fullTypeName)) {
          bindingsByType[fullTypeName] = [];
        }
        bindingsByType[fullTypeName]!.add(
          _BindingInfo(fullClassName: fullClassName, simpleClassName: className, scope: scope),
        );
      }
    }

    // Generate module code
    final buffer = StringBuffer();

    buffer.writeln('// GENERATED CODE - DO NOT MODIFY MANUALLY');
    buffer.writeln('// This module provides multibindings for annotated classes');
    buffer.writeln();

    for (final entry in bindingsByType.entries) {
      final interfaceName = entry.key;
      final simpleInterfaceName = interfaceName.split('.').last;
      final implementations = entry.value;

      // Group implementations by scope
      final bindingsByScope = <String?, List<_BindingInfo>>{};
      for (final impl in implementations) {
        if (!bindingsByScope.containsKey(impl.scope)) {
          bindingsByScope[impl.scope] = [];
        }
        bindingsByScope[impl.scope]!.add(impl);
      }

      // Generate modules for each scope
      final scopes = bindingsByScope.keys.toList()..sort((a, b) => (a ?? '').compareTo(b ?? ''));

      for (final scope in scopes) {
        final scopeBindings = bindingsByScope[scope]!;
        final scopeSuffix = scope != null ? '_${scope}' : '';

        buffer.writeln('@module');
        buffer.writeln('abstract class ${simpleInterfaceName}BindingsModule$scopeSuffix {');
        buffer.writeln('  @singleton');
        buffer.writeln('  List<$interfaceName> get multiBindings => [');

        for (final impl in scopeBindings) {
          buffer.writeln('    getIt<${impl.fullClassName}>(),');
        }

        buffer.writeln('  ];');
        buffer.writeln('}');
        buffer.writeln();
      }

      // Generate merged accessor if there are multiple scopes
      if (scopes.length > 1) {
        buffer.writeln('// Merged accessor for all scopes');
        buffer.writeln('List<$interfaceName> ${simpleInterfaceName.toLowerCase()}Multibindings() {');
        buffer.writeln('  final List<$interfaceName> result = [];');

        for (final scope in scopes) {
          final scopeSuffix = scope != null ? '_${scope}' : '';
          buffer.writeln('  result.addAll(getIt<${simpleInterfaceName}BindingsModule$scopeSuffix>().multiBindings);');
        }

        buffer.writeln('  return result;');
        buffer.writeln('}');
        buffer.writeln();
      }
    }

    return buffer.toString();
  }

  ConstantReader? _getMultiBindingAnnotation(ClassElement element) {
    const typeChecker = TypeChecker.fromRuntime(MultiBinding);

    for (final annotation in element.metadata) {
      final annotationValue = annotation.computeConstantValue();
      if (annotationValue == null) continue;

      final annotationElement = annotationValue.type?.element;
      if (annotationElement == null) continue;

      if (typeChecker.isExactly(annotationElement)) {
        return ConstantReader(annotationValue);
      }
    }
    return null;
  }

  String _getFullTypeName(InterfaceElement element) {
    final library = element.library;
    final prefix = library.isInSdk ? '' : '${library.name}.';
    return '$prefix${element.name}';
  }

  String? _extractScope(ClassElement element) {
    // Look for @injectable annotation
    for (final annotation in element.metadata) {
      final annotationValue = annotation.computeConstantValue();
      if (annotationValue == null) continue;

      final annotationElement = annotationValue.type?.element;
      if (annotationElement == null) continue;

      // Check if it's an injectable annotation (singleton, lazySingleton, factory, etc.)
      final annotationName = annotationElement.name?.toLowerCase() ?? '';
      if (annotationName.contains('singleton') || annotationName.contains('factory')) {
        // Try to get scope parameter
        final reader = ConstantReader(annotationValue);

        // Check for 'scope' or 'environment' parameter
        if (reader.peek('scope') != null) {
          final scopeValue = reader.read('scope');
          if (scopeValue.isNull) return null;
          final constant = scopeValue.objectValue;
          // Get string representation
          final stringValue = constant.getField('name')?.toStringValue();
          return stringValue;
        }

        if (reader.peek('environment') != null) {
          final envValue = reader.read('environment');
          if (envValue.isNull) return null;
          final constant = envValue.objectValue;
          final stringValue = constant.getField('name')?.toStringValue();
          return stringValue;
        }
      }
    }
    return null;
  }
}

class _BindingInfo {
  final String fullClassName;
  final String simpleClassName;
  final String? scope;

  _BindingInfo({required this.fullClassName, required this.simpleClassName, this.scope});
}
