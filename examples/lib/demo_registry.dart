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

/// A demo entry with metadata for both multi-view embedding and gallery display.
class DemoEntry {
  const DemoEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.builder,
  });

  /// Unique ID used for multi-view embedding (e.g., 'box-basic').
  final String id;

  /// Display title for the gallery (e.g., 'Box - Basic').
  final String title;

  /// Short description of what this demo shows.
  final String description;

  /// Category for grouping in the gallery.
  final String category;

  /// Widget builder function.
  final WidgetBuilder builder;
}

/// Registry for demo widgets used in both multi-view embedding and the gallery.
///
/// Single source of truth for all demo definitions, preventing duplication
/// between multi-view mode and gallery mode.
///
/// Usage from JavaScript (multi-view):
/// ```javascript
/// app.addView({
///   hostElement: container,
///   initialData: { demoId: 'box-basic' }
/// });
/// ```
class DemoRegistry {
  DemoRegistry._();

  /// All available demos with full metadata.
  static const String _widgets = 'Widgets';
  static const String _variants = 'Context Variants';
  static const String _gradients = 'Gradients';
  static const String _tokens = 'Design System';
  static const String _animations = 'Animations';

  static final List<DemoEntry> _demos = [
    // Widget Examples
    DemoEntry(
      id: 'box-basic',
      title: 'Box - Basic',
      description: 'Simple red box with rounded corners',
      category: _widgets,
      builder: (_) => const simple_box.Example(),
    ),
    DemoEntry(
      id: 'box-gradient',
      title: 'Box - Gradient',
      description: 'Box with gradient and shadow',
      category: _widgets,
      builder: (_) => const gradient_box.Example(),
    ),
    DemoEntry(
      id: 'hbox-chip',
      title: 'HBox - Horizontal Layout',
      description: 'Horizontal flex container with icon and text',
      category: _widgets,
      builder: (_) => const icon_label_chip.Example(),
    ),
    DemoEntry(
      id: 'vbox-card',
      title: 'VBox - Vertical Layout',
      description: 'Vertical flex container with styled elements',
      category: _widgets,
      builder: (_) => const card_layout.Example(),
    ),
    DemoEntry(
      id: 'zbox-layers',
      title: 'ZBox - Stack Layout',
      description: 'Stacked boxes with different alignments',
      category: _widgets,
      builder: (_) => const layered_boxes.Example(),
    ),
    DemoEntry(
      id: 'icon-styled',
      title: 'Icon - Styled',
      description: 'Styled icon with custom size and color',
      category: _widgets,
      builder: (_) => const styled_icon.Example(),
    ),
    DemoEntry(
      id: 'text-styled',
      title: 'Text - Styled',
      description: 'Styled text with custom typography',
      category: _widgets,
      builder: (_) => const styled_text.Example(),
    ),
    DemoEntry(
      id: 'text-directives',
      title: 'Text - Directives',
      description: 'Text transformations: uppercase, lowercase, capitalize, etc.',
      category: _widgets,
      builder: (_) => const text_directives.Example(),
    ),

    // Context Variants
    DemoEntry(
      id: 'variant-hover',
      title: 'Hover State',
      description: 'Box that changes color on hover',
      category: _variants,
      builder: (_) => const hovered.Example(),
    ),
    DemoEntry(
      id: 'variant-pressed',
      title: 'Press State',
      description: 'Box that changes color when pressed',
      category: _variants,
      builder: (_) => const pressed.Example(),
    ),
    DemoEntry(
      id: 'variant-focused',
      title: 'Focus State',
      description: 'Boxes that change color when focused',
      category: _variants,
      builder: (_) => const focused.Example(),
    ),
    DemoEntry(
      id: 'variant-selected',
      title: 'Selected State',
      description: 'Box that toggles selected state',
      category: _variants,
      builder: (_) => const selected.Example(),
    ),
    DemoEntry(
      id: 'variant-disabled',
      title: 'Disabled State',
      description: 'Disabled box with grey color',
      category: _variants,
      builder: (_) => const disabled.Example(),
    ),
    DemoEntry(
      id: 'variant-dark-light',
      title: 'Dark/Light Theme',
      description: 'Boxes that adapt to theme changes',
      category: _variants,
      builder: (_) => const dark_light.Example(),
    ),
    DemoEntry(
      id: 'variant-selected-toggle',
      title: 'Selected Toggle',
      description: 'Beautiful toggle button with selected state',
      category: _variants,
      builder: (_) => const selected_toggle.Example(),
    ),
    DemoEntry(
      id: 'variant-responsive',
      title: 'Responsive Size',
      description: 'Dynamic sizing based on screen width',
      category: _variants,
      builder: (_) => const responsive_size.Example(),
    ),

    // Gradients
    DemoEntry(
      id: 'gradient-linear',
      title: 'Linear Gradient',
      description: 'Beautiful purple-to-pink gradient with shadow',
      category: _gradients,
      builder: (_) => const gradient_linear.Example(),
    ),
    DemoEntry(
      id: 'gradient-radial',
      title: 'Radial Gradient',
      description: 'Orange radial gradient with focal points',
      category: _gradients,
      builder: (_) => const gradient_radial.Example(),
    ),
    DemoEntry(
      id: 'gradient-sweep',
      title: 'Sweep Gradient',
      description: 'Colorful sweep gradient creating rainbow effect',
      category: _gradients,
      builder: (_) => const gradient_sweep.Example(),
    ),

    // Design Tokens
    DemoEntry(
      id: 'tokens-theme',
      title: 'Design Tokens',
      description: 'Using design tokens for consistent styling',
      category: _tokens,
      builder: (_) => const theme_tokens.Example(),
    ),

    // Animations
    DemoEntry(
      id: 'anim-hover-scale',
      title: 'Hover Scale Animation',
      description: 'Box that scales up smoothly when hovered',
      category: _animations,
      builder: (_) => const hover_scale.Example(),
    ),
    DemoEntry(
      id: 'anim-auto-scale',
      title: 'Auto Scale Animation',
      description: 'Box that automatically scales on load',
      category: _animations,
      builder: (_) => const auto_scale.Example(),
    ),
    DemoEntry(
      id: 'anim-tap-phase',
      title: 'Tap Phase Animation',
      description: 'Multi-phase animation triggered by tap',
      category: _animations,
      builder: (_) => const tap_phase.BlockAnimation(),
    ),
    DemoEntry(
      id: 'anim-switch',
      title: 'Animated Switch',
      description: 'Toggle switch with phase-based animation',
      category: _animations,
      builder: (_) => const animated_switch.SwitchAnimation(),
    ),
    DemoEntry(
      id: 'anim-spring',
      title: 'Spring Animation',
      description: 'Bouncy spring physics animation',
      category: _animations,
      builder: (_) => const spring_anim.Example(),
    ),
  ];

  /// Index for fast ID lookup.
  static final Map<String, DemoEntry> _byId = {
    for (final demo in _demos) demo.id: demo,
  };

  /// All registered demos.
  static List<DemoEntry> get all => _demos;

  /// Builds a widget for the given demo ID.
  ///
  /// Returns an error widget if the demo ID is not found or if the demo
  /// widget throws during construction.
  static Widget build(String? demoId, BuildContext context) {
    if (demoId == null || demoId.isEmpty) {
      return const _UnknownDemo(demoId: 'null');
    }

    final entry = _byId[demoId];
    if (entry == null) {
      return _UnknownDemo(demoId: demoId);
    }

    // Build with error handling for construction errors
    try {
      return entry.builder(context);
    } catch (e, stackTrace) {
      debugPrint('Demo "$demoId" construction error: $e');
      return _ErrorDemo(demoId: demoId, error: e, stackTrace: stackTrace);
    }
  }

  /// Returns a list of all available demo IDs.
  static List<String> get availableDemos => _byId.keys.toList();

  /// Checks if a demo ID exists in the registry.
  static bool hasDemo(String demoId) => _byId.containsKey(demoId);

  /// Gets a demo entry by ID.
  static DemoEntry? getById(String demoId) => _byId[demoId];
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
