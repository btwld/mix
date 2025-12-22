import 'package:test/test.dart';

void main() {
  group('UtilityCodeGenerator', () {
    // UtilityCodeGenerator relies on analyzer elements which require build_test
    // infrastructure. Integration tests are run via the example/ directory
    // which exercises the full code generation pipeline.
    //
    // To add unit tests for specific methods that don't depend on analyzer:
    // - generateDocTemplate
    // - generateUtilityField
    // - methodOnly
    // - chainGetter
    // - selfGetter
  }, skip: 'Requires build_test integration test setup');
}
