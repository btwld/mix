import 'package:flutter/widgets.dart';

import 'api/ecosystem/tw_card_alert.dart' as tw_card_alert;
import 'api/animation/implicit.anim.counter.dart' as implicit_counter;
import 'api/animation/implicit.curved.hover.dart' as hover_scale;
import 'api/animation/implicit.curved.scale.dart' as auto_scale;
import 'api/animation/implicit.spring.translate.dart' as spring_anim;
import 'api/animation/keyframe.loop.scale_color.dart' as keyframe_loop;
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

/// A preview entry with metadata for multi-view embedding, gallery display,
/// and docs code snippets.
class PreviewEntry {
  /// Unique ID used for multi-view embedding (e.g., 'box-basic').
  final String previewId;

  /// Source file path used for docs snippet rendering.
  final String sourcePath;

  /// Display title for the gallery (e.g., 'Box - Basic').
  final String title;

  /// Short description of what this preview shows.
  final String description;

  /// Category for grouping in the gallery.
  final String category;

  /// Widget builder function.
  final WidgetBuilder builder;

  /// Optional named region for snippet extraction.
  final String? snippetRegion;

  /// Whether this entry should render as an interactive Flutter preview.
  final bool renderable;

  const PreviewEntry({
    required this.previewId,
    required this.sourcePath,
    required this.title,
    required this.description,
    required this.category,
    required this.builder,
    this.snippetRegion,
    this.renderable = true,
  });
}

/// Registry for preview widgets used in both multi-view embedding and the gallery.
///
/// Single source of truth for all preview definitions, preventing duplication
/// between multi-view mode and gallery mode.
///
/// Usage from JavaScript (multi-view):
/// ```javascript
/// app.addView({
///   hostElement: container,
///   initialData: { previewId: 'box-basic' }
/// });
/// ```
class PreviewRegistry {
  /// All available previews with full metadata.
  static const String _widgets = 'Widgets';

