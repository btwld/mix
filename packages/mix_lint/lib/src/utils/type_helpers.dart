import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

/// Returns true if [element] is declared in a library of [packageName].
bool isFromPackage(Element? element, String packageName) {
  final uri = element?.library?.uri;

  return uri != null &&
      uri.scheme == 'package' &&
      uri.pathSegments.isNotEmpty &&
      uri.pathSegments.first == packageName;
}

/// Returns true if [element] is declared in `package:mix`.
bool isFromMix(Element? element) => isFromPackage(element, 'mix');

/// Returns true if [element] is the `package:mix` class named [className].
bool isMixClass(Element? element, String className) =>
    element is InterfaceElement &&
    element.name == className &&
    isFromMix(element);

/// Returns true if [type] is a Styler (a subtype of `MixStyler`).
bool isMixStylerType(DartType? type) => _isMixSubtype(type, 'MixStyler');

/// Returns true if [type] is a design token (a subtype of `MixToken`).
bool isMixTokenType(DartType? type) => _isMixSubtype(type, 'MixToken');

/// Returns true if [type] is a Mix value (a subtype of `Mix` or `Mixable`).
///
/// Stylers (`MixStyler` → `Style` → `Mix`) and value types such as
/// `EdgeInsetsGeometryMix` share this base, including types generated in a
/// user's package with `@MixableSpec` or `@Mixable`.
bool isMixType(DartType? type) =>
    _isMixSubtype(type, 'Mix') || _isMixSubtype(type, 'Mixable');

/// Returns true if [type] is exactly `MixScope`.
bool isMixScopeType(DartType? type) =>
    type is InterfaceType && isMixClass(type.element, 'MixScope');

/// Returns true if [type] is a Flutter widget (a subtype of `Widget`).
bool isFlutterWidgetType(DartType? type) {
  if (type is! InterfaceType) return false;

  bool isWidget(InterfaceElement element) =>
      element.name == 'Widget' && isFromPackage(element, 'flutter');

  return isWidget(type.element) ||
      type.element.allSupertypes.any((t) => isWidget(t.element));
}

/// Returns true if [parameter] is declared with a type parameter of the
/// invoked method, such as `T` in `foo<T>(T value)`. The argument infers
/// that type, so a dot shorthand there has no context type.
bool isMethodTypeParameter(FormalParameterElement? parameter) {
  final declaredType = switch (parameter?.baseElement) {
    FormalParameterElement(:final type) => type,
    _ => null,
  };

  return declaredType is TypeParameterType &&
      declaredType.element.enclosingElement is ExecutableElement;
}

/// Returns true if [type] is [className] from `package:mix`, or a subtype
/// of it.
bool _isMixSubtype(DartType? type, String className) {
  if (type is! InterfaceType) return false;
  final element = type.element;
  if (isMixClass(element, className)) return true;

  return element.allSupertypes.any((t) => isMixClass(t.element, className));
}
