import 'package:flutter/material.dart';

import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import 'color_util.dart';

/// Utility for accessing Material colors with method-call syntax.
@immutable
class MaterialColorCallableUtility<T extends Style<Object?>> {
  final T Function(Prop<Color>) builder;
  final MaterialColor materialColor;

  const MaterialColorCallableUtility(this.builder, this.materialColor);

  // Call method for new syntax: grey(300)
  T call([int? shade]) => builder(
    Prop.value(shade == null ? materialColor : materialColor[shade]!),
  );

}

/// Utility for Material Design color palettes with shade access.
///
/// Provides access to Material Design color shades (50, 100, 200, etc.) for
/// systematic color usage following Material Design guidelines.
@immutable
final class MaterialColorUtility<T extends Style<Object?>>
    extends FoundationColorUtility<T> {
  // Shade utilities
  late final shade50 = FoundationColorUtility(
    utilityBuilder,
    materialColor.shade50,
  );

  late final shade100 = FoundationColorUtility(
    utilityBuilder,
    materialColor.shade100,
  );

  late final shade200 = FoundationColorUtility(
    utilityBuilder,
    materialColor.shade200,
  );
  late final shade300 = FoundationColorUtility(
    utilityBuilder,
    materialColor.shade300,
  );
  late final shade400 = FoundationColorUtility(
    utilityBuilder,
    materialColor.shade400,
  );
  late final shade500 = FoundationColorUtility(
    utilityBuilder,
    materialColor.shade500,
  );
  late final shade600 = FoundationColorUtility(
    utilityBuilder,
    materialColor.shade600,
  );
  late final shade700 = FoundationColorUtility(
    utilityBuilder,
    materialColor.shade700,
  );
  late final shade800 = FoundationColorUtility(
    utilityBuilder,
    materialColor.shade800,
  );
  late final shade900 = FoundationColorUtility(
    utilityBuilder,
    materialColor.shade900,
  );
  MaterialColorUtility(super.builder, MaterialColor super.color);

  /// Gets the underlying MaterialColor for shade access.
  MaterialColor get materialColor => color as MaterialColor;
}

/// Provides access to all Material Design colors with optional shade selection.
///
/// Each color method accepts an optional shade parameter (50, 100, 200, etc.) to access
/// specific variations of the color. Without a shade, returns the primary color.
mixin ColorsUtilityMixin<T extends Style<Object?>>
    on MixUtility<T, Prop<Color>> {
  T _wrapColor(ColorSwatch color, [int? shade]) =>
      utilityBuilder(Prop.value(shade == null ? color : color[shade]!));

  // Use MaterialColorCallableUtility for .grey(300)-style access.
  late final red = MaterialColorCallableUtility(utilityBuilder, Colors.red);
  late final pink = MaterialColorCallableUtility(utilityBuilder, Colors.pink);
  late final purple = MaterialColorCallableUtility(
    utilityBuilder,
    Colors.purple,
  );
  late final deepPurple = MaterialColorCallableUtility(
    utilityBuilder,
    Colors.deepPurple,
  );
  late final indigo = MaterialColorCallableUtility(
    utilityBuilder,
    Colors.indigo,
  );
  late final blue = MaterialColorCallableUtility(utilityBuilder, Colors.blue);
  late final lightBlue = MaterialColorCallableUtility(
    utilityBuilder,
    Colors.lightBlue,
  );
  late final cyan = MaterialColorCallableUtility(utilityBuilder, Colors.cyan);
  late final teal = MaterialColorCallableUtility(utilityBuilder, Colors.teal);
  late final green = MaterialColorCallableUtility(utilityBuilder, Colors.green);
  late final lightGreen = MaterialColorCallableUtility(
    utilityBuilder,
    Colors.lightGreen,
  );
  late final lime = MaterialColorCallableUtility(utilityBuilder, Colors.lime);
  late final yellow = MaterialColorCallableUtility(
    utilityBuilder,
    Colors.yellow,
  );
  late final amber = MaterialColorCallableUtility(utilityBuilder, Colors.amber);
  late final orange = MaterialColorCallableUtility(
    utilityBuilder,
    Colors.orange,
  );
  late final deepOrange = MaterialColorCallableUtility(
    utilityBuilder,
    Colors.deepOrange,
  );
  late final brown = MaterialColorCallableUtility(utilityBuilder, Colors.brown);
  late final grey = MaterialColorCallableUtility(utilityBuilder, Colors.grey);
  late final blueGrey = MaterialColorCallableUtility(
    utilityBuilder,
    Colors.blueGrey,
  );
  T redAccent([int? shade]) => _wrapColor(Colors.redAccent, shade);
  T pinkAccent([int? shade]) => _wrapColor(Colors.pinkAccent, shade);
  T purpleAccent([int? shade]) => _wrapColor(Colors.purpleAccent, shade);
  T deepPurpleAccent([int? shade]) =>
      _wrapColor(Colors.deepPurpleAccent, shade);
  T indigoAccent([int? shade]) => _wrapColor(Colors.indigoAccent, shade);
  T blueAccent([int? shade]) => _wrapColor(Colors.blueAccent, shade);
  T lightBlueAccent([int? shade]) => _wrapColor(Colors.lightBlueAccent, shade);
  T cyanAccent([int? shade]) => _wrapColor(Colors.cyanAccent, shade);
  T tealAccent([int? shade]) => _wrapColor(Colors.tealAccent, shade);
  T greenAccent([int? shade]) => _wrapColor(Colors.greenAccent, shade);
  T lightGreenAccent([int? shade]) =>
      _wrapColor(Colors.lightGreenAccent, shade);
  T limeAccent([int? shade]) => _wrapColor(Colors.limeAccent, shade);
  T yellowAccent([int? shade]) => _wrapColor(Colors.yellowAccent, shade);
  T amberAccent([int? shade]) => _wrapColor(Colors.amberAccent, shade);
  T orangeAccent([int? shade]) => _wrapColor(Colors.orangeAccent, shade);
  T deepOrangeAccent([int? shade]) =>
      _wrapColor(Colors.deepOrangeAccent, shade);
}

/// Utility for Material Design accent colors with limited shade access.
///
/// Provides access to accent color shades (100, 200, 400, 700) which are
/// the available shades for Material Design accent colors.
@immutable
final class MaterialAccentColorUtility<T extends Style<Object?>>
    extends FoundationColorUtility<T> {
  // Shade utilities
  late final shade100 = FoundationColorUtility(
    utilityBuilder,
    materialAccentColor.shade100,
  );

  late final shade200 = FoundationColorUtility(
    utilityBuilder,
    materialAccentColor.shade200,
  );

  late final shade400 = FoundationColorUtility(
    utilityBuilder,
    materialAccentColor.shade400,
  );
  late final shade700 = FoundationColorUtility(
    utilityBuilder,
    materialAccentColor.shade700,
  );
  MaterialAccentColorUtility(super.builder, MaterialAccentColor super.color);

  /// Gets the underlying MaterialAccentColor for shade access.
  MaterialAccentColor get materialAccentColor => color as MaterialAccentColor;
}
