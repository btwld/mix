import 'package:flutter/material.dart';

import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import 'color_util.dart';

/// Utility for Material Design color palettes with shade access.
///
/// Provides access to Material Design color shades (50, 100, 200, etc.) for
/// systematic color usage following Material Design guidelines.
@immutable
final class MaterialColorUtility<T extends StyleAttribute<Object?>>
    extends FoundationColorUtility<T> {
  // Shade utilities
  @Deprecated('Use call(materialColor.shade50) instead')
  late final shade50 = FoundationColorUtility(builder, materialColor.shade50);

  @Deprecated('Use call(materialColor.shade100) instead')
  late final shade100 = FoundationColorUtility(builder, materialColor.shade100);

  @Deprecated('Use call(materialColor.shade200) instead')
  late final shade200 = FoundationColorUtility(builder, materialColor.shade200);
  @Deprecated('Use call(materialColor.shade300) instead')
  late final shade300 = FoundationColorUtility(builder, materialColor.shade300);
  @Deprecated('Use call(materialColor.shade400) instead')
  late final shade400 = FoundationColorUtility(builder, materialColor.shade400);
  @Deprecated('Use call(materialColor.shade500) instead')
  late final shade500 = FoundationColorUtility(builder, materialColor.shade500);
  @Deprecated('Use call(materialColor.shade600) instead')
  late final shade600 = FoundationColorUtility(builder, materialColor.shade600);
  @Deprecated('Use call(materialColor.shade700) instead')
  late final shade700 = FoundationColorUtility(builder, materialColor.shade700);
  @Deprecated('Use call(materialColor.shade800) instead')
  late final shade800 = FoundationColorUtility(builder, materialColor.shade800);
  @Deprecated('Use call(materialColor.shade900) instead')
  late final shade900 = FoundationColorUtility(builder, materialColor.shade900);
  MaterialColorUtility(super.builder, MaterialColor super.color);

  /// Gets the underlying MaterialColor for shade access.
  MaterialColor get materialColor => color as MaterialColor;
}

