/// Stable categories for diagnostics emitted while translating Tailwind tokens.
enum TwDiagnosticCode {
  invalidCandidate,
  importantModifierIgnored,
  arbitraryPropertyIgnored,
  arbitraryVariantIgnored,
  containerVariantIgnored,
  contextVariantIgnored,
  unsupportedVariant,
  unsupportedUtility,
  unsupportedValue,
  unsupportedForTarget,
  widgetLayerVariantUnsupported,
}

/// A structured explanation for a token that could not be applied as written.
final class TwDiagnostic {
  /// The original class token, including variant prefixes and modifiers.
  final String token;

  /// A machine-readable category suitable for filtering and tooling.
  final TwDiagnosticCode code;

  /// A human-readable explanation of why the token was not applied.
  final String reason;

  /// An optional supported alternative.
  final String? workaround;

  const TwDiagnostic({
    required this.token,
    required this.code,
    required this.reason,
    this.workaround,
  });
}

typedef TwDiagnosticCallback = void Function(TwDiagnostic diagnostic);

@Deprecated('Use TwDiagnosticCallback and the onDiagnostic parameter instead.')
typedef TokenWarningCallback = void Function(String token);
