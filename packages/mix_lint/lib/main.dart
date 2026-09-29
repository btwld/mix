/// The entry point the Dart analysis server loads for this plugin.
///
/// The analysis server imports `package:mix_lint/main.dart` and reads its
/// top-level `plugin`; without this file the plugin fails to compile there.
library;

export 'mix_lint.dart' show plugin;
