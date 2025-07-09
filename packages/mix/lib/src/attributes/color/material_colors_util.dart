import 'package:flutter/material.dart';

import '../../core/mix_element.dart';
import 'color_util.dart';

@immutable
final class MaterialColorUtility<T extends StyleElement>
    extends FoundationColorUtility<T, MaterialColor> {
  late final shade50 = FoundationColorUtility(builder, color.shade50);
  late final shade100 = FoundationColorUtility(builder, color.shade100);
  late final shade200 = FoundationColorUtility(builder, color.shade200);
  late final shade300 = FoundationColorUtility(builder, color.shade300);
  late final shade400 = FoundationColorUtility(builder, color.shade400);
  late final shade500 = FoundationColorUtility(builder, color.shade500);
  late final shade600 = FoundationColorUtility(builder, color.shade600);
  late final shade700 = FoundationColorUtility(builder, color.shade700);
  late final shade800 = FoundationColorUtility(builder, color.shade800);
  late final shade900 = FoundationColorUtility(builder, color.shade900);
  MaterialColorUtility(super.builder, super.color);
}

base mixin MaterialColorsMixin<T extends StyleElement> on BaseColorUtility<T> {
  late final _color = MaterialColorUtility.new;
  late final _accent = MaterialAccentColorUtility.new;
  late final red = _color(builder, Colors.red);
  late final pink = _color(builder, Colors.pink);
  late final purple = _color(builder, Colors.purple);
  late final deepPurple = _color(builder, Colors.deepPurple);
  late final indigo = _color(builder, Colors.indigo);
  late final blue = _color(builder, Colors.blue);
  late final lightBlue = _color(builder, Colors.lightBlue);
  late final cyan = _color(builder, Colors.cyan);
  late final teal = _color(builder, Colors.teal);
  late final green = _color(builder, Colors.green);
  late final lightGreen = _color(builder, Colors.lightGreen);
  late final lime = _color(builder, Colors.lime);
  late final yellow = _color(builder, Colors.yellow);
  late final amber = _color(builder, Colors.amber);
  late final orange = _color(builder, Colors.orange);
  late final deepOrange = _color(builder, Colors.deepOrange);
  late final brown = _color(builder, Colors.brown);
  late final grey = _color(builder, Colors.grey);
  late final blueGrey = _color(builder, Colors.blueGrey);
  late final redAccent = _accent(builder, Colors.redAccent);
  late final pinkAccent = _accent(builder, Colors.pinkAccent);
  late final purpleAccent = _accent(builder, Colors.purpleAccent);
  late final deepPurpleAccent = _accent(builder, Colors.deepPurpleAccent);
  late final indigoAccent = _accent(builder, Colors.indigoAccent);
  late final blueAccent = _accent(builder, Colors.blueAccent);
  late final lightBlueAccent = _accent(builder, Colors.lightBlueAccent);
  late final cyanAccent = _accent(builder, Colors.cyanAccent);
  late final tealAccent = _accent(builder, Colors.tealAccent);
  late final greenAccent = _accent(builder, Colors.greenAccent);
  late final lightGreenAccent = _accent(builder, Colors.lightGreenAccent);
  late final limeAccent = _accent(builder, Colors.limeAccent);
  late final yellowAccent = _accent(builder, Colors.yellowAccent);
  late final amberAccent = _accent(builder, Colors.amberAccent);
  late final orangeAccent = _accent(builder, Colors.orangeAccent);
  late final deepOrangeAccent = _accent(builder, Colors.deepOrangeAccent);
}

@immutable
final class MaterialAccentColorUtility<T extends StyleElement>
    extends FoundationColorUtility<T, MaterialAccentColor> {
  late final shade100 = FoundationColorUtility(builder, color.shade100);
  late final shade200 = FoundationColorUtility(builder, color.shade200);
  late final shade400 = FoundationColorUtility(builder, color.shade400);
  late final shade700 = FoundationColorUtility(builder, color.shade700);
  MaterialAccentColorUtility(super.builder, super.color);
}
