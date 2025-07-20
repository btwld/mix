import 'package:flutter/material.dart';

import '../../core/prop.dart';
import '../../core/utility.dart';
import 'color_util.dart';

@immutable
final class MaterialColorUtility<T extends SpecUtility<Object?>>
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

base mixin MaterialColorsMixin<T extends SpecUtility<Object?>>
    on PropUtility<T, Color> {
  T red() => builder(Prop(Colors.red));
  T pink() => builder(Prop(Colors.pink));
  T purple() => builder(Prop(Colors.purple));
  T deepPurple() => builder(Prop(Colors.deepPurple));
  T indigo() => builder(Prop(Colors.indigo));
  T blue() => builder(Prop(Colors.blue));
  T lightBlue() => builder(Prop(Colors.lightBlue));
  T cyan() => builder(Prop(Colors.cyan));
  T teal() => builder(Prop(Colors.teal));
  T green() => builder(Prop(Colors.green));
  T lightGreen() => builder(Prop(Colors.lightGreen));
  T lime() => builder(Prop(Colors.lime));
  T yellow() => builder(Prop(Colors.yellow));
  T amber() => builder(Prop(Colors.amber));
  T orange() => builder(Prop(Colors.orange));
  T deepOrange() => builder(Prop(Colors.deepOrange));
  T brown() => builder(Prop(Colors.brown));
  T grey() => builder(Prop(Colors.grey));
  T blueGrey() => builder(Prop(Colors.blueGrey));
  T redAccent() => builder(Prop(Colors.redAccent));
  T pinkAccent() => builder(Prop(Colors.pinkAccent));
  T purpleAccent() => builder(Prop(Colors.purpleAccent));
  T deepPurpleAccent() => builder(Prop(Colors.deepPurpleAccent));
  T indigoAccent() => builder(Prop(Colors.indigoAccent));
  T blueAccent() => builder(Prop(Colors.blueAccent));
  T lightBlueAccent() => builder(Prop(Colors.lightBlueAccent));
  T cyanAccent() => builder(Prop(Colors.cyanAccent));
  T tealAccent() => builder(Prop(Colors.tealAccent));
  T greenAccent() => builder(Prop(Colors.greenAccent));
  T lightGreenAccent() => builder(Prop(Colors.lightGreenAccent));
  T limeAccent() => builder(Prop(Colors.limeAccent));
  T yellowAccent() => builder(Prop(Colors.yellowAccent));
  T amberAccent() => builder(Prop(Colors.amberAccent));
  T orangeAccent() => builder(Prop(Colors.orangeAccent));
  T deepOrangeAccent() => builder(Prop(Colors.deepOrangeAccent));
}

@immutable
final class MaterialAccentColorUtility<T extends SpecUtility<Object?>>
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
