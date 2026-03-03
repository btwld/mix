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
class BoxStyler extends MixStyler {
  BoxStyler color(Object? c) => this;
  BoxStyler paddingAll(num n) => this;
  BoxStyler onHovered(MixStyler s) => this;
  BoxStyler onDark(MixStyler s) => this;
}
''';

const String mixAnnotationsStubLibContent = r'''
class MixableStyler {
  const MixableStyler();
}
''';
