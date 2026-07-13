import 'package:flutter/widgets.dart';

/// Wraps [child] with a design system's token scope (e.g. `FortalScope`).
typedef AtlasThemeWrapper = Widget Function(BuildContext context, Widget child);

/// A design-system context under which atlases are rendered.
///
/// Themes are an atlas-level axis: the golden harness emits one image per
/// theme, and a live gallery renders the same list as a switcher.
@immutable
class AtlasTheme {
  /// Identifier used in golden file paths and the manifest.
  final String id;

  final String? label;

  /// Applied to the test window's platform brightness so context variants
  /// like `onDark` resolve correctly.
  final Brightness brightness;

  /// Canvas color painted behind the atlas.
  final Color background;

  /// Wraps the atlas with the design system's scope.
  final AtlasThemeWrapper builder;

  const AtlasTheme(
    this.id, {
    this.label,
    this.brightness = Brightness.light,
    required this.background,
    required this.builder,
  });
}
