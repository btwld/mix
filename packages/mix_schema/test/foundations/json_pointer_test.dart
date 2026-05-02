import 'package:mix_schema/src/_internal.dart';
import 'package:test/test.dart';

void main() {
  group('JsonPointer.escape', () {
    test('returns the input untouched when no escape needed', () {
      expect(JsonPointer.escape('foo'), 'foo');
      expect(JsonPointer.escape(''), '');
      expect(JsonPointer.escape('hello world'), 'hello world');
    });

    test('escapes "/" to "~1"', () {
      expect(JsonPointer.escape('a/b'), 'a~1b');
    });

    test('escapes "~" to "~0"', () {
      expect(JsonPointer.escape('a~b'), 'a~0b');
    });

    test('escapes "~0" literal so it round-trips correctly', () {
      // RFC 6901 §4: the input "~0" must encode to "~00" so that
      // unescape("~00") returns "~0", not "~".
      expect(JsonPointer.escape('~0'), '~00');
    });

    test('escapes mixed tokens in a single string', () {
      expect(JsonPointer.escape('a/b~c'), 'a~1b~0c');
    });
  });

  group('JsonPointer.unescape', () {
    test('returns the input untouched when no escape present', () {
      expect(JsonPointer.unescape('foo'), 'foo');
      expect(JsonPointer.unescape(''), '');
    });

    test('unescapes "~1" to "/"', () {
      expect(JsonPointer.unescape('a~1b'), 'a/b');
    });

    test('unescapes "~0" to "~"', () {
      expect(JsonPointer.unescape('a~0b'), 'a~b');
    });

    test('handles "~01" correctly (must not become "/")', () {
      expect(JsonPointer.unescape('~01'), '~1');
    });
  });

  group('escape/unescape round-trip', () {
    final cases = ['', 'foo', 'a/b', 'a~b', '~0', '~/~', 'a/b/c', 'foo bar'];
    for (final input in cases) {
      test('round-trips "$input"', () {
        expect(JsonPointer.unescape(JsonPointer.escape(input)), input);
      });
    }
  });

  group('JsonPointer.appendKey / appendIndex', () {
    test('appends a key with leading slash', () {
      expect(JsonPointer.appendKey('', 'root'), '/root');
      expect(JsonPointer.appendKey('/root', 'child'), '/root/child');
    });

    test('escapes the key when it contains "/" or "~"', () {
      expect(JsonPointer.appendKey('/x', 'a/b'), '/x/a~1b');
      expect(JsonPointer.appendKey('/x', 'a~b'), '/x/a~0b');
    });

    test('appends an index numerically', () {
      expect(JsonPointer.appendIndex('/root', 0), '/root/0');
      expect(JsonPointer.appendIndex('/root/children', 42), '/root/children/42');
    });
  });

  group('JsonPointer.decode', () {
    test('returns empty list for the root pointer', () {
      expect(JsonPointer.decode(''), <String>[]);
    });

    test('decodes a simple two-token pointer', () {
      expect(JsonPointer.decode('/root/child'), ['root', 'child']);
    });

    test('decodes an escaped token', () {
      expect(JsonPointer.decode('/a~1b/c~0d'), ['a/b', 'c~d']);
    });

    test('throws FormatException on malformed pointer', () {
      expect(() => JsonPointer.decode('no-slash'), throwsFormatException);
    });
  });
}
