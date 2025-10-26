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
