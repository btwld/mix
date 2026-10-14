import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

/// Whether [element] is declared in a library of [packageName].
bool isFromPackage(Element? element, String packageName) {
  final uri = element?.library?.uri;

  return uri != null &&
      uri.scheme == 'package' &&
      uri.pathSegments.isNotEmpty &&
      uri.pathSegments.first == packageName;
}

/// Whether [element] is declared in `package:mix`.
bool isFromMix(Element? element) => isFromPackage(element, 'mix');

/// Whether [element] is the `package:mix` class named [className].
bool isMixClass(Element? element, String className) =>
    element is InterfaceElement &&
    element.name == className &&
    isFromMix(element);

/// Whether [type] is a Styler (a subtype of `MixStyler`).
bool isMixStylerType(DartType? type) => isMixSubtype(type, 'MixStyler');

/// Whether [type] is a design token (a subtype of `MixToken`).
bool isMixTokenType(DartType? type) => isMixSubtype(type, 'MixToken');

/// Whether [type] is a Mix value (a subtype of `Mix` or `Mixable`).
///
/// Stylers (`MixStyler` → `Style` → `Mix`) and value types such as
/// `EdgeInsetsGeometryMix` share this base, including types generated in a
/// user's package with `@MixableSpec` or `@Mixable`.
bool isMixType(DartType? type) =>
    isMixSubtype(type, 'Mix') || isMixSubtype(type, 'Mixable');

/// Whether [type] is exactly `MixScope`.
bool isMixScopeType(DartType? type) =>
    type is InterfaceType && isMixClass(type.element, 'MixScope');

/// Whether [type] is a Flutter widget (a subtype of `Widget`).
bool isFlutterWidgetType(DartType? type) {
  if (type is! InterfaceType) return false;

  bool isWidget(InterfaceElement element) =>
      element.name == 'Widget' && isFromPackage(element, 'flutter');

  return isWidget(type.element) ||
      type.element.allSupertypes.any((t) => isWidget(t.element));
}

/// Whether [parameter] is declared with a type parameter of its method, such
/// as `T` in `foo<T>(T value)`.
///
/// The argument infers that type, so a dot shorthand there has no context
/// type.
bool isMethodTypeParameter(FormalParameterElement? parameter) {
  final declaredType = switch (parameter?.baseElement) {
    FormalParameterElement(:final type) => type,
    _ => null,
  };

  return declaredType is TypeParameterType &&
      declaredType.element.enclosingElement is ExecutableElement;
}

/// Whether [type] is the `package:mix` class [className] or a subtype of it.
bool isMixSubtype(DartType? type, String className) {
  if (type is! InterfaceType) return false;
  final element = type.element;
  if (isMixClass(element, className)) return true;

  return element.allSupertypes.any((t) => isMixClass(t.element, className));
}
