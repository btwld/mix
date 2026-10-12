import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'theme_data.dart';

/// Installs a [UiThemeData] for a subtree.
///
/// Two things are installed together on purpose:
///
/// * [UiTheme], so application code can read the raw values through
///   [UiTheme.of];
/// * a `MixScope` carrying the same values keyed by `UiTokens`, so every Mix
///   styler resolved below this point sees them.
///
/// Each supplied theme replaces the values for its appearance. An empty nested
/// scope inherits the parent pair and selection; individual tokens do not merge.
class UiThemeScope extends StatelessWidget {
  /// A root follows the system and supplies both preset defaults.
  /// A custom theme without [darkTheme] is used in both modes.
  /// Nested scopes inherit the configured pair and active selection.
  const UiThemeScope({
    super.key,
    this.theme,
    this.darkTheme,
    this.mode,
    required this.child,
  });

  /// Values used for the light appearance, and for both when [darkTheme] is
  /// omitted.
  final UiThemeData? theme;

  /// Values used for the dark appearance.
  final UiThemeData? darkTheme;

  /// Appearance selection. A null mode inherits the ancestor's selection, or
  /// follows the system at the root.
  final UiThemeMode? mode;

  /// The subtree that resolves against the selected theme.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // `mode: system` needs a platform brightness. A scope mounted above any
    // MediaQuery still has to resolve, so supply one from the view.
    final view = View.maybeOf(context);
    if (MediaQuery.maybeOf(context) == null && view != null) {
      return MediaQuery.fromView(
        view: view,
        child: Builder(builder: _build),
      );
    }

    return _build(context);
  }

  Widget _build(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<UiTheme>();
    final base =
        theme ??
        inherited?.baseTheme ??
        inherited?.data ??
        const UiThemeData.light();
    final dark =
        darkTheme ??
        (theme != null
            ? theme!
            : inherited?.darkTheme ??
                  inherited?.data ??
                  const UiThemeData.dark());
    final useDark = mode == null && inherited != null
        ? inherited.usesDarkTheme
        : switch (mode ?? UiThemeMode.system) {
            UiThemeMode.light => false,
            UiThemeMode.dark => true,
            UiThemeMode.system =>
              (MediaQuery.maybePlatformBrightnessOf(context) ??
                      Brightness.light) ==
                  Brightness.dark,
          };
    final selected = useDark ? dark : base;

    return UiTheme(
      data: selected,
      baseTheme: base,
      darkTheme: dark,
      useDarkTheme: useDark,
      child: MixScope(tokens: selected.tokens, child: child),
    );
  }
}

/// The inherited half of [UiThemeScope].
///
/// Prefer [UiThemeScope]; this is public because `UiTheme.of` is how widgets
/// read theme values that are not expressed as Mix styles, and because
/// `InheritedTheme.wrap` has to be able to rebuild it across a route
/// boundary.
class UiTheme extends InheritedTheme {
  /// Creates the inherited theme holding [data].
  const UiTheme({
    super.key,
    required this.data,
    this.baseTheme,
    this.darkTheme,
    this.useDarkTheme,
    required super.child,
  });

  /// The theme values available to [child].
  final UiThemeData data;

  /// The configured light values, carried so a nested scope can inherit them.
  final UiThemeData? baseTheme;

  /// The configured dark values, carried so a nested scope can inherit them.
  final UiThemeData? darkTheme;

  /// The active selection, carried so a nested scope can inherit it.
  final bool? useDarkTheme;

  /// Whether the dark half of the configured pair is currently selected.
  bool get usesDarkTheme => useDarkTheme ?? data.brightness == Brightness.dark;

  /// The closest [UiThemeData], or `null` when no scope is installed.
  static UiThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UiTheme>()?.data;

  /// The closest [UiThemeData].
  ///
  /// Throws when no [UiThemeScope] is installed above [context]; use
  /// [maybeOf] when absence is a valid state.
  static UiThemeData of(BuildContext context) {
    final data = maybeOf(context);
    if (data != null) return data;

    throw FlutterError.fromParts([
      ErrorSummary('No UiTheme found.'),
      ErrorDescription(
        '${context.widget.runtimeType} tried to read the UI theme, but no '
        'UiThemeScope was found above it.',
      ),
      context.describeElement('The context used was'),
    ]);
  }

  /// Rebuilds the theme *and* its Mix scope for a captured subtree.
  ///
  /// `InheritedTheme.capture` only carries `InheritedTheme`s across a route
  /// boundary. `MixScope` is a plain `InheritedModel`, so without rebuilding
  /// it here a captured subtree would keep the theme values and lose the
  /// token values that recipes actually resolve.
  @override
  Widget wrap(BuildContext context, Widget child) {
    return UiTheme(
      data: data,
      baseTheme: baseTheme,
      darkTheme: darkTheme,
      useDarkTheme: useDarkTheme,
      child: MixScope(tokens: data.tokens, child: child),
    );
  }

  @override
  bool updateShouldNotify(UiTheme oldWidget) =>
      data != oldWidget.data ||
      baseTheme != oldWidget.baseTheme ||
      darkTheme != oldWidget.darkTheme ||
      useDarkTheme != oldWidget.useDarkTheme;
}
