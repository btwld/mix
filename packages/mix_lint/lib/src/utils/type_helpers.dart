import 'package:analyzer/dart/element/type.dart';

/// Returns true if [type] is a subtype of [MixStyler] (the Mix fluent API base).
bool isMixStylerType(DartType? type) => _isSubtypeByName(type, 'MixStyler');

/// Returns true if [type] is a subtype of [MixToken] (any token type).
bool isMixTokenType(DartType? type) => _isSubtypeByName(type, 'MixToken');

/// Returns true if [type] is a subtype of the Mix value base (`Mix`/`Mixable`).
///
/// Every ref-consuming Mix API — both Stylers (`MixStyler` → `Style` → `Mix`)
/// and value utilities (`EdgeInsetsGeometryMix`, `DecorationMix`, ... → `Mix`) —
/// shares this base, whether shipped in `package:mix` or generated in a user's
/// package via `@MixableType`/`@MixableSpec`.
bool isMixType(DartType? type) =>
    _isSubtypeByName(type, 'Mix') || _isSubtypeByName(type, 'Mixable');

/// Returns true if [type] is exactly [MixScope].
bool isMixScopeType(DartType? type) => _matchesByName(type, 'MixScope');

/// Returns true if [name] follows the variant method naming pattern
/// (starts with 'on' followed by an uppercase letter, e.g. onHovered, onDark).
bool isVariantMethodName(String name) {
  if (name.length <= 2) return false;
  if (!name.startsWith('on')) return false;
  final third = name[2];

  return third == third.toUpperCase() && third != third.toLowerCase();
}

bool _isSubtypeByName(DartType? type, String className) {
  if (type is! InterfaceType) return false;
  final element = type.element;
  if (element.name == className) return true;

  return element.allSupertypes.any((t) => t.element.name == className);
}

bool _matchesByName(DartType? type, String className) {
  if (type is! InterfaceType) return false;

  return type.element.name == className;
}