/// Provides access to all Material Design colors with optional shade selection.
///
/// Each color method accepts an optional shade parameter (50, 100, 200, etc.) to access
/// specific variations of the color. Without a shade, returns the primary color.
mixin ColorsUtilityMixin<T extends StyleAttribute<Object?>>
    on PropUtility<T, Color> {
  T _wrapColor(ColorSwatch color, [int? shade]) =>
      builder(Prop(shade == null ? color : color[shade]!));

  @Deprecated('Use call(Colors.red) or call(Colors.red[shade]) instead')
  T red([int? shade]) => _wrapColor(Colors.red, shade);
  @Deprecated('Use call(Colors.pink) or call(Colors.pink[shade]) instead')
  T pink([int? shade]) => _wrapColor(Colors.pink, shade);
  @Deprecated('Use call(Colors.purple) or call(Colors.purple[shade]) instead')
  T purple([int? shade]) => _wrapColor(Colors.purple, shade);
  @Deprecated('Use call(Colors.deepPurple) or call(Colors.deepPurple[shade]) instead')
  T deepPurple([int? shade]) => _wrapColor(Colors.deepPurple, shade);
  @Deprecated('Use call(Colors.indigo) or call(Colors.indigo[shade]) instead')
  T indigo([int? shade]) => _wrapColor(Colors.indigo, shade);
  @Deprecated('Use call(Colors.blue) or call(Colors.blue[shade]) instead')
  T blue([int? shade]) => _wrapColor(Colors.blue, shade);
  @Deprecated('Use call(Colors.lightBlue) or call(Colors.lightBlue[shade]) instead')
  T lightBlue([int? shade]) => _wrapColor(Colors.lightBlue, shade);
  @Deprecated('Use call(Colors.cyan) or call(Colors.cyan[shade]) instead')
  T cyan([int? shade]) => _wrapColor(Colors.cyan, shade);
  @Deprecated('Use call(Colors.teal) or call(Colors.teal[shade]) instead')
  T teal([int? shade]) => _wrapColor(Colors.teal, shade);
  @Deprecated('Use call(Colors.green) or call(Colors.green[shade]) instead')
  T green([int? shade]) => _wrapColor(Colors.green, shade);
  @Deprecated('Use call(Colors.lightGreen) or call(Colors.lightGreen[shade]) instead')
  T lightGreen([int? shade]) => _wrapColor(Colors.lightGreen, shade);
  @Deprecated('Use call(Colors.lime) or call(Colors.lime[shade]) instead')
  T lime([int? shade]) => _wrapColor(Colors.lime, shade);
  @Deprecated('Use call(Colors.yellow) or call(Colors.yellow[shade]) instead')
  T yellow([int? shade]) => _wrapColor(Colors.yellow, shade);
  @Deprecated('Use call(Colors.amber) or call(Colors.amber[shade]) instead')
  T amber([int? shade]) => _wrapColor(Colors.amber, shade);
  @Deprecated('Use call(Colors.orange) or call(Colors.orange[shade]) instead')
  T orange([int? shade]) => _wrapColor(Colors.orange, shade);
  @Deprecated('Use call(Colors.deepOrange) or call(Colors.deepOrange[shade]) instead')
  T deepOrange([int? shade]) => _wrapColor(Colors.deepOrange, shade);
  @Deprecated('Use call(Colors.brown) or call(Colors.brown[shade]) instead')
  T brown([int? shade]) => _wrapColor(Colors.brown, shade);
  @Deprecated('Use call(Colors.grey) or call(Colors.grey[shade]) instead')
  T grey([int? shade]) => _wrapColor(Colors.grey, shade);
  @Deprecated('Use call(Colors.blueGrey) or call(Colors.blueGrey[shade]) instead')
  T blueGrey([int? shade]) => _wrapColor(Colors.blueGrey, shade);
  @Deprecated('Use call(Colors.redAccent) or call(Colors.redAccent[shade]) instead')
  T redAccent([int? shade]) => _wrapColor(Colors.redAccent, shade);
  @Deprecated('Use call(Colors.pinkAccent) or call(Colors.pinkAccent[shade]) instead')
  T pinkAccent([int? shade]) => _wrapColor(Colors.pinkAccent, shade);
  @Deprecated('Use call(Colors.purpleAccent) or call(Colors.purpleAccent[shade]) instead')
  T purpleAccent([int? shade]) => _wrapColor(Colors.purpleAccent, shade);
  @Deprecated('Use call(Colors.deepPurpleAccent) or call(Colors.deepPurpleAccent[shade]) instead')
  T deepPurpleAccent([int? shade]) =>
      _wrapColor(Colors.deepPurpleAccent, shade);
  @Deprecated('Use call(Colors.indigoAccent) or call(Colors.indigoAccent[shade]) instead')
  T indigoAccent([int? shade]) => _wrapColor(Colors.indigoAccent, shade);
  @Deprecated('Use call(Colors.blueAccent) or call(Colors.blueAccent[shade]) instead')
  T blueAccent([int? shade]) => _wrapColor(Colors.blueAccent, shade);
  @Deprecated('Use call(Colors.lightBlueAccent) or call(Colors.lightBlueAccent[shade]) instead')
  T lightBlueAccent([int? shade]) => _wrapColor(Colors.lightBlueAccent, shade);
  @Deprecated('Use call(Colors.cyanAccent) or call(Colors.cyanAccent[shade]) instead')
  T cyanAccent([int? shade]) => _wrapColor(Colors.cyanAccent, shade);
  @Deprecated('Use call(Colors.tealAccent) or call(Colors.tealAccent[shade]) instead')
  T tealAccent([int? shade]) => _wrapColor(Colors.tealAccent, shade);
  @Deprecated('Use call(Colors.greenAccent) or call(Colors.greenAccent[shade]) instead')
  T greenAccent([int? shade]) => _wrapColor(Colors.greenAccent, shade);
  @Deprecated('Use call(Colors.lightGreenAccent) or call(Colors.lightGreenAccent[shade]) instead')
  T lightGreenAccent([int? shade]) =>
      _wrapColor(Colors.lightGreenAccent, shade);
  @Deprecated('Use call(Colors.limeAccent) or call(Colors.limeAccent[shade]) instead')
  T limeAccent([int? shade]) => _wrapColor(Colors.limeAccent, shade);
  @Deprecated('Use call(Colors.yellowAccent) or call(Colors.yellowAccent[shade]) instead')
  T yellowAccent([int? shade]) => _wrapColor(Colors.yellowAccent, shade);
  @Deprecated('Use call(Colors.amberAccent) or call(Colors.amberAccent[shade]) instead')
  T amberAccent([int? shade]) => _wrapColor(Colors.amberAccent, shade);
  @Deprecated('Use call(Colors.orangeAccent) or call(Colors.orangeAccent[shade]) instead')
  T orangeAccent([int? shade]) => _wrapColor(Colors.orangeAccent, shade);
  @Deprecated('Use call(Colors.deepOrangeAccent) or call(Colors.deepOrangeAccent[shade]) instead')
  T deepOrangeAccent([int? shade]) =>
      _wrapColor(Colors.deepOrangeAccent, shade);
}

/// Utility for Material Design accent colors with limited shade access.
///
/// Provides access to accent color shades (100, 200, 400, 700) which are
/// the available shades for Material Design accent colors.
@immutable
final class MaterialAccentColorUtility<T extends StyleAttribute<Object?>>
    extends FoundationColorUtility<T> {
  // Shade utilities
  @Deprecated('Use call(materialAccentColor.shade100) instead')
  late final shade100 = FoundationColorUtility(
    builder,
    materialAccentColor.shade100,
  );

  @Deprecated('Use call(materialAccentColor.shade200) instead')
  late final shade200 = FoundationColorUtility(
    builder,
    materialAccentColor.shade200,
  );

  @Deprecated('Use call(materialAccentColor.shade400) instead')
  late final shade400 = FoundationColorUtility(
    builder,
    materialAccentColor.shade400,
  );
  @Deprecated('Use call(materialAccentColor.shade700) instead')
  late final shade700 = FoundationColorUtility(
    builder,
    materialAccentColor.shade700,
  );
  MaterialAccentColorUtility(super.builder, MaterialAccentColor super.color);

  /// Gets the underlying MaterialAccentColor for shade access.
  MaterialAccentColor get materialAccentColor => color as MaterialAccentColor;
}
