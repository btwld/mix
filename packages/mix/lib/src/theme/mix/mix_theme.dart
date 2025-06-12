import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../internal/iterable_ext.dart';
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
  /// Legacy token storage for backwards compatibility.
  final StyledTokens<RadiusToken, Radius> radii;
  final StyledTokens<ColorToken, Color> colors;
  final StyledTokens<TextStyleToken, TextStyle> textStyles;
  final StyledTokens<BreakpointToken, Breakpoint> breakpoints;
  final StyledTokens<SpaceToken, double> spaces;
  final List<Type>? defaultOrderOfModifiers;
  
  /// Unified token storage using resolvers.
  /// 
  /// Maps token names to their resolvers. This replaces the need for
  /// separate maps per type and supports any value type.
  final Map<String, ValueResolver<dynamic>>? tokens;

  const MixThemeData.raw({
    required this.textStyles,
    required this.colors,
    required this.breakpoints,
    required this.radii,
    required this.spaces,
    this.defaultOrderOfModifiers,
    this.tokens,
  });

  const MixThemeData.empty()
      : this.raw(
          textStyles: const StyledTokens.empty(),
          colors: const StyledTokens.empty(),
          breakpoints: const StyledTokens.empty(),
          radii: const StyledTokens.empty(),
          spaces: const StyledTokens.empty(),
          defaultOrderOfModifiers: null,
        );

  factory MixThemeData({
    Map<BreakpointToken, Breakpoint>? breakpoints,
    Map<ColorToken, Color>? colors,
    Map<SpaceToken, double>? spaces,
    Map<TextStyleToken, TextStyle>? textStyles,
    Map<RadiusToken, Radius>? radii,
    List<Type>? defaultOrderOfModifiers,
  }) {
    return MixThemeData.raw(
      textStyles: StyledTokens(textStyles ?? const {}),
      colors: StyledTokens(colors ?? const {}),
      breakpoints:
          _breakpointTokenMap.merge(StyledTokens(breakpoints ?? const {})),
      radii: StyledTokens(radii ?? const {}),
      spaces: StyledTokens(spaces ?? const {}),
      defaultOrderOfModifiers: defaultOrderOfModifiers,
    );
  }

  factory MixThemeData.withMaterial({
    Map<BreakpointToken, Breakpoint>? breakpoints,
    Map<ColorToken, Color>? colors,
    Map<SpaceToken, double>? spaces,
    Map<TextStyleToken, TextStyle>? textStyles,
    Map<RadiusToken, Radius>? radii,
    List<Type>? defaultOrderOfModifiers,
  }) {
    return materialMixTheme.merge(
      MixThemeData(
        breakpoints: breakpoints,
        colors: colors,
        spaces: spaces,
        textStyles: textStyles,
        radii: radii,
        defaultOrderOfModifiers: defaultOrderOfModifiers,
      ),
    );
  }

  /// Creates theme data using unified token storage.
  /// 
  /// This factory converts any value types to resolvers automatically.
  /// Legacy token maps are left empty for backwards compatibility.
  factory MixThemeData.unified({
    Map<String, dynamic>? tokens,
    List<Type>? defaultOrderOfModifiers,
  }) {
    return MixThemeData.raw(
      textStyles: const StyledTokens.empty(),
      colors: const StyledTokens.empty(),
      breakpoints: const StyledTokens.empty(),
      radii: const StyledTokens.empty(),
      spaces: const StyledTokens.empty(),
      defaultOrderOfModifiers: defaultOrderOfModifiers,
      tokens: _convertTokensToResolvers(tokens),
    );
  }

  /// Converts a map of values to resolvers.
  static Map<String, ValueResolver<dynamic>>? _convertTokensToResolvers(Map<String, dynamic>? tokens) {
    if (tokens == null || tokens.isEmpty) return null;
    
    return tokens.map((key, value) => MapEntry(key, createResolver(value)));
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
      defaultOrderOfModifiers:
          this.defaultOrderOfModifiers ?? defaultOrderOfModifiers,
    );
  }

  MixThemeData merge(MixThemeData other) {
    return MixThemeData.raw(
      textStyles: textStyles.merge(other.textStyles),
      colors: colors.merge(other.colors),
      breakpoints: breakpoints.merge(other.breakpoints),
      radii: radii.merge(other.radii),
      spaces: spaces.merge(other.spaces),
      defaultOrderOfModifiers:
          (defaultOrderOfModifiers ?? []).merge(other.defaultOrderOfModifiers),
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
        listEquals(other.defaultOrderOfModifiers, defaultOrderOfModifiers);
  }

  @override
  int get hashCode {
    return textStyles.hashCode ^
        colors.hashCode ^
        breakpoints.hashCode ^
        radii.hashCode ^
        spaces.hashCode ^
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
