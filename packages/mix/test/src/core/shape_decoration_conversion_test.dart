import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  const red = Color(0xFFFF0000);
  const blue = Color(0xFF0000FF);
  const shape = RoundedSuperellipseBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
    side: BorderSide(color: blue, width: 2),
  );
  const decoration = ShapeDecoration(
    shape: shape,
    color: red,
    shadows: [BoxShadow(blurRadius: 4, offset: Offset(1, 2))],
  );
  const recolored = ShapeDecoration(
    shape: shape,
    color: blue,
    shadows: [BoxShadow(blurRadius: 4, offset: Offset(1, 2))],
  );

  test('converts ShapeDecoration through its concrete and base types', () {
    final registry = MixConverterRegistry.instance;
    final context = MockBuildContext();

    expect(registry.convert(decoration).resolve(context), decoration);
    expect(
      registry.convert<Decoration>(decoration).resolve(context),
      decoration,
    );
    expect(Prop.mixValue(decoration), resolvesTo(decoration));
  });

  test('a color patch preserves a raw shape decoration and shadows', () {
    final style = BoxStyler.create(
      decoration: Prop.value<Decoration>(decoration),
    ).merge(BoxStyler().color(blue));

    expect(style.resolve(MockBuildContext()).spec.decoration, recolored);
  });

  test('a later raw shape decoration retains fieldwise merge precedence', () {
    final style = BoxStyler()
        .color(blue)
        .merge(
          BoxStyler.create(decoration: Prop.value<Decoration>(decoration)),
        );

    expect(style.resolve(MockBuildContext()).spec.decoration, decoration);
  });

  test('concrete ShapeDecoration props merge with partial Mix values', () {
    final prop = Prop.value(
      decoration,
    ).mergeProp(Prop.mix(ShapeDecorationMix(color: blue)));

    expect(prop, resolvesTo(recolored));
  });

  test('a decoration token can be combined with a color patch', () {
    const token = TestToken<Decoration>('surface');
    final style = BoxStyler.create(
      decoration: Prop.token(token),
    ).merge(BoxStyler().color(blue));
    final context = MockBuildContext(tokens: {token: decoration});

    expect(style.resolve(context).spec.decoration, recolored);
  });

  test('unsupported decoration subtypes still require a custom converter', () {
    expect(
      () => MixConverterRegistry.instance.convert<Decoration>(
        const _CustomDecoration(),
      ),
      throwsUnimplementedError,
    );
  });
}

class _CustomDecoration extends Decoration {
  const _CustomDecoration();

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      const BoxDecoration().createBoxPainter(onChanged);
}
