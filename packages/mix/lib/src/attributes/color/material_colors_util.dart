import 'package:flutter/material.dart';

import '../../core/mix_element.dart';
import '../../core/prop.dart';
import '../../core/prop_utility.dart';
import 'color_util.dart';

@immutable
final class MaterialColorUtility<T extends StyleElement>
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

base mixin MaterialColorsMixin<T extends StyleElement>
    on PropUtility<T, Color> {
  T red() => builder(Prop.fromValue(Colors.red));
  T pink() => builder(Prop.fromValue(Colors.pink));
  T purple() => builder(Prop.fromValue(Colors.purple));
  T deepPurple() => builder(Prop.fromValue(Colors.deepPurple));
  T indigo() => builder(Prop.fromValue(Colors.indigo));
  T blue() => builder(Prop.fromValue(Colors.blue));
  T lightBlue() => builder(Prop.fromValue(Colors.lightBlue));
  T cyan() => builder(Prop.fromValue(Colors.cyan));
  T teal() => builder(Prop.fromValue(Colors.teal));
  T green() => builder(Prop.fromValue(Colors.green));
  T lightGreen() => builder(Prop.fromValue(Colors.lightGreen));
  T lime() => builder(Prop.fromValue(Colors.lime));
  T yellow() => builder(Prop.fromValue(Colors.yellow));
  T amber() => builder(Prop.fromValue(Colors.amber));
  T orange() => builder(Prop.fromValue(Colors.orange));
  T deepOrange() => builder(Prop.fromValue(Colors.deepOrange));
  T brown() => builder(Prop.fromValue(Colors.brown));
  T grey() => builder(Prop.fromValue(Colors.grey));
  T blueGrey() => builder(Prop.fromValue(Colors.blueGrey));
  T redAccent() => builder(Prop.fromValue(Colors.redAccent));
  T pinkAccent() => builder(Prop.fromValue(Colors.pinkAccent));
  T purpleAccent() => builder(Prop.fromValue(Colors.purpleAccent));
  T deepPurpleAccent() => builder(Prop.fromValue(Colors.deepPurpleAccent));
  T indigoAccent() => builder(Prop.fromValue(Colors.indigoAccent));
  T blueAccent() => builder(Prop.fromValue(Colors.blueAccent));
  T lightBlueAccent() => builder(Prop.fromValue(Colors.lightBlueAccent));
  T cyanAccent() => builder(Prop.fromValue(Colors.cyanAccent));
  T tealAccent() => builder(Prop.fromValue(Colors.tealAccent));
  T greenAccent() => builder(Prop.fromValue(Colors.greenAccent));
  T lightGreenAccent() => builder(Prop.fromValue(Colors.lightGreenAccent));
  T limeAccent() => builder(Prop.fromValue(Colors.limeAccent));
  T yellowAccent() => builder(Prop.fromValue(Colors.yellowAccent));
  T amberAccent() => builder(Prop.fromValue(Colors.amberAccent));
  T orangeAccent() => builder(Prop.fromValue(Colors.orangeAccent));
  T deepOrangeAccent() => builder(Prop.fromValue(Colors.deepOrangeAccent));
}

@immutable
final class MaterialAccentColorUtility<T extends StyleElement>
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