  static const String _variants = 'Context Variants';
  static const String _gradients = 'Gradients';
  static const String _tokens = 'Design System';
  static const String _animations = 'Animations';
  static const String _ecosystem = 'Ecosystem';
  static final List<PreviewEntry> _previews = [
    // Widget Examples
    PreviewEntry(
      previewId: 'box-basic',
      sourcePath: 'examples/lib/api/widgets/box/simple_box.dart',
      title: 'Box - Basic',
      description: 'Simple red box with rounded corners',
      category: _widgets,
      builder: (_) => const simple_box.Example(),
    ),
    PreviewEntry(
      previewId: 'box-gradient',
      sourcePath: 'examples/lib/api/widgets/box/gradient_box.dart',
      title: 'Box - Gradient',
      description: 'Box with gradient and shadow',
      category: _widgets,
      builder: (_) => const gradient_box.Example(),
    ),
    PreviewEntry(
      previewId: 'hbox-chip',
      sourcePath: 'examples/lib/api/widgets/hbox/icon_label_chip.dart',
      title: 'HBox - Horizontal Layout',
      description: 'Horizontal flex container with icon and text',
      category: _widgets,
      builder: (_) => const icon_label_chip.Example(),
    ),
    PreviewEntry(
      previewId: 'vbox-card',
      sourcePath: 'examples/lib/api/widgets/vbox/card_layout.dart',
      title: 'VBox - Vertical Layout',
      description: 'Vertical flex container with styled elements',
      category: _widgets,
      builder: (_) => const card_layout.Example(),
    ),
    PreviewEntry(
      previewId: 'zbox-layers',
      sourcePath: 'examples/lib/api/widgets/zbox/layered_boxes.dart',
      title: 'ZBox - Stack Layout',
      description: 'Stacked boxes with different alignments',
      category: _widgets,
      builder: (_) => const layered_boxes.Example(),
    ),
    PreviewEntry(
      previewId: 'icon-styled',
      sourcePath: 'examples/lib/api/widgets/icon/styled_icon.dart',
      title: 'Icon - Styled',
      description: 'Styled icon with custom size and color',
      category: _widgets,
      builder: (_) => const styled_icon.Example(),
    ),
    PreviewEntry(
      previewId: 'text-styled',
      sourcePath: 'examples/lib/api/widgets/text/styled_text.dart',
      title: 'Text - Styled',
      description: 'Styled text with custom typography',
      category: _widgets,
      builder: (_) => const styled_text.Example(),
    ),
    PreviewEntry(
      previewId: 'text-directives',
      sourcePath: 'examples/lib/api/text/text_directives.dart',
      title: 'Text - Directives',
      description:
          'Text transformations: uppercase, lowercase, capitalize, etc.',
      category: _widgets,
      builder: (_) => const text_directives.Example(),
    ),

    // Context Variants
    PreviewEntry(
      previewId: 'variant-hover',
      sourcePath: 'examples/lib/api/context_variants/hovered.dart',
      title: 'Hover State',
      description: 'Box that changes color on hover',
      category: _variants,
      builder: (_) => const hovered.Example(),
    ),
    PreviewEntry(
      previewId: 'variant-pressed',
      sourcePath: 'examples/lib/api/context_variants/pressed.dart',
      title: 'Press State',
      description: 'Box that changes color when pressed',
      category: _variants,
      builder: (_) => const pressed.Example(),
    ),
    PreviewEntry(
      previewId: 'variant-focused',
      sourcePath: 'examples/lib/api/context_variants/focused.dart',
      title: 'Focus State',
      description: 'Boxes that change color when focused',
      category: _variants,
      builder: (_) => const focused.Example(),
    ),
    PreviewEntry(
      previewId: 'variant-selected',
      sourcePath: 'examples/lib/api/context_variants/selected.dart',
      title: 'Selected State',
      description: 'Box that toggles selected state',
      category: _variants,
      builder: (_) => const selected.Example(),
    ),
    PreviewEntry(
      previewId: 'variant-disabled',
      sourcePath: 'examples/lib/api/context_variants/disabled.dart',
      title: 'Disabled State',
      description: 'Disabled box with grey color',
      category: _variants,
      builder: (_) => const disabled.Example(),
    ),
    PreviewEntry(
      previewId: 'variant-dark-light',
      sourcePath: 'examples/lib/api/context_variants/on_dark_light.dart',
      title: 'Dark/Light Theme',
      description: 'Boxes that adapt to theme changes',
      category: _variants,
      builder: (_) => const dark_light.Example(),
    ),
    PreviewEntry(
      previewId: 'variant-selected-toggle',
      sourcePath: 'examples/lib/api/context_variants/selected_toggle.dart',
      title: 'Selected Toggle',
      description: 'Beautiful toggle button with selected state',
      category: _variants,
      builder: (_) => const selected_toggle.Example(),
    ),
    PreviewEntry(
      previewId: 'variant-responsive',
      sourcePath: 'examples/lib/api/context_variants/responsive_size.dart',
      title: 'Responsive Size',
      description: 'Dynamic sizing based on screen width',
      category: _variants,
      builder: (_) => const responsive_size.Example(),
    ),

    // Gradients
    PreviewEntry(
      previewId: 'gradient-linear',
      sourcePath: 'examples/lib/api/gradients/gradient_linear.dart',
      title: 'Linear Gradient',
      description: 'Beautiful purple-to-pink gradient with shadow',
      category: _gradients,
      builder: (_) => const gradient_linear.Example(),
    ),
    PreviewEntry(
      previewId: 'gradient-radial',
      sourcePath: 'examples/lib/api/gradients/gradient_radial.dart',
      title: 'Radial Gradient',
      description: 'Orange radial gradient with focal points',
      category: _gradients,
      builder: (_) => const gradient_radial.Example(),
    ),
    PreviewEntry(
      previewId: 'gradient-sweep',
      sourcePath: 'examples/lib/api/gradients/gradient_sweep.dart',
      title: 'Sweep Gradient',
      description: 'Colorful sweep gradient creating rainbow effect',
      category: _gradients,
      builder: (_) => const gradient_sweep.Example(),
    ),

    // Design Tokens
    PreviewEntry(
      previewId: 'tokens-theme',
      sourcePath: 'examples/lib/api/design_tokens/theme_tokens.dart',
      title: 'Design Tokens',
      description: 'Using design tokens for consistent styling',
      category: _tokens,
      builder: (_) => const theme_tokens.Example(),
    ),

    // Animations
    PreviewEntry(
      previewId: 'implicit-anim-counter',
      sourcePath: 'examples/lib/api/animation/implicit.anim.counter.dart',
      title: 'State-triggered Implicit Animation',
      description: 'Square grows each time you tap it',
      category: _animations,
      builder: (_) => const implicit_counter.Example(),
    ),
    PreviewEntry(
      previewId: 'anim-hover-scale',
      sourcePath: 'examples/lib/api/animation/implicit.curved.hover.dart',
      title: 'Hover Scale Animation',
      description: 'Box that scales up smoothly when hovered',
      category: _animations,
      builder: (_) => const hover_scale.Example(),
    ),
    PreviewEntry(
      previewId: 'anim-auto-scale',
      sourcePath: 'examples/lib/api/animation/implicit.curved.scale.dart',
      title: 'Auto Scale Animation',
      description: 'Box that automatically scales on load',
      category: _animations,
      builder: (_) => const auto_scale.Example(),
    ),
    PreviewEntry(
      previewId: 'anim-tap-phase',
      sourcePath: 'examples/lib/api/animation/phase.compress.dart',
      title: 'Tap Phase Animation',
      description: 'Multi-phase animation triggered by tap',
      category: _animations,
      builder: (_) => const tap_phase.BlockAnimation(),
    ),
    PreviewEntry(
      previewId: 'anim-keyframe-loop',
      sourcePath: 'examples/lib/api/animation/keyframe.loop.scale_color.dart',
      title: 'Keyframe Loop (scale + color + opacity)',
      description: 'Looping keyframe animation with multiple tracks',
      category: _animations,
      builder: (_) => const keyframe_loop.Example(),
    ),
    PreviewEntry(
      previewId: 'anim-switch',
      sourcePath: 'examples/lib/api/animation/keyframe.switch.dart',
      title: 'Animated Switch',
      description: 'Toggle switch with phase-based animation',
      category: _animations,
      builder: (_) => const animated_switch.SwitchAnimation(),
    ),
    PreviewEntry(
      previewId: 'anim-spring',
      sourcePath: 'examples/lib/api/animation/implicit.spring.translate.dart',
      title: 'Spring Animation',
      description: 'Bouncy spring physics animation',
      category: _animations,
      builder: (_) => const spring_anim.Example(),
    ),

    // Ecosystem
    PreviewEntry(
      previewId: 'tw-card-alert',
      sourcePath: 'examples/lib/api/ecosystem/tw_card_alert.dart',
      title: 'mix_tailwinds - Card Alert',
      description: 'Notification card with gradient avatar and action buttons',
      category: _ecosystem,
      snippetRegion: 'example',
      builder: (_) => const tw_card_alert.Example(),
    ),
  ];

