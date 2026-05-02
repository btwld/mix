import 'package:mix_schema/mix_schema.dart';
import 'package:test/test.dart';

void main() {
  group('ExtensionId.parse', () {
    test('accepts valid atoms', () {
      for (final input in const ['x:foo', 'x:my-card', 'x:foo_bar', 'x:a1', 'x:a-b-c']) {
        expect(ExtensionId.parse(input)?.value, input,
            reason: input);
      }
    });

    test('rejects invalid atoms', () {
      for (final input in const [
        'foo', // missing x:
        'x:', // empty atom
        'x:Foo', // uppercase
        'x:1foo', // starts with digit
        'x:foo.bar', // dot inside atom
        'x:foo bar', // space
      ]) {
        expect(ExtensionId.parse(input), isNull, reason: input);
      }
    });
  });

  group('ExtensionId.isValidTokenPath', () {
    test('accepts valid paths', () {
      for (final input in const [
        'x:brand',
        'x:brand.primary',
        'x:motion.soft.v2',
      ]) {
        expect(ExtensionId.isValidTokenPath(input), isTrue, reason: input);
      }
    });

    test('rejects invalid paths', () {
      for (final input in const [
        'x:Brand.primary', // uppercase
        'x:brand..primary', // double-dot
        'brand.primary', // missing x:
        'x:', // empty
      ]) {
        expect(ExtensionId.isValidTokenPath(input), isFalse, reason: input);
      }
    });
  });

  test('ExtensionId equality and hashCode are by value', () {
    final a = ExtensionId.parse('x:foo')!;
    final b = ExtensionId.parse('x:foo')!;
    expect(a, equals(b));
    expect(a.hashCode, b.hashCode);
  });
}
