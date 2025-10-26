import 'package:meta/meta.dart';

/// Annotation for multibinding classes.
///
/// Classes annotated with [MultiBinding] will be automatically collected
/// into lists based on their implemented interfaces.
///
/// Example:
/// ```dart
/// @MultiBinding()
/// @injectable
/// class UserServiceImpl implements UserService {
///   // ...
/// }
/// ```
@immutable
class MultiBinding {
  /// Creates a [MultiBinding] annotation.
  const MultiBinding();

  @override
  bool operator ==(Object other) => identical(this, other) || other is MultiBinding && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// Annotation for marking the injectable configuration function.
///
/// This annotation should be placed on the function annotated with [InjectableInit].
/// It tells the generator where to create the multibinding modules file.
///
/// Example:
/// ```dart
/// @HasMultibindings()
/// @InjectableInit()
/// void configureDependencies() {
///   getIt.init();
/// }
/// ```
///
/// This will generate a file: `your_file.multibindings.dart` containing the modules.
@immutable
class HasMultibindings {
  /// Creates a [HasMultibindings] annotation.
  const HasMultibindings();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is HasMultibindings && runtimeType == other.runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}
