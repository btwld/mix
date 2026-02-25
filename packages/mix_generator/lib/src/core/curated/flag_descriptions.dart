/// Flag property descriptions for bool fields.
///
/// This file contains curated ifTrue strings for FlagProperty diagnostics.
library;

/// Curated ifTrue strings for FlagProperty.
/// Key: field name, Value: ifTrue description.
const flagPropertyDescriptions = {
  'softWrap': 'wrapping at word boundaries',
  'excludeFromSemantics': 'excluded from semantics',
  'gaplessPlayback': 'gapless playback',
  'isAntiAlias': 'anti-aliased',
  'matchTextDirection': 'matches text direction',
  'applyTextScaling': 'scales with text',
};

/// Gets the ifTrue description for a bool field.
/// Returns null if not in the curated map (fallback to generic DiagnosticsProperty).
String? getFlagDescription(String fieldName) {
  return flagPropertyDescriptions[fieldName];
}
