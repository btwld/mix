/// Pure value object describing one parameter of a `@MixWidget` source
/// (function parameter or Styler `call(...)` parameter). Intentionally free of
/// analyzer types so the string builder can be unit-tested in isolation.
class MixWidgetParam {
  final String name;
  final String typeDisplay;
  final bool isPositional;
  final bool isRequired;
  final String? defaultValueCode;

  const MixWidgetParam({
    required this.name,
    required this.typeDisplay,
    required this.isPositional,
    required this.isRequired,
    required this.defaultValueCode,
  });
}

/// Merges the source-function parameter list with the Styler's `call(...)`
/// parameter list by name. On collision, the source entry wins (defaults and
/// required-ness live there). The `key` call parameter is dropped because the
/// generated widget forwards it via `super.key`.
List<MixWidgetParam> mergeMixWidgetParams({
  required List<MixWidgetParam> source,
  required List<MixWidgetParam> call,
}) {
  final byName = <String, MixWidgetParam>{};
  for (final p in source) {
    byName[p.name] = p;
  }
  for (final p in call) {
    if (p.name == 'key') continue;
    byName.putIfAbsent(p.name, () => p);
  }
  return byName.values.toList(growable: false);
}
