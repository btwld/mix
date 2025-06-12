import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../material/material_theme.dart';
import '../tokens/breakpoints_token.dart';
import '../tokens/color_token.dart';
import '../tokens/mix_token.dart';
import '../tokens/radius_token.dart';
import '../tokens/space_token.dart';
import '../tokens/text_style_token.dart';
import '../tokens/value_resolver.dart';

class MixTheme extends InheritedWidget {
  const MixTheme({required this.data, super.key, required super.child});

  static MixThemeData of(BuildContext context) {
    final themeData =
        context.dependOnInheritedWidgetOfExactType<MixTheme>()?.data;

    assert(themeData != null, 'No MixTheme found in context');

    return themeData!;
  }

  static MixThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MixTheme>()?.data;
  }

  final MixThemeData data;

  @override
  bool updateShouldNotify(MixTheme oldWidget) => data != oldWidget.data;
}

@immutable
class MixThemeData {
  /// Legacy token storage for backward compatibility
  final StyledTokens<RadiusToken, Radius> radii;
  final StyledTokens<ColorToken, Color> colors;
  final StyledTokens<TextStyleToken, TextStyle> textStyles;
  final StyledTokens<BreakpointToken, Breakpoint> breakpoints;
  final StyledTokens<SpaceToken, double> spaces;

  /// Unified token storage for new MixToken<T> system
  /// Maps MixToken<T> objects to ValueResolver<T> for type-safe resolution
  final Map<MixToken, ValueResolver>? tokens;

  final List<Type>? defaultOrderOfModifiers;

  const MixThemeData.raw({
    required this.textStyles,
    required this.colors,
    required this.breakpoints,
    required this.radii,
    required this.spaces,
    this.tokens,
    this.defaultOrderOfModifiers,
  });

  const MixThemeData.empty()
      : this.raw(
          textStyles: const StyledTokens.empty(),
          colors: const StyledTokens.empty(),
          breakpoints: const StyledTokens.empty(),
          radii: const StyledTokens.empty(),
          spaces: const StyledTokens.empty(),
          tokens: null,
          defaultOrderOfModifiers: null,
        );

  factory MixThemeData({
    Map<BreakpointToken, Breakpoint>? breakpoints,
    Map<ColorToken, Color>? colors,
    Map<SpaceToken, double>? spaces,
    Map<TextStyleToken, TextStyle>? textStyles,
    Map<RadiusToken, Radius>? radii,
    Map<MixToken, ValueResolver>? tokens,
    List<Type>? defaultOrderOfModifiers,
  }) {
    return MixThemeData.raw(
      textStyles: StyledTokens(textStyles ?? const {}),
      colors: StyledTokens(colors ?? const {}),
      breakpoints:
          _breakpointTokenMap.merge(StyledTokens(breakpoints ?? const {})),
      radii: StyledTokens(radii ?? const {}),
      spaces: StyledTokens(spaces ?? const {}),
      tokens: tokens,
      defaultOrderOfModifiers: defaultOrderOfModifiers,
    );
  }

  factory MixThemeData.withMaterial({
    Map<BreakpointToken, Breakpoint>? breakpoints,
    Map<ColorToken, Color>? colors,
    Map<SpaceToken, double>? spaces,
    Map<TextStyleToken, TextStyle>? textStyles,
    Map<RadiusToken, Radius>? radii,
    Map<MixToken, ValueResolver>? tokens,
    List<Type>? defaultOrderOfModifiers,
  }) {
    return materialMixTheme.merge(
      MixThemeData(
        breakpoints: breakpoints,
        colors: colors,
        spaces: spaces,
        textStyles: textStyles,
        radii: radii,
        tokens: tokens,
        defaultOrderOfModifiers: defaultOrderOfModifiers,
      ),
    );
  }

  /// Factory for unified tokens using automatic resolver creation
  factory MixThemeData.unified({
    required Map<MixToken, dynamic> tokens,
    List<Type>? defaultOrderOfModifiers,
  }) {
    final resolverTokens = <MixToken, ValueResolver>{};

    for (final entry in tokens.entries) {
      resolverTokens[entry.key] = createResolver(entry.value);
    }

    return MixThemeData.raw(
      textStyles: const StyledTokens.empty(),
      colors: const StyledTokens.empty(),
      breakpoints: const StyledTokens.empty(),
      radii: const StyledTokens.empty(),
      spaces: const StyledTokens.empty(),
      tokens: resolverTokens,
      defaultOrderOfModifiers: defaultOrderOfModifiers,
    );
  }

  /// Combine all [themes] into a single [MixThemeData] root.
  static MixThemeData combine(Iterable<MixThemeData> themes) {
    if (themes.isEmpty) return const MixThemeData.empty();

    return themes.fold(
      const MixThemeData.empty(),
      (previous, theme) => previous.merge(theme),
    );
  }

  MixThemeData copyWith({
    Map<BreakpointToken, Breakpoint>? breakpoints,
    Map<ColorToken, Color>? colors,
    Map<SpaceToken, double>? spaces,
    Map<TextStyleToken, TextStyle>? textStyles,
    Map<RadiusToken, Radius>? radii,
    Map<MixToken, ValueResolver>? tokens,
    List<Type>? defaultOrderOfModifiers,
  }) {
    return MixThemeData.raw(
      textStyles:
          textStyles == null ? this.textStyles : StyledTokens(textStyles),
      colors: colors == null ? this.colors : StyledTokens(colors),
      breakpoints:
          breakpoints == null ? this.breakpoints : StyledTokens(breakpoints),
      radii: radii == null ? this.radii : StyledTokens(radii),
      spaces: spaces == null ? this.spaces : StyledTokens(spaces),
      tokens: tokens ?? this.tokens,
      defaultOrderOfModifiers:
          defaultOrderOfModifiers ?? this.defaultOrderOfModifiers,
    );
  }

  MixThemeData merge(MixThemeData other) {
    final mergedTokens = tokens != null || other.tokens != null
        ? <MixToken, ValueResolver>{...?tokens, ...?other.tokens}
        : null;

    return MixThemeData.raw(
      textStyles: textStyles.merge(other.textStyles),
      colors: colors.merge(other.colors),
      breakpoints: breakpoints.merge(other.breakpoints),
      radii: radii.merge(other.radii),
      spaces: spaces.merge(other.spaces),
      tokens: mergedTokens,
      defaultOrderOfModifiers:
          other.defaultOrderOfModifiers ?? defaultOrderOfModifiers,
    );
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MixThemeData &&
        other.textStyles == textStyles &&
        other.colors == colors &&
        other.breakpoints == breakpoints &&
        other.radii == radii &&
        other.spaces == spaces &&
        mapEquals(other.tokens, tokens) &&
        listEquals(other.defaultOrderOfModifiers, defaultOrderOfModifiers);
  }

  @override
  int get hashCode {
    return textStyles.hashCode ^
        colors.hashCode ^
        breakpoints.hashCode ^
        radii.hashCode ^
        spaces.hashCode ^
        tokens.hashCode ^
        defaultOrderOfModifiers.hashCode;
  }
}

final _breakpointTokenMap = StyledTokens({
  BreakpointToken.xsmall: const Breakpoint(maxWidth: 599),
  BreakpointToken.small: const Breakpoint(minWidth: 600, maxWidth: 1023),
  BreakpointToken.medium: const Breakpoint(minWidth: 1024, maxWidth: 1439),
  BreakpointToken.large: const Breakpoint(
    minWidth: 1440,
    maxWidth: double.infinity,
  ),
});
