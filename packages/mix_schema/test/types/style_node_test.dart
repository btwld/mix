import 'package:mix_schema/mix_schema.dart';
import 'package:test/test.dart';

void roundTrip(StyleNode node) {
  final encoded = node.toJson();
  final decoded = StyleNode.fromJson(encoded);
  expect(decoded, equals(node), reason: 'round-trip failed for spec=${node.spec}');
  expect(decoded.toJson(), equals(encoded));
}

void main() {
  test('Leaf StyleNodes — every spec', () {
    roundTrip(StyleBox(LeafStyleProps(props: {
      'alignment': const ValueToken('color.primary'),
    })));
    roundTrip(StyleFlex(LeafStyleProps(props: {
      'mainAxisAlignment': const ValueLiteral('center'),
    })));
    roundTrip(const StyleText());
    roundTrip(StyleIcon(LeafStyleProps(props: {
      'size': const ValueLiteral(24),
    })));
    roundTrip(StyleImage(LeafStyleProps(props: {
      'fit': const ValueLiteral('cover'),
    })));
    roundTrip(StyleStack(LeafStyleProps(props: {
      'fit': const ValueLiteral('expand'),
    })));
  });

  test('StyleText carries textDirectives', () {
    final s = StyleText(
      props: const {},
      textDirectives: [
        const DirectiveUppercase().toJson(),
      ],
    );
    final encoded = s.toJson();
    expect(encoded['textDirectives'], isA<List<Object?>>());
    final decoded = StyleNode.fromJson(encoded) as StyleText;
    expect(decoded.textDirectives, hasLength(1));
  });

  test('Composite StyleNodes — flexbox', () {
    final s = StyleFlexBox(
      box: SubStyleBox({'padding': const ValueLiteral({})}),
      flex: SubStyleFlex({'mainAxisAlignment': const ValueLiteral('center')}),
    );
    roundTrip(s);
  });

  test('Composite StyleNodes — stackbox', () {
    final s = StyleStackBox(
      box: SubStyleBox({}),
      stack: SubStyleStack({'fit': const ValueLiteral('expand')}),
    );
    roundTrip(s);
  });

  test('SubStyleNode — restricted shape (no variants/modifiers)', () {
    final sb = SubStyleBox({'padding': const ValueLiteral({})});
    final encoded = sb.toJson();
    expect(encoded.keys, equals(['spec', 'props']));
  });

  test('StyleExtension — preserves x: payload', () {
    final s = StyleExtension(
      ExtensionId.unsafe('x:my-card'),
      const {'props': {'tint': '#ff0000ff'}},
    );
    roundTrip(s);
  });

  test('Variants embedded in a StyleNode round-trip', () {
    final s = StyleBox(LeafStyleProps(
      variants: [
        VariantNode(
          when: const WhenState('onHovered'),
          style: StyleBox(LeafStyleProps(props: {
            'alignment': const ValueToken('color.primary'),
          })),
        ),
      ],
    ));
    roundTrip(s);
  });

  test('Modifiers embedded in a StyleNode round-trip', () {
    final s = StyleBox(LeafStyleProps(
      modifiers: [
        ModifierOpacity({'opacity': const ValueLiteral(0.5)}),
        const ModifierReset(),
      ],
    ));
    roundTrip(s);
  });

  test('Animation embedded in a StyleNode round-trips both kinds', () {
    final curve = StyleBox(LeafStyleProps(
      animation: const AnimationCurve(duration: 200, curve: 'easeOut'),
    ));
    roundTrip(curve);

    final preset = StyleBox(LeafStyleProps(
      animation: const AnimationPreset(kind: 'easeIn', duration: 300),
    ));
    roundTrip(preset);
  });
}
