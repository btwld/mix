// Stub packages for rule tests. They mirror the shapes of the real
// `flutter`, `mix`, and `mix_annotations` APIs that the rules inspect, not
// their behavior.

/// Stub of `package:flutter/widgets.dart`.
const flutterStub = r'''
abstract class BuildContext {}

abstract class Widget {
  const Widget();
}

class Color {
  const Color(int value);

  Color withValues({double? alpha}) => this;
}

abstract final class Colors {
  static const Color blue = Color(0xFF2196F3);
}

class FontWeight {
  const FontWeight._(this.value);

  final int value;

  static const FontWeight w600 = FontWeight._(600);
}

class Container extends Widget {
  const Container({Color? color, Widget? child});
}

double lerpDouble(double a, double b, double t) => a;
''';

/// Stub of `package:mix/mix.dart`.
const mixStub = r'''
import 'package:flutter/widgets.dart';

abstract class Mixable<T> {}

abstract class Mix<T> extends Mixable<T> {}

abstract class Spec<S extends Spec<S>> {}

abstract class Style<S extends Spec<S>> extends Mix<S> {
  Style<S> merge(covariant Style<S>? other);
}

mixin VariantStyleMixin<T extends Style<S>, S extends Spec<S>> on Style<S> {
  T variants(List<Object> value);
  T variant(Object variant, T style) => variants([variant, style]);
  T applyVariants(Iterable<Object> variants) => this as T;
  T onDark(T style) => variant(Object(), style);
  T onBuilder(T Function(BuildContext context) fn) => this as T;
}

mixin WidgetStateVariantMixin<T extends Style<S>, S extends Spec<S>>
    on Style<S> {
  T variant(Object variant, T style);
  T onHovered(T style) => variant(Object(), style);
  T onPressed(T style) => variant(Object(), style);
}

mixin AnimationStyleMixin<T extends Style<S>, S extends Spec<S>> on Style<S> {
  T animate(Object config);
  T keyframeAnimation(Object config) => animate(config);
}

mixin WidgetModifierStyleMixin<T extends Style<S>, S extends Spec<S>>
    on Style<S> {
  T wrap(Object value);
}

abstract class MixStyler<ST extends Style<SP>, SP extends Spec<SP>>
    extends Style<SP>
    with
        VariantStyleMixin<ST, SP>,
        WidgetStateVariantMixin<ST, SP>,
        AnimationStyleMixin<ST, SP>,
        WidgetModifierStyleMixin<ST, SP> {
  @override
  ST variants(List<Object> value) => this as ST;
  @override
  ST animate(Object config) => this as ST;
  @override
  ST wrap(Object value) => this as ST;
  @override
  ST merge(covariant ST? other) => this as ST;
}

sealed class EdgeInsetsGeometryMix extends Mix<Object> {
  const EdgeInsetsGeometryMix();

  static EdgeInsetsMix all(double value) => EdgeInsetsMix.all(value);
}

final class EdgeInsetsMix extends EdgeInsetsGeometryMix {
  const EdgeInsetsMix({double? left});
  const EdgeInsetsMix.all(double value);

  EdgeInsetsMix horizontal(double value) => this;
}

final class EdgeInsetsDirectionalMix extends EdgeInsetsGeometryMix {
  const EdgeInsetsDirectionalMix.only({double? start});
}

class BoxShadowMix extends Mix<Object> {
  BoxShadowMix({Color? color});
  BoxShadowMix.color(Color value);
}

class GradientMix<T> extends Mix<T> {
  GradientMix.linear();
}

class VariantStyle<S extends Spec<S>> extends Mixable<Object> {
  VariantStyle(Object variant, Style<S> style);
}

mixin DecorationStyleMixin<T extends Style<S>, S extends Spec<S>>
    on Style<S> {
  T color(Color? value) => this as T;
}

final class BoxSpec extends Spec<BoxSpec> {}

// Generated Stylers override the mixin methods, as BoxStyler does here.
class BoxStyler extends MixStyler<BoxStyler, BoxSpec>
    with DecorationStyleMixin<BoxStyler, BoxSpec> {
  BoxStyler({Color? color});

  factory BoxStyler.color(Color value) => BoxStyler().color(value);

  BoxStyler width(double value) => this;
  BoxStyler height(double value) => this;
  BoxStyler padding(EdgeInsetsGeometryMix value) => this;
  BoxStyler shadow(BoxShadowMix value) => this;
  BoxStyler gradient(GradientMix<Object> value) => this;

  @override
  BoxStyler variants(List<Object> value) => this;
  @override
  BoxStyler animate(Object config) => this;
  @override
  BoxStyler wrap(Object value) => this;
  @override
  BoxStyler merge(BoxStyler? other) => this;
}

class Box extends Widget {
  const Box({Style<BoxSpec>? style, Widget? child});
}

final class TextSpec extends Spec<TextSpec> {}

mixin TextStyleMixin<T extends Style<S>, S extends Spec<S>> on Style<S> {
  T fontWeight(FontWeight value) => this as T;
}

class TextStyler extends MixStyler<TextStyler, TextSpec>
    with TextStyleMixin<TextStyler, TextSpec> {
  TextStyler();

  factory TextStyler.fontWeight(FontWeight value) =>
      TextStyler().fontWeight(value);

  TextStyler style(Object value) => this;
}

final class GridBoxSpec extends Spec<GridBoxSpec> {}

class GridBoxStyler extends MixStyler<GridBoxStyler, GridBoxSpec> {
  GridBoxStyler();

  GridBoxStyler gap(double value) => this;
  GridBoxStyler onConstraints(Object breakpoint, GridBoxStyler patch) => this;
}

abstract class MixToken<T> {
  const MixToken(this.name);

  final String name;

  T call();
  T resolve(BuildContext context);
}

class ColorToken extends MixToken<Color> {
  const ColorToken(super.name);

  @override
  Color call() => const Color(0);
  @override
  Color resolve(BuildContext context) => const Color(0);
}

class SpaceToken extends MixToken<double> {
  const SpaceToken(super.name);

  @override
  double call() => 0;
  @override
  double resolve(BuildContext context) => 0;
}

class TextStyleToken extends MixToken<Object> {
  const TextStyleToken(super.name);

  @override
  Object call() => Object();
  @override
  Object resolve(BuildContext context) => Object();

  Object mix() => Object();
}

class MixScope extends Widget {
  factory MixScope({
    Map<ColorToken, Color>? colors,
    Map<MixToken<Object?>, Object>? tokens,
    Widget? child,
  }) => const MixScope._();

  const MixScope._();

  static Widget inherit({Map<ColorToken, Color>? colors, Widget? child}) =>
      const MixScope._();
}

// A plain class from Mix that still resolves token references.
sealed class GridTrack {
  static GridTrack fixed(double size) => _FixedTrack();
}

final class _FixedTrack extends GridTrack {}
''';

/// Stub of `package:mix_annotations/mix_annotations.dart`.
const mixAnnotationsStub = r'''
class GeneratedMixMethods {
  static const int merge = 0x01;
  static const int resolve = 0x02;
  static const int all = merge | resolve;
  static const int skipMerge = all & ~merge;
}

class GeneratedStylerMethods {
  static const int setters = 0x01;
  static const int merge = 0x02;
  static const int all = setters | merge;
  static const int skipMerge = all & ~merge;
}

class Mixable {
  final int methods;

  const Mixable({this.methods = GeneratedMixMethods.all});
}

const mixable = Mixable();

class MixableStyler {
  final int methods;

  const MixableStyler({this.methods = GeneratedStylerMethods.all});
}

const mixableStyler = MixableStyler();
''';
