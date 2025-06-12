import 'package:collection/collection.dart';
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
  /// Unified token storage using MixToken objects as keys.
  /// 
  /// This is the single source of truth for all token values.
  /// Maps MixToken<T> objects to their corresponding values.
  final Map<MixToken<dynamic>, dynamic> tokens;
  
  final List<Type>? defaultOrderOfModifiers;

  const MixThemeData._internal({
    required this.tokens,
    this.defaultOrderOfModifiers,
  });

  const MixThemeData.empty()
      : this._internal(
          tokens: const <MixToken<dynamic>, dynamic>{},
          defaultOrderOfModifiers: null,
        );

  factory MixThemeData({
    Map<MixToken<Color>, Color>? colors,
    Map<MixToken<double>, double>? spaces,
    Map<MixToken<TextStyle>, TextStyle>? textStyles,
    Map<MixToken<Radius>, Radius>? radii,
    Map<MixToken<Breakpoint>, Breakpoint>? breakpoints,
    Map<MixToken<dynamic>, dynamic>? tokens,
    List<Type>? defaultOrderOfModifiers,
  }) {
    final unifiedTokens = <MixToken<dynamic>, dynamic>{};
    
    // Add direct tokens first
    if (tokens != null) {
      unifiedTokens.addAll(tokens);
    }
    
    // Move typed parameters to unified tokens
    if (colors != null) {
      unifiedTokens.addAll(colors);
    }
    
    if (spaces != null) {
      unifiedTokens.addAll(spaces);
    }
    
    if (textStyles != null) {
      unifiedTokens.addAll(textStyles);
    }
    
    if (radii != null) {
      unifiedTokens.addAll(radii);
    }
    
    if (breakpoints != null) {
      unifiedTokens.addAll(breakpoints);
    }
    
    return MixThemeData._internal(
      tokens: unifiedTokens,
      defaultOrderOfModifiers: defaultOrderOfModifiers,
    );
  }

  factory MixThemeData.withMaterial({
    Map<MixToken<Breakpoint>, Breakpoint>? breakpoints,
    Map<MixToken<Color>, Color>? colors,
    Map<MixToken<double>, double>? spaces,
    Map<MixToken<TextStyle>, TextStyle>? textStyles,
    Map<MixToken<Radius>, Radius>? radii,
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
  /// This factory allows direct specification of the unified tokens map.
  factory MixThemeData.unified({
    required Map<MixToken<dynamic>, dynamic> tokens,
    List<Type>? defaultOrderOfModifiers,
  }) {
    return MixThemeData._internal(
      tokens: tokens,
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
    Map<MixToken<Breakpoint>, Breakpoint>? breakpoints,
    Map<MixToken<Color>, Color>? colors,
    Map<MixToken<double>, double>? spaces,
    Map<MixToken<TextStyle>, TextStyle>? textStyles,
    Map<MixToken<Radius>, Radius>? radii,
    Map<MixToken<dynamic>, dynamic>? tokens,
    List<Type>? defaultOrderOfModifiers,
  }) {
    final newTokens = <MixToken<dynamic>, dynamic>{...this.tokens};
    
    // Update with new typed parameters
    if (colors != null) {
      newTokens.addAll(colors);
    }
    if (spaces != null) {
      newTokens.addAll(spaces);
    }
    if (textStyles != null) {
      newTokens.addAll(textStyles);
    }
    if (radii != null) {
      newTokens.addAll(radii);
    }
    if (breakpoints != null) {
      newTokens.addAll(breakpoints);
    }
    if (tokens != null) {
      newTokens.addAll(tokens);
    }
    
    return MixThemeData._internal(
      tokens: newTokens,
      defaultOrderOfModifiers: defaultOrderOfModifiers ?? this.defaultOrderOfModifiers,
    );
  }

  MixThemeData merge(MixThemeData other) {
    final mergedTokens = <MixToken<dynamic>, dynamic>{...tokens, ...other.tokens};
    
    return MixThemeData._internal(
      tokens: mergedTokens,
      defaultOrderOfModifiers: other.defaultOrderOfModifiers ?? defaultOrderOfModifiers,
    );
  }

  @override
  operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MixThemeData &&
        const DeepCollectionEquality().equals(other.tokens, tokens) &&
        listEquals(other.defaultOrderOfModifiers, defaultOrderOfModifiers);
  }

  @override
  int get hashCode {
    return tokens.hashCode ^ defaultOrderOfModifiers.hashCode;
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