  /// Index for fast preview ID lookup.
  static final Map<String, PreviewEntry> _byPreviewId = _buildPreviewIdIndex(
    _previews,
  );

  const PreviewRegistry._();

  /// Gets a preview entry by ID.
  static PreviewEntry? getByPreviewId(String previewId) =>
      _byPreviewId[previewId];

  static Map<String, PreviewEntry> _buildPreviewIdIndex(
    List<PreviewEntry> previews,
  ) {
    final previewIdIndex = <String, PreviewEntry>{};
    final sourceIndex = <String, PreviewEntry>{};

    for (final preview in previews) {
      if (previewIdIndex.containsKey(preview.previewId)) {
        final existing = previewIdIndex[preview.previewId]!;
        throw StateError(
          'Duplicate previewId "${preview.previewId}" for '
          '"${existing.sourcePath}" and "${preview.sourcePath}".',
        );
      }

      if (sourceIndex.containsKey(preview.sourcePath)) {
        final existing = sourceIndex[preview.sourcePath]!;
        throw StateError(
          'Duplicate sourcePath "${preview.sourcePath}" for previews '
          '"${existing.previewId}" and "${preview.previewId}".',
        );
      }

      previewIdIndex[preview.previewId] = preview;
      sourceIndex[preview.sourcePath] = preview;
    }

    return previewIdIndex;
  }

  /// All registered previews.
  static List<PreviewEntry> get all => _previews;

  /// Returns all available preview IDs.
  static List<String> get availablePreviewIds => _byPreviewId.keys.toList();

  /// Returns manifest entries for website/docs consumption.
  static List<Map<String, Object?>> get manifestEntries {
    return _previews
        .map((preview) {
          return <String, Object?>{
            'previewId': preview.previewId,
            'sourcePath': preview.sourcePath,
            'snippetRegion': preview.snippetRegion,
            'title': preview.title,
            'description': preview.description,
            'category': preview.category,
            'renderable': preview.renderable,
          };
        })
        .toList(growable: false);
  }

  /// Builds a widget for the given preview ID.
  ///
  /// Returns an error widget if the preview ID is not found or if the preview
  /// widget throws during construction.
  static Widget build(String? previewId, BuildContext context) {
    if (previewId == null || previewId.isEmpty) {
      return const _UnknownPreview(previewId: 'null');
    }

    final entry = _byPreviewId[previewId];
    if (entry == null) {
      return _UnknownPreview(previewId: previewId);
    }

    try {
      return entry.builder(context);
    } catch (e, stackTrace) {
      debugPrint('Preview "$previewId" construction error: $e');

      return _ErrorPreview(
        previewId: previewId,
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}

/// Widget displayed when an unknown preview ID is requested.
class _UnknownPreview extends StatelessWidget {
  const _UnknownPreview({required this.previewId});

  final String previewId;

  @override
  Widget build(BuildContext context) {
    final sanitizedId = previewId.length > 100
        ? '${previewId.substring(0, 100)}...'
        : previewId;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Unknown previewId: $sanitizedId\n\n'
          'Available previewIds:\n'
          '${PreviewRegistry.availablePreviewIds.join('\n')}',
          style: const TextStyle(color: Color(0xFFEF4444), fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

/// Widget displayed when a preview throws an error.
class _ErrorPreview extends StatelessWidget {
  const _ErrorPreview({
    required this.previewId,
    required this.error,
    this.stackTrace,
  });

  final String previewId;
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
              '⚠️ Preview Error',
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Preview: $previewId',
              style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: const TextStyle(color: Color(0xFFEF4444), fontSize: 12),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
