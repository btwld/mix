// Stub types for testing mix_lint rules without depending on the full mix package.
// Used by analysis_rule tests that need MixStyler, MixToken, MixScope resolution.

const String mixStubLibContent = r'''
abstract class Mixable<T> {}
abstract class Mix<T> extends Mixable<T> {}
abstract class MixStyler extends Mix<Object> {}
abstract class MixToken<T> {
  const MixToken();
  T call();
  T resolve(Object context);
}
class MyToken extends MixToken<int> {
  const MyToken();
  @override
  int call() => 0;
  @override
  int resolve(Object context) => 0;
  int mix() => 0;
}
class MixScope {
  MixScope([Map<Object?, Object?>? tokens]);
}
class EdgeInsetsGeometryMix extends Mix<Object> {
  EdgeInsetsGeometryMix();
  static EdgeInsetsGeometryMix all(double value) => EdgeInsetsGeometryMix();
  static EdgeInsetsGeometryMix value(Object? v) => EdgeInsetsGeometryMix();
}
class Container {
  Container({Object? color, List<Object?>? children});
}
class FontWeight {
  FontWeight();
  static final FontWeight w600 = FontWeight();
}
class Constants {
  static const num foo = 100;
}
class Colors {
  Colors._();
  static const Color blue = Color._();
}
class Color {
  const Color._();
}
class BoxStyler extends MixStyler {
  BoxStyler color(Object? c) => this;
  BoxStyler width(num n) => this;
  BoxStyler height(num n) => this;
  BoxStyler paddingAll(num n) => this;
  BoxStyler padding(EdgeInsetsGeometryMix e) => this;
  BoxStyler onHovered(MixStyler s) => this;
  BoxStyler onDark(MixStyler s) => this;
}
class TextStyler extends MixStyler {
  TextStyler fontWeight(FontWeight w) => this;
}
''';

const String mixAnnotationsStubLibContent = r'''
class MixableStyler {
  const MixableStyler();
}
''';
