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
  T red() => builder(Prop.value(Colors.red));
  T pink() => builder(Prop.value(Colors.pink));
  T purple() => builder(Prop.value(Colors.purple));
  T deepPurple() => builder(Prop.value(Colors.deepPurple));
  T indigo() => builder(Prop.value(Colors.indigo));
  T blue() => builder(Prop.value(Colors.blue));
  T lightBlue() => builder(Prop.value(Colors.lightBlue));
  T cyan() => builder(Prop.value(Colors.cyan));
  T teal() => builder(Prop.value(Colors.teal));
  T green() => builder(Prop.value(Colors.green));
  T lightGreen() => builder(Prop.value(Colors.lightGreen));
  T lime() => builder(Prop.value(Colors.lime));
  T yellow() => builder(Prop.value(Colors.yellow));
  T amber() => builder(Prop.value(Colors.amber));
  T orange() => builder(Prop.value(Colors.orange));
  T deepOrange() => builder(Prop.value(Colors.deepOrange));
  T brown() => builder(Prop.value(Colors.brown));
  T grey() => builder(Prop.value(Colors.grey));
  T blueGrey() => builder(Prop.value(Colors.blueGrey));
  T redAccent() => builder(Prop.value(Colors.redAccent));
  T pinkAccent() => builder(Prop.value(Colors.pinkAccent));
  T purpleAccent() => builder(Prop.value(Colors.purpleAccent));
  T deepPurpleAccent() => builder(Prop.value(Colors.deepPurpleAccent));
  T indigoAccent() => builder(Prop.value(Colors.indigoAccent));
  T blueAccent() => builder(Prop.value(Colors.blueAccent));
  T lightBlueAccent() => builder(Prop.value(Colors.lightBlueAccent));
  T cyanAccent() => builder(Prop.value(Colors.cyanAccent));
  T tealAccent() => builder(Prop.value(Colors.tealAccent));
  T greenAccent() => builder(Prop.value(Colors.greenAccent));
  T lightGreenAccent() => builder(Prop.value(Colors.lightGreenAccent));
  T limeAccent() => builder(Prop.value(Colors.limeAccent));
  T yellowAccent() => builder(Prop.value(Colors.yellowAccent));
  T amberAccent() => builder(Prop.value(Colors.amberAccent));
  T orangeAccent() => builder(Prop.value(Colors.orangeAccent));
  T deepOrangeAccent() => builder(Prop.value(Colors.deepOrangeAccent));
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
