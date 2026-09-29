/// Settings for the `mix_lint` rules that take options.
///
/// Analyzer plugins cannot read rule options from `analysis_options.yaml`.
/// To change a setting, create a local plugin package whose `lib/main.dart`
/// builds a `MixLintPlugin` with your config. The README shows how.
final class MixLintConfig {
  /// The default for [maxStylerChainLength].
  static const defaultMaxStylerChainLength = 15;

  /// The maximum number of calls in one Styler chain before
  /// `long_styler_chain` reports it.
  final int maxStylerChainLength;

  /// Creates a config. Every setting has a default.
  const MixLintConfig({
    this.maxStylerChainLength = defaultMaxStylerChainLength,
  });
}
