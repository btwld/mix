import 'package:flutter_test/flutter_test.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('DirectValue', () {
    test('stores value', () {
      const dv = DirectValue(42);
      expect(dv.value, 42);
    });

    test('equality for same values', () {
      const a = DirectValue('hello');
      const b = DirectValue('hello');
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('inequality for different values', () {
      const a = DirectValue(1);
      const b = DirectValue(2);
      expect(a, isNot(equals(b)));
    });

    test('supports various types', () {
      expect(const DirectValue(42), isA<DirectValue<int>>());
      expect(const DirectValue(3.14), isA<DirectValue<double>>());
      expect(const DirectValue('str'), isA<DirectValue<String>>());
      expect(const DirectValue(true), isA<DirectValue<bool>>());
      expect(const DirectValue(null), isA<DirectValue<Null>>());
    });

    test('toString', () {
      expect(const DirectValue(42).toString(), 'DirectValue(42)');
    });
  });

  group('TokenRef', () {
    test('stores type and name', () {
      const ref = TokenRef(type: 'color', name: 'primary');
      expect(ref.type, 'color');
      expect(ref.name, 'primary');
    });

    test('tokenName concatenates type.name', () {
      const ref = TokenRef(type: 'space', name: 'md');
      expect(ref.tokenName, 'space.md');
    });

    test('equality', () {
      const a = TokenRef(type: 'color', name: 'primary');
      const b = TokenRef(type: 'color', name: 'primary');
      const c = TokenRef(type: 'color', name: 'secondary');

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(equals(c)));
    });

    test('toString', () {
      const ref = TokenRef(type: 'color', name: 'primary');
      expect(ref.toString(), 'TokenRef(color.primary)');
    });
  });

  group('AdaptiveValue', () {
    test('stores light and dark', () {
      const av = AdaptiveValue(
        light: DirectValue('#000'),
        dark: DirectValue('#FFF'),
      );
      expect(av.light, const DirectValue('#000'));
      expect(av.dark, const DirectValue('#FFF'));
    });

    test('equality', () {
      const a = AdaptiveValue(
        light: DirectValue(0),
        dark: DirectValue(1),
      );
      const b = AdaptiveValue(
        light: DirectValue(0),
        dark: DirectValue(1),
      );
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('toString', () {
      const av = AdaptiveValue(
        light: DirectValue('L'),
        dark: DirectValue('D'),
      );
      expect(av.toString(), contains('AdaptiveValue'));
    });
  });

  group('ResponsiveValue', () {
    test('stores breakpoints', () {
      const rv = ResponsiveValue({
        'mobile': DirectValue(8.0),
        'desktop': DirectValue(24.0),
      });
      expect(rv.breakpoints['mobile'], const DirectValue(8.0));
      expect(rv.breakpoints['desktop'], const DirectValue(24.0));
    });

    test('equality', () {
      const a = ResponsiveValue({'m': DirectValue(1)});
      const b = ResponsiveValue({'m': DirectValue(1)});
      expect(a, equals(b));
    });

    test('inequality for different maps', () {
      const a = ResponsiveValue({'m': DirectValue(1)});
      const b = ResponsiveValue({'m': DirectValue(2)});
      expect(a, isNot(equals(b)));
    });
  });

  group('BindingValue', () {
    test('stores path', () {
      const bv = BindingValue('user.name');
      expect(bv.path, 'user.name');
    });

    test('equality', () {
      const a = BindingValue('path.a');
      const b = BindingValue('path.a');
      const c = BindingValue('path.b');

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(equals(c)));
    });

    test('toString', () {
      expect(const BindingValue('x.y').toString(), 'BindingValue(x.y)');
    });
  });

  group('TransformValue', () {
    test('stores path and transformKey', () {
      const tv = TransformValue(path: 'price', transformKey: 'currency');
      expect(tv.path, 'price');
      expect(tv.transformKey, 'currency');
    });

    test('equality', () {
      const a = TransformValue(path: 'x', transformKey: 'y');
      const b = TransformValue(path: 'x', transformKey: 'y');
      const c = TransformValue(path: 'x', transformKey: 'z');

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(equals(c)));
    });
  });

  group('SchemaValue sealed hierarchy', () {
    test('all subtypes are SchemaValue', () {
      const values = <SchemaValue>[
        DirectValue(42),
        TokenRef(type: 'color', name: 'primary'),
        AdaptiveValue(light: DirectValue(0), dark: DirectValue(1)),
        ResponsiveValue({'m': DirectValue(1)}),
        BindingValue('x.y'),
        TransformValue(path: 'x', transformKey: 'y'),
      ];

      expect(values.length, 6);
      for (final v in values) {
        expect(v, isA<SchemaValue>());
      }
    });

    test('pattern matching on SchemaValue', () {
      const SchemaValue value = DirectValue(42);

      final result = switch (value) {
        DirectValue(:final value) => 'direct: $value',
        TokenRef(:final tokenName) => 'token: $tokenName',
        AdaptiveValue() => 'adaptive',
        ResponsiveValue() => 'responsive',
        BindingValue(:final path) => 'binding: $path',
        TransformValue(:final path) => 'transform: $path',
      };

      expect(result, 'direct: 42');
    });
  });
}
