import 'package:remix/remix.dart';

/// Semantic design tokens owned by the application.
///
/// Remix ships no theme, so the names below are the application's vocabulary,
/// not a Remix contract. A [MixToken] is only an identity: the concrete value
/// comes from whichever `MixScope` is active, which `UiThemeScope` installs
/// from a `UiThemeData`. Editing, renaming, or adding a token here is a
/// local change — nothing in Remix reads these names.
///
/// ```dart
/// ButtonStyler().color(UiTokens.primary());
/// ```
abstract final class UiTokens {
  /// Page background the application paints behind its content.
  static const background = ColorToken('ui.color.background');

  /// Default content color used on top of [background].
  static const foreground = ColorToken('ui.color.foreground');

  /// Highest-emphasis fill.
  static const primary = ColorToken('ui.color.primary');

  /// Content color used on top of [primary].
  static const primaryForeground = ColorToken('ui.color.primary-foreground');

  /// Medium-emphasis fill.
  static const secondary = ColorToken('ui.color.secondary');

  /// Content color used on top of [secondary].
  static const secondaryForeground = ColorToken(
    'ui.color.secondary-foreground',
  );

  /// De-emphasized surface.
  static const muted = ColorToken('ui.color.muted');

  /// De-emphasized content color.
  ///
  /// Despite the name, the shipped themes do **not** clear the 4.5:1 text
  /// floor against [muted] — the pair measures 4.35:1 in the light theme. Use
  /// it for text on [background], and for glyphs and other non-text marks
  /// anywhere; text that lands on a `muted` surface takes [foreground]. Raise
  /// this value here and that restriction goes away everywhere at once.
  static const mutedForeground = ColorToken('ui.color.muted-foreground');

  /// Interaction surface for otherwise transparent controls.
  static const accent = ColorToken('ui.color.accent');

  /// Content color used on top of [accent].
  static const accentForeground = ColorToken('ui.color.accent-foreground');

  /// Destructive fill for irreversible actions.
  static const destructive = ColorToken('ui.color.destructive');

  /// Content color used on top of [destructive].
  static const destructiveForeground = ColorToken(
    'ui.color.destructive-foreground',
  );

  /// Hairline separator and control outline color.
  static const border = ColorToken('ui.color.border');

  /// Focus ring color drawn for keyboard focus.
  ///
  /// The shipped themes give this the same value as [mutedForeground], which
  /// is a coincidence worth keeping: a neutral ring reads as the platform
  /// talking rather than the brand, and it clears the 3:1 non-text floor on
  /// both pages. Give it a brand color here and every control's focus ring
  /// follows; nothing else reads this token.
  static const focusRing = ColorToken('ui.color.focus-ring');

  /// First categorical chart series color.
  ///
  /// Charts assign [chart1] through [chart5] to series in order; see [chart].
  /// The shipped themes keep one hue per series in both brightnesses, and
  /// every value clears 4.5:1 against [background]. That also keeps pie labels,
  /// which are drawn in [background], readable on their slice.
  static const chart1 = ColorToken('ui.color.chart-1');

  /// Second categorical chart series color. See [chart1].
  static const chart2 = ColorToken('ui.color.chart-2');

  /// Third categorical chart series color. See [chart1].
  static const chart3 = ColorToken('ui.color.chart-3');

  /// Fourth categorical chart series color. See [chart1].
  static const chart4 = ColorToken('ui.color.chart-4');

  /// Fifth categorical chart series color. See [chart1].
  static const chart5 = ColorToken('ui.color.chart-5');

  /// Corner radius shared by the application's controls.
  static const radius = RadiusToken('ui.radius');

  /// The chart series colors in the order charts assign them.
  static const chart = <ColorToken>[chart1, chart2, chart3, chart4, chart5];

  /// Every color token this layer defines, in declaration order.
  ///
  /// `UiThemeData` builds its scope map from this list, so a token added here
  /// and to `UiThemeData` cannot be forgotten in the scope.
  static const colors = <ColorToken>[
    background,
    foreground,
    primary,
    primaryForeground,
    secondary,
    secondaryForeground,
    muted,
    mutedForeground,
    accent,
    accentForeground,
    destructive,
    destructiveForeground,
    border,
    focusRing,
    chart1,
    chart2,
    chart3,
    chart4,
    chart5,
  ];
}
