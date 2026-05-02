import 'package:mix_schema/mix_schema.dart';
import 'package:test/test.dart';

ModifierNode roundTrip(ModifierNode node) {
  final encoded = node.toJson();
  final decoded = ModifierNode.fromJson(encoded);
  expect(decoded, isNotNull);
  expect(decoded, equals(node), reason: 'round-trip failed for ${node.modifier}');
  expect(decoded!.toJson(), equals(encoded));
  return decoded;
}

void main() {
  test('ModifierReset round-trip', () {
    roundTrip(const ModifierReset());
  });

  test('ModifierExtension preserves payload', () {
    final m = ModifierExtension(
      ExtensionId.unsafe('x:parallax'),
      const {'props': {'speed': 0.5}},
    );
    roundTrip(m);
  });

  test('ModifierBox carries a raw StyleNode (not a Value)', () {
    final m = ModifierBox(
      style: StyleBox(const LeafStyleProps()),
    );
    final decoded = roundTrip(m);
    expect((decoded as ModifierBox).style, isA<StyleBox>());
  });

  test('ModifierDefaultTextStyler carries a raw StyleNode', () {
    final m = ModifierDefaultTextStyler(
      style: const StyleText(),
    );
    final decoded = roundTrip(m);
    expect((decoded as ModifierDefaultTextStyler).style, isA<StyleText>());
  });

  test('ModifierClipPath — clipper is a HostRef', () {
    final m = ModifierClipPath(
      clipper: const HostRef('clipper.ticket'),
      clipBehavior: const ValueLiteral('hardEdge'),
    );
    final decoded = roundTrip(m);
    expect((decoded as ModifierClipPath).clipper.id, 'clipper.ticket');
  });

  test('ModifierShaderMask — shader is a HostRef', () {
    final m = ModifierShaderMask(
      shader: const HostRef('gradient.brand'),
      blendMode: const ValueLiteral('srcATop'),
    );
    roundTrip(m);
  });

  test('PropertyValue-only modifiers round-trip', () {
    roundTrip(ModifierOpacity({'opacity': const ValueLiteral(0.5)}));
    roundTrip(ModifierBlur({'sigma': const ValueLiteral(2)}));
    roundTrip(ModifierAspectRatio({'aspectRatio': const ValueLiteral(1.6)}));
    roundTrip(ModifierSizedBox({
      'width': const ValueLiteral(100),
      'height': const ValueLiteral(50),
    }));
    roundTrip(ModifierPadding({
      'padding': const ValueLiteral({'top': {'value': 8}}),
    }));
    roundTrip(ModifierAlign({'alignment': const ValueLiteral('center')}));
    roundTrip(ModifierFlexible({
      'flex': const ValueLiteral(1),
      'fit': const ValueLiteral('tight'),
    }));
    roundTrip(const ModifierIntrinsicHeight({}));
    roundTrip(const ModifierIntrinsicWidth({}));
    roundTrip(ModifierRotatedBox({'quarterTurns': const ValueLiteral(1)}));
    roundTrip(ModifierVisibility({'visible': const ValueLiteral(true)}));
    roundTrip(ModifierClipOval({'clipBehavior': const ValueLiteral('antiAlias')}));
    roundTrip(ModifierClipRect({'clipBehavior': const ValueLiteral('antiAlias')}));
    roundTrip(ModifierClipRRect({
      'borderRadius': const ValueLiteral({}),
      'clipBehavior': const ValueLiteral('antiAlias'),
    }));
    roundTrip(ModifierClipTriangle({'clipBehavior': const ValueLiteral('antiAlias')}));
    roundTrip(ModifierTransform({'transform': const ValueLiteral({})}));
    roundTrip(ModifierScale({
      'x': const ValueLiteral(1.1),
      'y': const ValueLiteral(1.1),
    }));
    roundTrip(ModifierRotate({'radians': const ValueLiteral(0.1)}));
    roundTrip(ModifierTranslate({
      'x': const ValueLiteral(1),
      'y': const ValueLiteral(2),
    }));
    roundTrip(ModifierSkew({
      'skewX': const ValueLiteral(0.1),
      'skewY': const ValueLiteral(0.1),
    }));
    roundTrip(ModifierFractionallySizedBox({
      'widthFactor': const ValueLiteral(0.5),
    }));
    roundTrip(ModifierIconTheme({
      'color': const ValueLiteral('#000000ff'),
      'size': const ValueLiteral(24),
    }));
    roundTrip(ModifierDefaultTextStyle({
      'maxLines': const ValueLiteral(2),
    }));
    roundTrip(ModifierMouseCursor({'cursor': const ValueLiteral('click')}));
    roundTrip(ModifierScrollView({'scrollDirection': const ValueLiteral('vertical')}));
  });

  test('catalog matches registry — 30 modifiers + reset = 31 entries (+ x: extensions)', () {
    // 30 closed-set modifiers (per registry).
    // Note: `box`, `defaultTextStyler`, `clipPath`, `shaderMask` are
    // handled with explicit classes; `reset` is a sentinel; extensions are
    // open-ended (any `x:` atom).
    final expected = const {
      'opacity', 'blur', 'aspectRatio', 'sizedBox', 'padding', 'align',
      'flexible', 'rotatedBox', 'visibility', 'clipOval', 'clipRect',
      'clipRRect', 'clipPath', 'clipTriangle', 'transform', 'scale', 'rotate',
      'translate', 'skew', 'shaderMask', 'fractionallySizedBox',
      'intrinsicHeight', 'intrinsicWidth', 'iconTheme', 'defaultTextStyle',
      'defaultTextStyler', 'box', 'mouseCursor', 'scrollView', 'reset',
    };
    expect(allModifierNames, equals(expected));
    expect(allModifierNames, hasLength(30));
  });

  test('unknown modifier returns null', () {
    expect(ModifierNode.fromJson({'modifier': 'never_heard_of'}), isNull);
  });
}
