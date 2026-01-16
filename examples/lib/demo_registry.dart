import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'api/animation/implicit.curved.hover.dart' as hover_scale;
import 'api/animation/implicit.curved.scale.dart' as auto_scale;
import 'api/animation/implicit.spring.translate.dart' as spring_anim;
import 'api/animation/keyframe.switch.dart' as animated_switch;
import 'api/animation/phase.compress.dart' as tap_phase;
import 'api/context_variants/disabled.dart' as disabled;
import 'api/context_variants/focused.dart' as focused;
import 'api/context_variants/hovered.dart' as hovered;
import 'api/context_variants/on_dark_light.dart' as dark_light;
import 'api/context_variants/pressed.dart' as pressed;
import 'api/context_variants/responsive_size.dart' as responsive_size;
import 'api/context_variants/selected.dart' as selected;
import 'api/context_variants/selected_toggle.dart' as selected_toggle;
import 'api/design_tokens/theme_tokens.dart' as theme_tokens;
import 'api/gradients/gradient_linear.dart' as gradient_linear;
import 'api/gradients/gradient_radial.dart' as gradient_radial;
import 'api/gradients/gradient_sweep.dart' as gradient_sweep;
import 'api/text/text_directives.dart' as text_directives;
import 'api/widgets/box/gradient_box.dart' as gradient_box;
import 'api/widgets/box/simple_box.dart' as simple_box;
import 'api/widgets/hbox/icon_label_chip.dart' as icon_label_chip;
import 'api/widgets/icon/styled_icon.dart' as styled_icon;
import 'api/widgets/text/styled_text.dart' as styled_text;
import 'api/widgets/vbox/card_layout.dart' as card_layout;
import 'api/widgets/zbox/layered_boxes.dart' as layered_boxes;

/// Registry for demo widgets used in multi-view embedding.
///
/// Maps demo IDs (strings) to widget builders, enabling Flutter's multi-view
/// mode to render specific demos based on initialData from JavaScript.
///
/// Usage from JavaScript:
/// ```javascript
/// app.addView({
///   hostElement: container,
///   initialData: { demoId: 'box-basic' }
/// });
/// ```
class DemoRegistry {
  DemoRegistry._();

  /// All available demo widgets mapped by their ID.
  static final Map<String, WidgetBuilder> _demos = {
    // Widget Examples
    'box-basic': (_) => const simple_box.Example(),
    'box-gradient': (_) => const gradient_box.Example(),
    'hbox-chip': (_) => const icon_label_chip.Example(),
    'vbox-card': (_) => const card_layout.Example(),
    'zbox-layers': (_) => const layered_boxes.Example(),
    'icon-styled': (_) => const styled_icon.Example(),
    'text-styled': (_) => const styled_text.Example(),
    'text-directives': (_) => const text_directives.Example(),

    // Context Variants
    'variant-hover': (_) => const hovered.Example(),
    'variant-pressed': (_) => const pressed.Example(),
    'variant-focused': (_) => const focused.Example(),
    'variant-selected': (_) => const selected.Example(),
    'variant-disabled': (_) => const disabled.Example(),
    'variant-dark-light': (_) => const dark_light.Example(),
    'variant-selected-toggle': (_) => const selected_toggle.Example(),
    'variant-responsive': (_) => const responsive_size.Example(),

    // Gradients
    'gradient-linear': (_) => const gradient_linear.Example(),
    'gradient-radial': (_) => const gradient_radial.Example(),
    'gradient-sweep': (_) => const gradient_sweep.Example(),

    // Design Tokens
    'tokens-theme': (_) => const theme_tokens.Example(),

    // Animations
    'anim-hover-scale': (_) => const hover_scale.Example(),
    'anim-auto-scale': (_) => const auto_scale.Example(),
    'anim-tap-phase': (_) => const tap_phase.BlockAnimation(),
    'anim-switch': (_) => const animated_switch.SwitchAnimation(),
    'anim-spring': (_) => const spring_anim.Example(),
  };

  /// Builds a widget for the given demo ID.
  ///
  /// Returns an error widget if the demo ID is not found or if the demo
  /// widget throws during construction.
  static Widget build(String? demoId, BuildContext context) {
    if (demoId == null || demoId.isEmpty) {
      return const _UnknownDemo(demoId: 'null');
    }

    final builder = _demos[demoId];
    if (builder == null) {
      return _UnknownDemo(demoId: demoId);
    }

    // Wrap in error boundary to catch build errors
    try {
      return _DemoErrorBoundary(
        demoId: demoId,
        child: builder(context),
      );
    } catch (e, stackTrace) {
      return _ErrorDemo(demoId: demoId, error: e, stackTrace: stackTrace);
    }
  }

  /// Returns a list of all available demo IDs.
  static List<String> get availableDemos => _demos.keys.toList();

  /// Checks if a demo ID exists in the registry.
  static bool hasDemo(String demoId) => _demos.containsKey(demoId);
}

/// Widget displayed when an unknown demo ID is requested.
class _UnknownDemo extends StatelessWidget {
  const _UnknownDemo({required this.demoId});

  final String demoId;

  @override
  Widget build(BuildContext context) {
    // Sanitize demoId to prevent excessively long strings
    final sanitizedId =
        demoId.length > 100 ? '${demoId.substring(0, 100)}...' : demoId;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Unknown demo: $sanitizedId\n\n'
          'Available demos:\n'
          '${DemoRegistry.availableDemos.join('\n')}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFEF4444),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

/// Error boundary widget that catches errors during build.
class _DemoErrorBoundary extends StatefulWidget {
  const _DemoErrorBoundary({
    required this.demoId,
    required this.child,
  });

  final String demoId;
  final Widget child;

  @override
  State<_DemoErrorBoundary> createState() => _DemoErrorBoundaryState();
}

class _DemoErrorBoundaryState extends State<_DemoErrorBoundary> {
  Object? _error;
  StackTrace? _stackTrace;
  FlutterExceptionHandler? _previousErrorHandler;

  @override
  void initState() {
    super.initState();
    // Set up error handler for this widget tree
    _previousErrorHandler = FlutterError.onError;
    FlutterError.onError = (details) {
      if (mounted) {
        setState(() {
          _error = details.exception;
          _stackTrace = details.stack;
        });
      }
      _previousErrorHandler?.call(details);
    };
  }

  @override
  void dispose() {
    FlutterError.onError = _previousErrorHandler;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return _ErrorDemo(
        demoId: widget.demoId,
        error: _error!,
        stackTrace: _stackTrace,
      );
    }
    return widget.child;
  }
}

/// Widget displayed when a demo throws an error.
class _ErrorDemo extends StatelessWidget {
  const _ErrorDemo({
    required this.demoId,
    required this.error,
    this.stackTrace,
  });

  final String demoId;
  final Object error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '⚠️ Demo Error',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Demo: $demoId',
              style: const TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFEF4444),
                fontSize: 12,
              ),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
