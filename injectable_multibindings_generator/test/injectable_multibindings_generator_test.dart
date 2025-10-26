import 'package:injectable_multibindings/injectable_multibindings.dart';
import 'package:injectable_multibindings_generator/injectable_multibindings_generator.dart';
import 'package:source_gen/source_gen.dart';
import 'package:test/test.dart';

void main() {
  group('MultibindingGenerator', () {
    test('Generator exists and can be instantiated', () {
      final generator = MultibindingGenerator();
      expect(generator, isNotNull);
      expect(generator, isA<Generator>());
    });
  });

  group('Annotation tests', () {
    test('@MultiBinding is const constructible', () {
      const annotation = MultiBinding();
      expect(annotation, isA<MultiBinding>());
    });

    test('@MultiBinding has consistent equality', () {
      const annotation1 = MultiBinding();
      const annotation2 = MultiBinding();
      expect(annotation1 == annotation2, isTrue);
      expect(annotation1.hashCode == annotation2.hashCode, isTrue);
    });
  });
}
