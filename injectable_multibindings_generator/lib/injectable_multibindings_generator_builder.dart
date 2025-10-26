import 'package:build/build.dart';
import 'package:injectable_multibindings_generator/injectable_multibindings_generator.dart';
import 'package:source_gen/source_gen.dart';

/// Builder for multibinding modules.
Builder multibindingBuilder(BuilderOptions options) {
  return LibraryBuilder(MultibindingGenerator(), generatedExtension: '.multibindings.dart', options: options);
}
