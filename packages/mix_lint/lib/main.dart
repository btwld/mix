import 'mix_lint.dart';

/// The plugin instance that the Dart analysis server loads.
///
/// The analysis server imports `package:mix_lint/main.dart` and reads this
/// top-level variable, so its name and location must not change.
final plugin = MixLintPlugin();
