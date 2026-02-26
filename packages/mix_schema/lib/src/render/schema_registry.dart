import '../ast/schema_node.dart';
import 'handlers/box_handler.dart';
import 'handlers/flex_handler.dart';
import 'handlers/icon_handler.dart';
import 'handlers/image_handler.dart';
import 'handlers/input_handler.dart';
import 'handlers/pressable_handler.dart';
import 'handlers/repeat_handler.dart';
import 'handlers/scrollable_handler.dart';
import 'handlers/stack_handler.dart';
import 'handlers/text_handler.dart';
import 'handlers/wrap_handler.dart';
import 'node_handler.dart';

/// Registry mapping SchemaNode types to their handlers.
class SchemaRegistry {
  final Map<Type, NodeHandler> _handlers;

  SchemaRegistry(this._handlers);

  /// Default registry with all v0.1 handlers.
  factory SchemaRegistry.defaults() => SchemaRegistry({
        BoxNode: const BoxHandler(),
        TextNode: const TextHandler(),
        FlexNode: const FlexHandler(),
        StackNode: const StackHandler(),
        IconNode: const IconHandler(),
        ImageNode: const ImageHandler(),
        PressableNode: const PressableHandler(),
        ScrollableNode: const ScrollableHandler(),
        WrapNode: const WrapHandler(),
        InputNode: const InputHandler(),
        RepeatNode: const RepeatHandler(),
      });

  /// Look up the handler for a node.
  NodeHandler? handlerFor(SchemaNode node) => _handlers[node.runtimeType];

  /// Register a handler for a node type.
  void register<N extends SchemaNode>(NodeHandler<N> handler) {
    _handlers[N] = handler;
  }
}
