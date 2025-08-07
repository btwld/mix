import 'package:flutter/material.dart';

import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import 'color_util.dart';

/// Utility for accessing Material colors with both method call and .shadeXXX() syntax.
/// 
/// This class allows both `.grey(300)` (recommended) and `.grey.shade300()` (deprecated) syntax.
@immutable
class MaterialColorCallableUtility<T extends Style<Object?>> {
  final T Function(Prop<Color>) builder;
  final MaterialColor materialColor;
  
  const MaterialColorCallableUtility(this.builder, this.materialColor);
  
  // Call method for new syntax: grey(300)
  T call([int? shade]) => 
      builder(Prop.value(shade == null ? materialColor : materialColor[shade]!));
  
  // Deprecated shade methods for backward compatibility
  @Deprecated('Use grey(50) instead of grey.shade50()')
  T shade50() => call(50);
  
  @Deprecated('Use grey(100) instead of grey.shade100()')
  T shade100() => call(100);
  
  @Deprecated('Use grey(200) instead of grey.shade200()')
  T shade200() => call(200);
  
  @Deprecated('Use grey(300) instead of grey.shade300()')
  T shade300() => call(300);
  
  @Deprecated('Use grey(400) instead of grey.shade400()')
  T shade400() => call(400);
  
  @Deprecated('Use grey(500) instead of grey.shade500()')
  T shade500() => call(500);
  
  @Deprecated('Use grey(600) instead of grey.shade600()')
  T shade600() => call(600);
  
  @Deprecated('Use grey(700) instead of grey.shade700()')
  T shade700() => call(700);
  
  @Deprecated('Use grey(800) instead of grey.shade800()')
  T shade800() => call(800);
  
  @Deprecated('Use grey(900) instead of grey.shade900()')
  T shade900() => call(900);
}

/// Utility for Material Design color palettes with shade access.
///
/// Provides access to Material Design color shades (50, 100, 200, etc.) for
/// systematic color usage following Material Design guidelines.
@immutable
final class MaterialColorUtility<T extends Style<Object?>>
    extends FoundationColorUtility<T> {
  // Shade utilities
  late final shade50 = FoundationColorUtility(builder, materialColor.shade50);

  late final shade100 = FoundationColorUtility(builder, materialColor.shade100);

  late final shade200 = FoundationColorUtility(builder, materialColor.shade200);
  late final shade300 = FoundationColorUtility(builder, materialColor.shade300);
  late final shade400 = FoundationColorUtility(builder, materialColor.shade400);
  late final shade500 = FoundationColorUtility(builder, materialColor.shade500);
  late final shade600 = FoundationColorUtility(builder, materialColor.shade600);
  late final shade700 = FoundationColorUtility(builder, materialColor.shade700);
  late final shade800 = FoundationColorUtility(builder, materialColor.shade800);
  late final shade900 = FoundationColorUtility(builder, materialColor.shade900);
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
      builder(Prop.value(shade == null ? color : color[shade]!));

  // Use MaterialColorCallableUtility to support both .grey(300) and .grey.shade300()
  late final red = MaterialColorCallableUtility(builder, Colors.red);
  late final pink = MaterialColorCallableUtility(builder, Colors.pink);
  late final purple = MaterialColorCallableUtility(builder, Colors.purple);
  late final deepPurple = MaterialColorCallableUtility(builder, Colors.deepPurple);
  late final indigo = MaterialColorCallableUtility(builder, Colors.indigo);
  late final blue = MaterialColorCallableUtility(builder, Colors.blue);
  late final lightBlue = MaterialColorCallableUtility(builder, Colors.lightBlue);
  late final cyan = MaterialColorCallableUtility(builder, Colors.cyan);
  late final teal = MaterialColorCallableUtility(builder, Colors.teal);
  late final green = MaterialColorCallableUtility(builder, Colors.green);
  late final lightGreen = MaterialColorCallableUtility(builder, Colors.lightGreen);
  late final lime = MaterialColorCallableUtility(builder, Colors.lime);
  late final yellow = MaterialColorCallableUtility(builder, Colors.yellow);
  late final amber = MaterialColorCallableUtility(builder, Colors.amber);
  late final orange = MaterialColorCallableUtility(builder, Colors.orange);
  late final deepOrange = MaterialColorCallableUtility(builder, Colors.deepOrange);
  late final brown = MaterialColorCallableUtility(builder, Colors.brown);
  late final grey = MaterialColorCallableUtility(builder, Colors.grey);
  late final blueGrey = MaterialColorCallableUtility(builder, Colors.blueGrey);
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
    builder,
    materialAccentColor.shade100,
  );

  late final shade200 = FoundationColorUtility(
    builder,
    materialAccentColor.shade200,
  );

  late final shade400 = FoundationColorUtility(
    builder,
    materialAccentColor.shade400,
  );
  late final shade700 = FoundationColorUtility(
    builder,
    materialAccentColor.shade700,
  );
  MaterialAccentColorUtility(super.builder, MaterialAccentColor super.color);

  /// Gets the underlying MaterialAccentColor for shade access.
  MaterialAccentColor get materialAccentColor => color as MaterialAccentColor;
}
