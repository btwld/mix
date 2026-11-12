import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

import '../../helpers/testing_utils.dart';

void main() {
  const red = Color(0xFFFF0000);
  const blue = Color(0xFF0000FF);
  const decoration = _PatternDecoration(ink: red, spacing: 4);

  test('raw custom decorations compose with independent styling fields', () {
    final raw = BoxStyler.create(
      decoration: Prop.value<Decoration>(decoration),
    );
    final layout = BoxStyler().padding(.all(12)).width(80);

    for (final style in [raw.merge(layout), layout.merge(raw)]) {
      final spec = style.resolve(MockBuildContext()).spec;
      expect(spec.decoration, same(decoration));
      expect(spec.padding, const EdgeInsets.all(12));
      expect(spec.constraints, const BoxConstraints.tightFor(width: 80));
    }

    const replacement = _PatternDecoration(ink: blue, spacing: 8);
    final replaced = raw.merge(
      BoxStyler.create(decoration: Prop.value<Decoration>(replacement)),
    );
    expect(
      replaced.resolve(MockBuildContext()).spec.decoration,
      same(replacement),
    );
  });

  test('custom Mix values merge their own fields and resolve tokens', () {
    const ink = ColorToken('pattern.ink');
    final base = BoxStyler.create(
      decoration: Prop.mix<Decoration>(_PatternMix(ink: ink())),
    );
    final patch = BoxStyler.create(
      decoration: Prop.mix<Decoration>(_PatternMix(spacing: 12)),
    );
    final context = MockBuildContext(tokens: {ink: red});

    final resolved =
        base.merge(patch).resolve(context).spec.decoration!
            as _PatternDecoration;
    expect(resolved.ink, red);
    expect(resolved.spacing, 12);
  });

  test(
    'conversion uses the property type and supports compatible custom patches',
    () {
      final registry = MixConverterRegistry.instance;
      registry.convert(const BoxDecoration());
      final previous = registry.get<Decoration>()!;
      addTearDown(() => registry.register<Decoration>(previous));
      registry.register<_PatternDecoration>(
        SimpleMixConverter<_PatternDecoration>(_PatternMix.value),
      );
      expect(registry.convert(decoration), isA<_PatternMix>());
      expect(
        () => registry.convert<Decoration>(decoration),
        throwsUnimplementedError,
      );

      registry.register<Decoration>(
        SimpleMixConverter<Decoration>(
          (value) => value is _PatternDecoration
              ? _PatternMix.value(value)
              : DecorationMix.value(value),
        ),
      );
      final raw = BoxStyler.create(
        decoration: Prop.value<Decoration>(decoration),
      );
      final patch = BoxStyler.create(
        decoration: Prop.mix<Decoration>(_PatternMix(spacing: 12)),
      );

      final after =
          raw.merge(patch).resolve(MockBuildContext()).spec.decoration!
              as _PatternDecoration;
      expect(after.ink, red);
      expect(after.spacing, 12);
      final before =
          patch.merge(raw).resolve(MockBuildContext()).spec.decoration!
              as _PatternDecoration;
      expect(before.ink, red);
      expect(before.spacing, 4);
      expect(
        registry.convert<Decoration>(const BoxDecoration(color: blue)),
        resolvesTo(const BoxDecoration(color: blue)),
      );
    },
  );
}

class _PatternDecoration extends Decoration {
  final Color ink;
  final double spacing;

  const _PatternDecoration({required this.ink, required this.spacing});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      const BoxDecoration().createBoxPainter(onChanged);
}

class _PatternMix extends Mix<_PatternDecoration> {
  final Prop<Color>? $ink;
  final Prop<double>? $spacing;

  const _PatternMix.create({Prop<Color>? ink, Prop<double>? spacing})
    : $ink = ink,
      $spacing = spacing;

  _PatternMix({Color? ink, double? spacing})
    : this.create(ink: Prop.maybe(ink), spacing: Prop.maybe(spacing));

  _PatternMix.value(_PatternDecoration value)
    : this(ink: value.ink, spacing: value.spacing);

  @override
  _PatternMix merge(covariant _PatternMix? other) => _PatternMix.create(
    ink: MixOps.merge($ink, other?.$ink),
    spacing: MixOps.merge($spacing, other?.$spacing),
  );

  @override
  _PatternDecoration resolve(BuildContext context) => _PatternDecoration(
    ink: MixOps.resolve(context, $ink) ?? const Color(0xFF000000),
    spacing: MixOps.resolve(context, $spacing) ?? 0,
  );

  @override
  List<Object?> get props => [$ink, $spacing];
}
