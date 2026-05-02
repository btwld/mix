import 'package:mix_schema/mix_schema.dart';
import 'package:test/test.dart';

void roundTripWhen(WhenExpr expr) {
  final encoded = expr.toJson();
  final decoded = WhenExpr.fromJson(encoded);
  expect(decoded, equals(expr), reason: 'round-trip failed for $encoded');
  expect(decoded.toJson(), equals(encoded));
}

void main() {
  test('WhenState — every closed-set state', () {
    for (final state in const [
      'onHovered',
      'onPressed',
      'onFocused',
      'onDisabled',
      'onEnabled',
      'onSelected',
      'onError',
      'onDark',
      'onLight',
    ]) {
      roundTripWhen(WhenState(state));
    }
  });

  test('WhenNamed', () {
    roundTripWhen(const WhenNamed('primary'));
  });

  test('WhenEnum', () {
    roundTripWhen(const WhenEnum('Size.lg'));
  });

  test('WhenContext — every kind', () {
    roundTripWhen(const WhenBreakpoint('breakpoint.md'));
    roundTripWhen(const WhenOrientation('portrait'));
    roundTripWhen(const WhenBrightness('dark'));
    roundTripWhen(const WhenPlatform('iOS'));
    roundTripWhen(const WhenDirectionality('ltr'));
    roundTripWhen(const WhenPreset('mobile'));
  });

  test('WhenNot — wraps another WhenExpr', () {
    roundTripWhen(WhenNot(WhenState('onHovered')));
    roundTripWhen(WhenNot(WhenNot(WhenState('onPressed'))));
  });

  test('WhenExtension — single x: key', () {
    roundTripWhen(WhenExtension(ExtensionId.unsafe('x:feature-flag'), 'beta'));
  });

  test('VariantNode round-trip', () {
    final v = VariantNode(
      when: const WhenState('onHovered'),
      style: StyleBox(LeafStyleProps(props: {
        'alignment': const ValueToken('color.primary'),
      })),
    );
    final encoded = v.toJson();
    final decoded = VariantNode.fromJson(encoded);
    expect(decoded, equals(v));
  });

  test('Unknown when shape throws', () {
    expect(() => WhenExpr.fromJson({'made_up': 1}), throwsFormatException);
    expect(() => WhenExpr.fromJson('madeUpState'), throwsFormatException);
  });
}
