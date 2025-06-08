import 'package:flutter/widgets.dart';

import '../../../modifiers/internal/render_widget_modifier.dart';
import '../../../variants/widget_state_variant.dart';
import '../../../widgets/pressable_widget.dart';
import '../../computed_style/computed_style.dart';
import '../../computed_style/computed_style_provider.dart';
import '../../factory/mix_data.dart';
import '../../factory/mix_provider.dart';
import '../../factory/style_mix.dart';
import '../../widget_state/widget_state_controller.dart';

/// Builds widgets with Mix styling and intelligent caching.
///
/// MixBuilder optimizes performance by caching [ComputedStyle] instances
/// and enabling selective widget rebuilds through [InheritedModel].
///
/// ## Performance
///
/// - Caches [ComputedStyle] when [style] hasn't changed
/// - Uses [InheritedModel] for selective rebuilds based on spec changes
/// - Creates fresh [MixData] to ensure context values stay current
///
/// ## Example
///
/// ```dart
/// MixBuilder(
///   style: Style(
///     $box.color.red(),
///     $box.padding(16),
///   ),
///   builder: (context) {
///     final boxSpec = BoxSpec.of(context);
///     return Container(
///       decoration: boxSpec?.decoration,
///       child: Text('Hello'),
///     );
///   },
/// )
/// ```
///
/// See also:
///
/// * [ComputedStyle], for resolved style specifications
/// * [Mix], for style inheritance
class MixBuilder extends StatefulWidget {
  const MixBuilder({
    super.key,
    required this.style,
    required this.builder,
    this.inherit = false,
    this.orderOfModifiers = const [],
    this.controller,
  });

  /// The style to apply.
  final Style style;

  /// Whether to merge with inherited styles.
  ///
  /// Defaults to false.
  final bool inherit;

  /// The order for applying modifiers.
  ///
  /// Defaults to an empty list.
  final List<Type> orderOfModifiers;

  /// Optional controller for managing widget state.
  ///
  /// If null, an internal controller will be created when needed
  /// for widget state variants.
  final WidgetStatesController? controller;

  /// Builds the widget tree.
  ///
  /// Receives a [BuildContext] with access to resolved specs
  /// through [ComputedStyle.specOf].
  final Widget Function(BuildContext) builder;

  @override
  State<MixBuilder> createState() => _MixBuilderState();
}

class _MixBuilderState extends State<MixBuilder> {
  late Style _cachedStyle;
  late final WidgetStatesController _controller;

  /// Checks if the style contains widget state variants that require
  /// interactive state management.
  bool get _hasWidgetStateVariant => widget.style.variants.values
      .any((attr) => attr.variant is MixWidgetStateVariant);

  /// Determines if we should wrap with Interactable widget.
  bool get _shouldWrapWithInteractable =>
      _hasWidgetStateVariant || widget.controller != null;

  @override
  void initState() {
    super.initState();
    _cachedStyle = widget.style;
    _controller = widget.controller ?? WidgetStatesController();
  }

  @override
  void didUpdateWidget(MixBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.style != widget.style) {
      _cachedStyle = widget.style;
    }
  }

  @override
  void dispose() {
    // Only dispose controllers we created internally
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mix = MixData.create(context, _cachedStyle);

    // Apply inheritance
    if (widget.inherit) {
      final inherited = Mix.maybeOfInherited(context);
      if (inherited != null) {
        mix = inherited.merge(mix);
      }
    }

    final computedStyle = ComputedStyle.compute(mix);

    // Build core widget tree
    Widget result = Mix(
      data: mix,
      child: ComputedStyleProvider(
        style: computedStyle,
        child: Builder(
          builder: (context) {
            Widget child = Builder(builder: widget.builder);

            // Apply modifiers
            final modifiers = computedStyle.modifiers;
            if (modifiers.isNotEmpty) {
              child = computedStyle.isAnimated
                  ? RenderAnimatedModifiers(
                      modifiers: modifiers,
                      duration: computedStyle.animation!.duration,
                      mix: mix,
                      orderOfModifiers: widget.orderOfModifiers,
                      curve: computedStyle.animation!.curve,
                      onEnd: computedStyle.animation!.onEnd,
                      child: child,
                    )
                  : RenderModifiers(
                      modifiers: modifiers,
                      mix: mix,
                      orderOfModifiers: widget.orderOfModifiers,
                      child: child,
                    );
            }

            return child;
          },
        ),
      ),
    );

    // Only wrap with Interactable if needed and not already wrapped
    if (_shouldWrapWithInteractable && MixWidgetState.of(context) == null) {
      result = Interactable(controller: _controller, child: result);
    }

    return result;
  }
}
