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

/// Returns true if [node] is a call that builds a Styler, such as
/// `BoxStyler()`, `.color(...)`, or `style.padding(...)`.
bool isStylerCall(AstNode? node) =>
    (node is MethodInvocation ||
        node is InstanceCreationExpression ||
        node is DotShorthandInvocation ||
        node is DotShorthandConstructorInvocation) &&
    isMixStylerType((node as Expression).staticType);

/// Returns the outermost expression that passes [node]'s value through with
/// the same context type: parentheses, conditional branches, and switch
/// expression cases.
Expression outermostBranch(Expression node) {
  var current = node;
  while (true) {
    final parent = current.parent;
    if (parent is ParenthesizedExpression ||
        parent is ConditionalExpression && parent.condition != current) {
      current = parent as Expression;
    } else if (parent is SwitchExpressionCase && parent.expression == current) {
      current = parent.parent as SwitchExpression;
    } else {
      return current;
    }
  }
}

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

/// Returns the factory name of [root], the first call of a Styler chain,
/// such as `color` in `BoxStyler.color(...)` or `.color(...)`, or null for a
/// plain constructor such as `BoxStyler()`, `.new()`, or `BoxStyler.create()`.
String? rootFactoryName(Expression root) {
  final name = switch (root) {
    InstanceCreationExpression(:final constructorName) =>
      constructorName.name?.name,
    DotShorthandConstructorInvocation(:final constructorName) =>
      constructorName.name,
    DotShorthandInvocation(:final memberName) => memberName.name,
    _ => null,
  };

  return name == 'new' || name == 'create' ? null : name;
}

/// Classifies the factory that starts a Styler chain, or returns null when
/// [root] is not a factory (see [rootFactoryName]).
StylerCallKind? rootFactoryKind(Expression root) {
  final name = rootFactoryName(root);
  final styler = root.staticType;
  if (name == null) return null;

  return styler is InterfaceType
      ? _stylerMemberKind(styler, name)
      : StylerCallKind.baseStyle;
}

/// Returns true if [root], the first call of a Styler chain, sets base style
/// itself: a base style factory such as `.color(...)`, or a constructor with
/// a style argument such as `BoxStyler(padding: ...)`.
bool rootSetsBaseStyle(Expression root) {
  if (rootFactoryName(root) != null) {
    return rootFactoryKind(root) == StylerCallKind.baseStyle;
  }

  return _constructorArguments(root).any(
    (argument) =>
        _valueOf(argument) is! NullLiteral &&
        (argument is! NamedArgument ||
            !_structuralParameters.contains(argument.name.lexeme)),
  );
}

/// Returns true if [root] passes variants to the Styler constructor, such as
/// `BoxStyler(variants: [...])`.
bool rootSetsVariants(Expression root) => _constructorArguments(root).any(
  (argument) =>
      argument is NamedArgument &&
      _variantParameters.contains(argument.name.lexeme) &&
      argument.argumentExpression is! NullLiteral,
);

List<Argument> _constructorArguments(Expression root) => switch (root) {
  InstanceCreationExpression(:final argumentList) ||
  DotShorthandConstructorInvocation(
    :final argumentList,
  ) => argumentList.arguments,
  _ => const [],
};

Expression? _valueOf(Argument argument) => switch (argument) {
  NamedArgument(:final argumentExpression) => argumentExpression,
  Expression() => argument,
  _ => null,
};

/// Constructor parameters that hold variants.
const _variantParameters = {'variants', 'constraintBranches'};

/// Constructor parameters of Stylers that set no base style value.
const _structuralParameters = {
  'animation',
  'modifier',
  'variants',
  'constraintBranches',
};

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
