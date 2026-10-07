import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';

import 'type_helpers.dart';

/// What a method call in a Styler chain does.
enum StylerCallKind {
  /// Sets a base style value, such as `color` or `padding`.
  baseStyle,

  /// Adds a variant, such as `onHovered`, `onDark`, or `variant`.
  variant,

  /// Builds the style from the build context (`onBuilder`).
  builder,

  /// Changes how the style is applied, not what it sets: `animate`,
  /// `keyframeAnimation`, `phaseAnimation`, `wrap`, `modifier`, `merge`, and
  /// `applyVariants`.
  structural,
}

const _variantMixins = {'VariantStyleMixin', 'WidgetStateVariantMixin'};
const _structuralMixins = {'AnimationStyleMixin', 'WidgetModifierStyleMixin'};
// `modifier` is the generated alias of `wrap`.
const _structuralMethods = {'merge', 'applyVariants', 'modifier'};

/// Classifies [node], a method call on a Styler.
///
/// Generated Stylers override some mixin methods (for example `animate` and
/// `variants`), so this checks which Mix mixin declares the method name, not
/// where the override lives.
StylerCallKind stylerCallKind(MethodInvocation node) {
  final receiver = node.realTarget?.staticType ?? node.staticType;

  return receiver is InterfaceType
      ? _stylerMemberKind(receiver, node.methodName.name)
      : .baseStyle;
}

/// Classifies the method or factory [name] of the Styler [receiver].
StylerCallKind _stylerMemberKind(InterfaceType receiver, String name) {
  if (_structuralMethods.contains(name)) return .structural;
  if (_isDeclaredByMixMixin(receiver, name, _structuralMixins)) {
    return .structural;
  }
  if (_isDeclaredByMixMixin(receiver, name, _variantMixins)) {
    return name == 'onBuilder' ? .builder : .variant;
  }
  // GridBoxStyler.onConstraints is a local-constraint variant.
  if (name == 'onConstraints' &&
      isMixClass(receiver.element, 'GridBoxStyler')) {
    return .variant;
  }

  return .baseStyle;
}

/// Returns true if [root], the first call of a Styler chain, sets base style
/// itself: a factory such as `BoxStyler.color(...)` or `.color(...)`, or a
/// constructor call with arguments such as `BoxStyler(padding: ...)`.
///
/// `BoxStyler()`, `.new()`, and `BoxStyler.create()` without arguments set
/// nothing, and neither do factories that are not base style, such as
/// `BoxStyler.animate(...)` or `GridBoxStyler.onConstraints(...)`.
bool rootSetsBaseStyle(Expression root) => switch (root) {
  InstanceCreationExpression(:final constructorName, :final argumentList) =>
    _constructorSetsBaseStyle(
      root.staticType,
      constructorName.name?.name,
      argumentList,
    ),
  DotShorthandConstructorInvocation(
    :final constructorName,
    :final argumentList,
  ) =>
    _constructorSetsBaseStyle(
      root.staticType,
      constructorName.name,
      argumentList,
    ),
  // A static method, such as `.color(...)` on a hand-written Styler.
  DotShorthandInvocation(:final memberName) => _factorySetsBaseStyle(
    root.staticType,
    memberName.name,
  ),
  _ => false,
};

bool _constructorSetsBaseStyle(
  DartType? styler,
  String? name,
  ArgumentList argumentList,
) => name == null || name == 'new' || name == 'create'
    ? argumentList.arguments.isNotEmpty
    : _factorySetsBaseStyle(styler, name);

bool _factorySetsBaseStyle(DartType? styler, String name) =>
    styler is! InterfaceType ||
    _stylerMemberKind(styler, name) == StylerCallKind.baseStyle;

/// Collects the method chain that directly follows [root].
///
/// Stops when the chain branches into another context, such as an argument
/// list.
List<MethodInvocation> collectDirectMethodChain(Expression root) {
  final chain = <MethodInvocation>[];
  AstNode current = root;

  while (true) {
    final parent = current.parent;
    if (parent is! MethodInvocation || parent.target != current) break;

    chain.add(parent);
    current = parent;
  }

  return chain;
}

/// Yields the ancestors of [node] up to the enclosing statement or
/// declaration.
Iterable<AstNode> ancestorsBeforeStatementOrDeclaration(AstNode node) sync* {
  AstNode? current = node.parent;
  while (current != null && current is! Statement && current is! Declaration) {
    yield current;
    current = current.parent;
  }
}

bool _isDeclaredByMixMixin(
  InterfaceType receiver,
  String methodName,
  Set<String> mixinNames,
) {
  return receiver.element.allSupertypes.any((type) {
    final element = type.element;

    return mixinNames.contains(element.name) &&
        isFromMix(element) &&
        element.getMethod(methodName) != null;
  });
}
