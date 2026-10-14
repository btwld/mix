import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/type.dart';

import 'type_helpers.dart';

/// The kind of a method call in a Styler chain.
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

/// Constructor parameters that hold variants.
const _variantParameters = {'variants', 'constraintBranches'};

/// Constructor parameters of Stylers that set no base style value.
const _structuralParameters = {
  'animation',
  'modifier',
  'variants',
  'constraintBranches',
};

/// Whether [node] is a call that builds a Styler, such as `BoxStyler()`,
/// `.color(...)`, or `style.padding(...)`.
bool isStylerCall(AstNode? node) =>
    (node is MethodInvocation ||
        node is InstanceCreationExpression ||
        node is DotShorthandInvocation ||
        node is DotShorthandConstructorInvocation) &&
    isMixStylerType((node as Expression).staticType);

/// The argument that passes the value of [node], looking through
/// parentheses, conditional branches, and switch expression cases.
///
/// These keep the context type of the argument, so a dot shorthand in [node]
/// resolves against the parameter type. The result is not in an
/// [ArgumentList] when the value is not passed to a call.
Argument enclosingArgument(Expression node) {
  var value = node;
  while (true) {
    final parent = value.parent;
    if (parent is ParenthesizedExpression ||
        parent is ConditionalExpression && parent.condition != value) {
      value = parent as Expression;
    } else if (parent is SwitchExpressionCase && parent.expression == value) {
      value = parent.parent as SwitchExpression;
    } else {
      return parent is NamedArgument ? parent : value;
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
  if (name == 'onConstraints' && isMixSubtype(receiver, 'GridBoxStyler')) {
    return .variant;
  }

  return .baseStyle;
}

/// The factory name of [root], the first call of a Styler chain, or null for
/// a plain constructor.
///
/// The factory name is `color` in `BoxStyler.color(...)` and `.color(...)`.
/// Plain constructors are `BoxStyler()`, `.new()`, and `BoxStyler.create()`.
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

/// The kind of the factory [root] that starts a Styler chain, or null when
/// [root] is a plain constructor (see [rootFactoryName]).
StylerCallKind? rootFactoryKind(Expression root) {
  final name = rootFactoryName(root);
  if (name == null) return null;
  final styler = root.staticType;

  return styler is InterfaceType ? _stylerMemberKind(styler, name) : .baseStyle;
}

/// Whether [root], the first call of a Styler chain, sets a base style
/// itself.
///
/// It does as a base style factory, such as `.color(...)`, or as a
/// constructor with a style argument, such as `BoxStyler(padding: ...)`.
bool rootSetsBaseStyle(Expression root) {
  if (rootFactoryName(root) != null) {
    return rootFactoryKind(root) == .baseStyle;
  }

  return _constructorArguments(root).any(
    (argument) =>
        _valueOf(argument) is! NullLiteral &&
        (argument is! NamedArgument ||
            !_structuralParameters.contains(argument.name.lexeme)),
  );
}

/// Whether [root] passes variants to the Styler constructor, such as
/// `BoxStyler(variants: [...])`.
bool rootSetsVariants(Expression root) => _constructorArguments(root).any(
  (argument) =>
      argument is NamedArgument &&
      _variantParameters.contains(argument.name.lexeme) &&
      !_isEmpty(argument.argumentExpression),
);

/// Whether [value] is `null` or an empty collection literal.
bool _isEmpty(Expression value) => switch (value) {
  NullLiteral() => true,
  ListLiteral(:final elements) ||
  SetOrMapLiteral(:final elements) => elements.isEmpty,
  _ => false,
};

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

/// Collects the method chain that directly follows [root].
///
/// Looks through parentheses, as in `(BoxStyler()).color(...)`, and stops
/// when the chain branches into another context, such as an argument list.
List<MethodInvocation> collectDirectMethodChain(Expression root) {
  final chain = <MethodInvocation>[];
  AstNode current = root;

  while (true) {
    var parent = current.parent;
    while (parent is ParenthesizedExpression) {
      current = parent;
      parent = parent.parent;
    }
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
