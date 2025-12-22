import 'package:test/test.dart';

void main() {
  group('MixableUtilityGenerator', () {
    // These tests require the TypeRegistry scanning functionality which has been
    // replaced with hardcoded mappings. Integration tests for the generator
    // are run via the build_runner test infrastructure in the example/ directory.
  }, skip: 'Requires build_runner integration test setup');
}
