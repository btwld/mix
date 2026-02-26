import 'schema_semantics.dart';
import 'schema_values.dart';

/// Animation configuration for AST nodes.
///
/// Freeze contract: animation key is `durationMs`.
final class SchemaAnimation {
  final int durationMs;
  final String? curve; // "easeOut", "easeInOut", "linear", etc.
  final int? delayMs;

  const SchemaAnimation({
    required this.durationMs,
    this.curve,
    this.delayMs,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SchemaAnimation &&
          durationMs == other.durationMs &&
          curve == other.curve &&
          delayMs == other.delayMs;

  @override
  int get hashCode => Object.hash(durationMs, curve, delayMs);

  @override
  String toString() =>
      'SchemaAnimation(${durationMs}ms, curve: $curve, delay: $delayMs)';
}

/// Base for all AST nodes. Every node has identity, type, and optional semantics.
///
/// See freeze §5.1 for the full node shape contract.
sealed class SchemaNode {
  final String nodeId;
  final SchemaSemantics? semantics;
  final Map<String, SchemaValue>? style;
  final SchemaAnimation? animation;
  final Map<String, SchemaValue>? variants; // interaction/theme variants

  const SchemaNode({
    required this.nodeId,
    this.semantics,
    this.style,
    this.animation,
    this.variants,
  });
}

// --- Primitives ---

final class BoxNode extends SchemaNode {
  final SchemaNode? child;

  const BoxNode({
    required super.nodeId,
    this.child,
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}

final class TextNode extends SchemaNode {
  final SchemaValue content; // DirectValue<String> or BindingValue

  const TextNode({
    required super.nodeId,
    required this.content,
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}

final class IconNode extends SchemaNode {
  final SchemaValue icon; // icon name or codepoint

  const IconNode({
    required super.nodeId,
    required this.icon,
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}

final class ImageNode extends SchemaNode {
  final SchemaValue src;
  final String? alt;

  const ImageNode({
    required super.nodeId,
    required this.src,
    this.alt,
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}

// --- Layout ---

final class FlexNode extends SchemaNode {
  final List<SchemaNode> children;
  final SchemaValue? direction; // "row" | "column"
  final SchemaValue? spacing;
  final SchemaValue? crossAxisAlignment;
  final SchemaValue? mainAxisAlignment;

  const FlexNode({
    required super.nodeId,
    required this.children,
    this.direction,
    this.spacing,
    this.crossAxisAlignment,
    this.mainAxisAlignment,
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}

final class StackNode extends SchemaNode {
  final List<SchemaNode> children;
  final SchemaValue? alignment;

  const StackNode({
    required super.nodeId,
    required this.children,
    this.alignment,
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}

final class ScrollableNode extends SchemaNode {
  final SchemaNode child;
  final SchemaValue? direction; // "vertical" | "horizontal"

  const ScrollableNode({
    required super.nodeId,
    required this.child,
    this.direction,
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}

final class WrapNode extends SchemaNode {
  final List<SchemaNode> children;
  final SchemaValue? spacing;
  final SchemaValue? runSpacing;

  const WrapNode({
    required super.nodeId,
    required this.children,
    this.spacing,
    this.runSpacing,
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}

// --- Interactive ---

final class PressableNode extends SchemaNode {
  final SchemaNode child;
  final String? actionId;

  const PressableNode({
    required super.nodeId,
    required this.child,
    this.actionId,
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}

final class InputNode extends SchemaNode {
  final String inputType; // "text" | "toggle" | "slider" | "select" | "date"
  final String fieldId;
  final SchemaValue? label;
  final SchemaValue? hint;
  final SchemaValue? value;
  final Map<String, SchemaValue>? inputProps; // type-specific props

  const InputNode({
    required super.nodeId,
    required this.inputType,
    required this.fieldId,
    this.label,
    this.hint,
    this.value,
    this.inputProps,
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}

// --- Control ---

final class RepeatNode extends SchemaNode {
  final SchemaValue items; // BindingValue to a list
  final SchemaNode template;
  final String itemAlias; // default "item"

  const RepeatNode({
    required super.nodeId,
    required this.items,
    required this.template,
    this.itemAlias = 'item',
    super.semantics,
    super.style,
    super.animation,
    super.variants,
  });
}
