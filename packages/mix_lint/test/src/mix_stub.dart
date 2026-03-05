// Stub types for testing mix_lint rules without depending on the full mix package.
// Used by analysis_rule tests that need MixStyler, MixToken, MixScope resolution.

const String mixStubLibContent = r'''
abstract class MixStyler {}
abstract class MixToken<T> {}
class MyToken extends MixToken<int> {
  const MyToken();
}
class MixScope {
  MixScope([Map<Object?, Object?>? tokens]);
}
class EdgeInsetsGeometryMix {
  EdgeInsetsGeometryMix();
  static EdgeInsetsGeometryMix all(double value) => EdgeInsetsGeometryMix();
}
class FontWeight {
  FontWeight();
  static final FontWeight w600 = FontWeight();
}
class Constants {
  static const num foo = 100;
}
class BoxStyler extends MixStyler {
  BoxStyler color(Object? c) => this;
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
