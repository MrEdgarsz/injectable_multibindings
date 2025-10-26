import 'package:injectable_multibindings/injectable_multibindings.dart';
import 'package:test/test.dart';

void main() {
  group('MultiBinding annotation', () {
    test('can be instantiated', () {
      const annotation = MultiBinding();
      expect(annotation, isA<MultiBinding>());
    });

    test('has consistent equality', () {
      const annotation1 = MultiBinding();
      const annotation2 = MultiBinding();
      expect(annotation1, equals(annotation2));
      expect(annotation1.hashCode, equals(annotation2.hashCode));
    });

    test('is immutable', () {
      const annotation = MultiBinding();
      expect(annotation, isA<MultiBinding>());
    });
  });
}
