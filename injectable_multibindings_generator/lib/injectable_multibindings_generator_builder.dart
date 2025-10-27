import 'package:build/build.dart';
import 'package:injectable_multibindings_generator/src/multibinding_builder.dart';

/// Builder for multibinding modules.
///
/// Generates a single standalone file with all multibinding modules.
Builder multibindingBuilder(BuilderOptions options) {
  return MultibindingBuilder();
}
