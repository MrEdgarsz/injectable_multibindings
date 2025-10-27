import 'package:injectable_multibindings/injectable_multibindings.dart';
import 'package:injectable_multibindings_generator/injectable_multibindings_generator.dart';
import 'package:build/build.dart';
import 'package:test/test.dart';

void main() {
  group('MultibindingBuilder', () {
    test('Builder exists and can be instantiated', () {
      final builder = MultibindingBuilder();
      expect(builder, isNotNull);
      expect(builder, isA<Builder>());
    });

    test('Builder has correct build extensions', () {
      final builder = MultibindingBuilder();
      final extensions = builder.buildExtensions;
      expect(extensions, isNotNull);
      expect(extensions['.dart'], isNotNull);
      expect(extensions['.dart']!.contains('.multibindings.dart'), isTrue);
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
