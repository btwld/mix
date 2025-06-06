import 'package:flutter/widgets.dart';

import '../../../modifiers/internal/render_widget_modifier.dart';
import '../../../theme/mix/mix_theme.dart';
import '../../computed_style/computed_style.dart';
import '../../computed_style/computed_style_provider.dart';
import '../../factory/mix_data.dart';
import '../../factory/mix_provider.dart';
import '../../factory/style_mix.dart';

/// High-performance widget builder with [ComputedStyle] caching.
///
/// Creates [MixData] with inheritance support, computes [ComputedStyle], and
/// provides it via [ComputedStyleProvider] for efficient spec-specific rebuilds.
///
/// Implements intelligent caching to minimize expensive computations:
/// - Reuses computed styles when input [style] remains unchanged
/// - Invalidates cache when [style] or [inherit] flag changes
/// - Automatically releases cache when widget is disposed
///
/// This caching provides significant performance benefits for complex widgets
/// with frequent rebuilds, especially those using style inheritance.
///
/// - **O(1) spec lookups**: ComputedStyle pre-resolves all specs into a Map
/// - **Surgical rebuilds**: Widgets only rebuild when their specific spec changes
/// - **Reduced allocations**: Caching prevents recreating identical objects
///
/// Example:
/// ```dart
/// MixBuilder(
///   style: myStyle,
///   inherit: true,
///   builder: (context) {
///     // Only rebuilds when BoxSpec changes
///     final boxSpec = BoxSpec.of(context);
///     return Container(decoration: boxSpec.decoration);
///   },
/// )
/// ```
class MixBuilder extends StatefulWidget {
  const MixBuilder({
    super.key,
    this.inherit = false,
    required this.style,
    this.orderOfModifiers = const [],
    required this.builder,
  });

  /// Whether to inherit style from parent widgets.
  final bool inherit;

  /// The style to apply to the widget.
  final Style style;

  /// Order in which modifiers should be applied.
  final List<Type> orderOfModifiers;

  /// Function that builds the widget content.
  final Widget Function(BuildContext) builder;

  @override
  State<MixBuilder> createState() => _MixBuilderState();
}

class _MixBuilderState extends State<MixBuilder> {
  // Cache to avoid recreating on every build
  Style? _lastStyle;
  MixData? _cachedMixData;
  ComputedStyle? _cachedComputedStyle;
  MixThemeData? _lastTheme; // Add theme tracking

  void _invalidateCache() {
    _lastStyle = null;
    _cachedMixData = null;
    _cachedComputedStyle = null;
  }

  @override
  void didUpdateWidget(MixBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.style != widget.style ||
        oldWidget.inherit != widget.inherit) {
      _invalidateCache();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if theme has changed and invalidate cache if needed
    final currentTheme = MixTheme.maybeOf(context);
    if (_lastTheme != currentTheme) {
      _invalidateCache();
      _lastTheme = currentTheme;
    }

    // Step 1: Create or reuse MixData (handles inheritance)
    if (_cachedMixData == null || _lastStyle != widget.style) {
      // Create base MixData
      _cachedMixData = widget.style.of(context);

      // Handle inheritance at MixData level
      if (widget.inherit) {
        final inherited = Mix.maybeOfInherited(context);
        if (inherited != null) {
          _cachedMixData = inherited.merge(_cachedMixData!);
        }
      }

      // Step 2: Compute ComputedStyle from final MixData
      _cachedComputedStyle = ComputedStyle.compute(_cachedMixData!);
      _lastStyle = widget.style;
    }

    // Step 3: Provide both MixData (for inheritance) and ComputedStyle (for surgical rebuilds)
    return Mix(
      data: _cachedMixData,
      child: ComputedStyleProvider(
        style: _cachedComputedStyle!,
        child: Builder(
          builder: (context) {
            // Step 4: Build child with modifiers
            Widget child = Builder(builder: widget.builder);

            final modifiers = _cachedComputedStyle!.modifiers;
            if (modifiers.isNotEmpty) {
              child = _cachedComputedStyle!.isAnimated
                  ? RenderAnimatedModifiers(
                      modifiers: modifiers,
                      duration: _cachedComputedStyle!.animation!.duration,
                      mix: _cachedMixData!,
                      orderOfModifiers: widget.orderOfModifiers,
                      curve: _cachedComputedStyle!.animation!.curve,
                      onEnd: _cachedComputedStyle!.animation!.onEnd,
                      child: child,
                    )
                  : RenderModifiers(
                      modifiers: modifiers,
                      mix: _cachedMixData!,
                      orderOfModifiers: widget.orderOfModifiers,
                      child: child,
                    );
            }

            return child;
          },
        ),
      ),
    );
  }
}
