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
  /// `keyframeAnimation`, `phaseAnimation`, `wrap`, `merge`, and
  /// `applyVariants`.
  structural,
}

const _variantMixins = {'VariantStyleMixin', 'WidgetStateVariantMixin'};
const _structuralMixins = {'AnimationStyleMixin', 'WidgetModifierStyleMixin'};
const _structuralMethods = {'merge', 'applyVariants'};

/// Classifies [node], a method call on a Styler.
///
/// Generated Stylers override some mixin methods (for example `animate` and
/// `variants`), so this checks which Mix mixin declares the method name, not
/// where the override lives.
StylerCallKind stylerCallKind(MethodInvocation node) {
  final name = node.methodName.name;
  final receiver = node.realTarget?.staticType ?? node.staticType;
  if (receiver is! InterfaceType) return .baseStyle;

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
