import 'package:flutter/material.dart';

import '../../core/prop.dart';
import '../../core/style.dart';
import '../../core/utility.dart';
import 'color_util.dart';

@immutable
final class MaterialColorUtility<T extends SpecAttribute<Object?>>
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

  // Cast color to MaterialColor for shade access
  MaterialColor get materialColor => color as MaterialColor;
}

mixin ColorsUtilityMixin<T extends SpecAttribute<Object?>>
    on PropUtility<T, Color> {
  T _wrapColor(ColorSwatch color, [int? shade]) =>
      builder(Prop(color[shade ?? 500]!));

  T red([int? shade]) => _wrapColor(Colors.red, shade);
  T pink([int? shade]) => _wrapColor(Colors.pink, shade);
  T purple([int? shade]) => _wrapColor(Colors.purple, shade);
  T deepPurple([int? shade]) => _wrapColor(Colors.deepPurple, shade);
  T indigo([int? shade]) => _wrapColor(Colors.indigo, shade);
  T blue([int? shade]) => _wrapColor(Colors.blue, shade);
  T lightBlue([int? shade]) => _wrapColor(Colors.lightBlue, shade);
  T cyan([int? shade]) => _wrapColor(Colors.cyan, shade);
  T teal([int? shade]) => _wrapColor(Colors.teal, shade);
  T green([int? shade]) => _wrapColor(Colors.green, shade);
  T lightGreen([int? shade]) => _wrapColor(Colors.lightGreen, shade);
  T lime([int? shade]) => _wrapColor(Colors.lime, shade);
  T yellow([int? shade]) => _wrapColor(Colors.yellow, shade);
  T amber([int? shade]) => _wrapColor(Colors.amber, shade);
  T orange([int? shade]) => _wrapColor(Colors.orange, shade);
  T deepOrange([int? shade]) => _wrapColor(Colors.deepOrange, shade);
  T brown([int? shade]) => _wrapColor(Colors.brown, shade);
  T grey([int? shade]) => _wrapColor(Colors.grey, shade);
  T blueGrey([int? shade]) => _wrapColor(Colors.blueGrey, shade);
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

@immutable
final class MaterialAccentColorUtility<T extends SpecAttribute<Object?>>
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

  // Cast color to MaterialAccentColor for shade access
  MaterialAccentColor get materialAccentColor => color as MaterialAccentColor;
}
