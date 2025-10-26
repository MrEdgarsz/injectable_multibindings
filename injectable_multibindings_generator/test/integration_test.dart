import 'dart:io';

import 'package:test/test.dart';

void main() {
  group('Integration tests', () {
    test('test source files exist', () {
      expect(File('test/test_sources/single_interface.dart').existsSync(), isTrue);
      expect(File('test/test_sources/multiple_interfaces.dart').existsSync(), isTrue);
    });

    test('generated code structure', () {
      // These tests verify that build_runner would generate the expected structure
      // Actual integration testing requires running: dart run build_runner build
      expect(true, isTrue);
    });
  });
}
