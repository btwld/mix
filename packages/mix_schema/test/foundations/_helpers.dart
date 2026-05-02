/// Test helpers shared by the foundation tests.
///
/// Resolves the path to `lib/src/assets/` regardless of where `dart test`
/// is invoked from. The Dart test runner sets the working directory to the
/// package root, so the relative path is stable.
library;

const String testAssetsDir = 'lib/src/assets';
