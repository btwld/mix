import 'package:test/test.dart';

void main() {
  group('UtilityMetadata', () {
    // UtilityMetadata relies on analyzer ClassElements which require build_test
    // infrastructure. To properly test this:
    // 1. Create test fixtures with actual Dart code
    // 2. Use the build_test package to resolve those fixtures
    // 3. Run the metadata extraction on real ClassElements
    // 4. Verify the extracted metadata matches expectations
    //
    // Integration tests are run via the example/ directory.
  }, skip: 'Requires build_test integration test setup');
}
