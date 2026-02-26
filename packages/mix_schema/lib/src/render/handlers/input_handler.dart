import 'package:flutter/material.dart';

import '../../ast/schema_node.dart';
import '../../events/schema_event.dart';
import '../node_handler.dart';
import '../render_context.dart';

/// Handler for InputNode.
///
/// Uses Flutter input widgets with Mix-styled containers. No Mix input
/// spec exists, so we use Flutter widgets directly per freeze §5.5.
///
/// **Experimental**: Included ahead of Phase 4 schedule in executable plan.
/// API may change as input handling patterns evolve.
class InputHandler extends NodeHandler<InputNode> {
  const InputHandler();

  @override
  Widget build(InputNode node, RenderContext ctx) {
    return Builder(builder: (context) {
      return switch (node.inputType) {
        'text' => _buildTextInput(node, ctx, context),
        'toggle' => _buildToggle(node, ctx, context),
        'slider' => _buildSlider(node, ctx, context),
        _ => _buildTextInput(node, ctx, context), // fallback to text
      };
    });
  }

  Widget _buildTextInput(
      InputNode node, RenderContext ctx, BuildContext context) {
    final label = ctx.resolveValue<String>(node.label, context);
    final hint = ctx.resolveValue<String>(node.hint, context);
    final initialValue = ctx.resolveValue<String>(node.value, context);

    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label, hintText: hint),
      onChanged: (value) {
        ctx.onEvent?.call(ChangeEvent(
          nodeId: node.nodeId,
          field: node.fieldId,
          value: value,
        ));
      },
    );
  }

  Widget _buildToggle(
      InputNode node, RenderContext ctx, BuildContext context) {
    final label = ctx.resolveValue<String>(node.label, context);
    final initialValue = ctx.resolveValue<bool>(node.value, context) ?? false;

    return _ToggleInput(
      label: label,
      initialValue: initialValue,
      onChanged: (value) {
        ctx.onEvent?.call(ChangeEvent(
          nodeId: node.nodeId,
          field: node.fieldId,
          value: value,
        ));
      },
    );
  }

  Widget _buildSlider(
      InputNode node, RenderContext ctx, BuildContext context) {
    final label = ctx.resolveValue<String>(node.label, context);
    final initialValue =
        ctx.resolveValue<double>(node.value, context) ?? 0.0;
    final min = ctx.resolveValue<double>(
            node.inputProps?['min'], context) ??
        0.0;
    final max = ctx.resolveValue<double>(
            node.inputProps?['max'], context) ??
        1.0;

    return _SliderInput(
      label: label,
      initialValue: initialValue,
      min: min,
      max: max,
      onChanged: (value) {
        ctx.onEvent?.call(ChangeEvent(
          nodeId: node.nodeId,
          field: node.fieldId,
          value: value,
        ));
      },
    );
  }
}

/// Stateful toggle input widget.
class _ToggleInput extends StatefulWidget {
  final String? label;
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const _ToggleInput({
    this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<_ToggleInput> createState() => _ToggleInputState();
}

class _ToggleInputState extends State<_ToggleInput> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: widget.label != null ? Text(widget.label!) : null,
      value: _value,
      onChanged: (v) {
        setState(() => _value = v);
        widget.onChanged(v);
      },
    );
  }
}

/// Stateful slider input widget.
class _SliderInput extends StatefulWidget {
  final String? label;
  final double initialValue;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  const _SliderInput({
    this.label,
    required this.initialValue,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  State<_SliderInput> createState() => _SliderInputState();
}

class _SliderInputState extends State<_SliderInput> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) Text(widget.label!),
        Slider(
          value: _value,
          min: widget.min,
          max: widget.max,
          onChanged: (v) {
            setState(() => _value = v);
            widget.onChanged(v);
          },
        ),
      ],
    );
  }
}
