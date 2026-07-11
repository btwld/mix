import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

/// A custom [WidgetModifier] that is intentionally absent from `defaultModifier`,
/// so it exercises the "no neutral default" interpolation path with a type that
/// is not a built-in.
final class _TagModifier extends WidgetModifier<_TagModifier> {
  const _TagModifier(this.tag);

  final String tag;

  @override
  _TagModifier copyWith() => _TagModifier(tag);

  @override
  _TagModifier lerp(_TagModifier? other, double t) =>
      t < 0.5 ? this : (other ?? this);

  @override
  List<Object?> get props => [tag];

  @override
  Widget build(Widget child) =>
      KeyedSubtree(key: ValueKey('tag:$tag'), child: child);
}

/// Returns the first modifier of type [X] in [list], or null if absent.
X? _firstOfType<X extends WidgetModifier<X>>(List<WidgetModifier>? list) {
  if (list == null) return null;
  for (final m in list) {
    if (m is X) return m;
  }

  return null;
}

bool _has<X extends WidgetModifier<X>>(List<WidgetModifier>? list) =>
    _firstOfType<X>(list) != null;

void main() {
  // Membership snap point documented by ModifierListTween.
  const snap = 0.5;
  const belowSnap = 0.49;

  group('ModifierListTween.lerp — endpoint invariants', () {
    // lerp(0) == begin and lerp(1) == end for every membership case in the
    // interpolation matrix.
    final cases =
        <String, ({List<WidgetModifier>? begin, List<WidgetModifier>? end})>{
          'present -> present (neutral yes)': (
            begin: [OpacityModifier(0.2)],
            end: [OpacityModifier(0.8)],
          ),
          'present -> present (neutral no)': (
            begin: [MouseCursorModifier(mouseCursor: SystemMouseCursors.click)],
            end: [
              MouseCursorModifier(mouseCursor: SystemMouseCursors.forbidden),
            ],
          ),
          'absent -> present (neutral yes)': (
            begin: <WidgetModifier>[],
            end: [OpacityModifier(0.8)],
          ),
          'absent -> present (neutral no)': (
            begin: <WidgetModifier>[],
            end: [MouseCursorModifier(mouseCursor: SystemMouseCursors.click)],
          ),
          'present -> absent (neutral yes)': (
            begin: [PaddingModifier(const EdgeInsets.all(10))],
            end: <WidgetModifier>[],
          ),
          'present -> absent (neutral no)': (
            begin: [MouseCursorModifier(mouseCursor: SystemMouseCursors.click)],
            end: <WidgetModifier>[],
          ),
          'custom absent -> present (no neutral)': (
            begin: <WidgetModifier>[],
            end: [const _TagModifier('x')],
          ),
          'custom present -> absent (no neutral)': (
            begin: [const _TagModifier('x')],
            end: <WidgetModifier>[],
          ),
          'null begin': (begin: null, end: [OpacityModifier(0.8)]),
          'null end': (begin: [OpacityModifier(0.2)], end: null),
        };

    cases.forEach((name, data) {
      test('$name: lerp(0) == begin, lerp(1) == end', () {
        final tween = ModifierListTween(begin: data.begin, end: data.end);

        expect(tween.lerp(0.0), data.begin, reason: 'lerp(0) must equal begin');
        expect(tween.lerp(1.0), data.end, reason: 'lerp(1) must equal end');
      });
    });
  });

  group('ModifierListTween.lerp — issue probe regression', () {
    test('addition without a neutral is absent at t=0 and present at t=1', () {
      final tween = ModifierListTween(
        begin: const [],
        end: [MouseCursorModifier(mouseCursor: SystemMouseCursors.click)],
      );

      // On origin/main this was inverted: present at t=0, empty at t=1.
      expect(_has<MouseCursorModifier>(tween.lerp(0.0)), isFalse);
      expect(
        _firstOfType<MouseCursorModifier>(tween.lerp(1.0))?.mouseCursor,
        SystemMouseCursors.click,
      );
    });
  });

  group('ModifierListTween.lerp — present on both sides', () {
    test('interpolates the value across the whole range', () {
      final tween = ModifierListTween(
        begin: [OpacityModifier(0.2)],
        end: [OpacityModifier(0.8)],
      );

      expect(
        _firstOfType<OpacityModifier>(tween.lerp(0.5))!.opacity,
        closeTo(0.5, 1e-9),
      );
      expect(_has<OpacityModifier>(tween.lerp(belowSnap)), isTrue);
      expect(_has<OpacityModifier>(tween.lerp(snap)), isTrue);
    });
  });

  group(
    'ModifierListTween.lerp — addition with a neutral default (opacity)',
    () {
      final tween = ModifierListTween(
        begin: const [],
        end: [OpacityModifier(0.8)],
      );

      test('present throughout, interpolating neutral(1.0) -> target(0.8)', () {
        // Present before, at, and after the snap point.
        expect(_has<OpacityModifier>(tween.lerp(belowSnap)), isTrue);
        expect(_has<OpacityModifier>(tween.lerp(snap)), isTrue);
        expect(_has<OpacityModifier>(tween.lerp(0.9)), isTrue);

        // Neutral is 1.0, so at t=0.5 it is halfway to 0.8.
        expect(
          _firstOfType<OpacityModifier>(tween.lerp(0.5))!.opacity,
          closeTo(0.9, 1e-9),
        );
      });
    },
  );

  group(
    'ModifierListTween.lerp — removal with a neutral default (padding)',
    () {
      final tween = ModifierListTween(
        begin: [PaddingModifier(const EdgeInsets.all(10))],
        end: const [],
      );

      test('present throughout, interpolating begin(10) -> neutral(0)', () {
        expect(_has<PaddingModifier>(tween.lerp(belowSnap)), isTrue);
        expect(_has<PaddingModifier>(tween.lerp(snap)), isTrue);
        expect(_has<PaddingModifier>(tween.lerp(0.9)), isTrue);

        expect(
          _firstOfType<PaddingModifier>(tween.lerp(0.5))!.padding,
          const EdgeInsets.all(5),
        );
      });
    },
  );

  group('ModifierListTween.lerp — addition without a neutral (snap in)', () {
    // Uses both a built-in (MouseCursor) and a custom modifier (_TagModifier).
    test('absent before the snap point, present at/after it', () {
      final cursor = ModifierListTween(
        begin: const [],
        end: [MouseCursorModifier(mouseCursor: SystemMouseCursors.click)],
      );
      expect(_has<MouseCursorModifier>(cursor.lerp(belowSnap)), isFalse);
      expect(_has<MouseCursorModifier>(cursor.lerp(snap)), isTrue);
      expect(_has<MouseCursorModifier>(cursor.lerp(0.9)), isTrue);

      final custom = ModifierListTween(
        begin: const [],
        end: [const _TagModifier('x')],
      );
      expect(_has<_TagModifier>(custom.lerp(belowSnap)), isFalse);
      expect(_has<_TagModifier>(custom.lerp(snap)), isTrue);
    });
  });

  group('ModifierListTween.lerp — removal without a neutral (snap out)', () {
    test('present before the snap point, absent at/after it', () {
      final cursor = ModifierListTween(
        begin: [MouseCursorModifier(mouseCursor: SystemMouseCursors.click)],
        end: const [],
      );
      expect(_has<MouseCursorModifier>(cursor.lerp(belowSnap)), isTrue);
      expect(_has<MouseCursorModifier>(cursor.lerp(snap)), isFalse);
      expect(_has<MouseCursorModifier>(cursor.lerp(0.9)), isFalse);

      final custom = ModifierListTween(
        begin: [const _TagModifier('x')],
        end: const [],
      );
      expect(_has<_TagModifier>(custom.lerp(belowSnap)), isTrue);
      expect(_has<_TagModifier>(custom.lerp(snap)), isFalse);
    });

    // Null dimensions/factors make SizedBox and FractionallySizedBox no-ops
    // when built, but their numeric lerps treat null as zero. They therefore
    // cannot serve as interpolation identities either.
    final modifiersWithoutIdentity = <WidgetModifier>[
      const FlexibleModifier(),
      const IconThemeModifier(),
      const DefaultTextStyleModifier(),
      const SizedBoxModifier(),
      const FractionallySizedBoxModifier(),
      const IntrinsicHeightModifier(),
      const IntrinsicWidthModifier(),
      const AspectRatioModifier(),
      const AlignModifier(),
      const ClipOvalModifier(),
      const ClipRRectModifier(),
      const ClipPathModifier(),
      const ClipTriangleModifier(),
    ];

    for (final modifier in modifiersWithoutIdentity) {
      test('${modifier.runtimeType} snaps in both directions', () {
        final addition = ModifierListTween(begin: const [], end: [modifier]);
        final removal = ModifierListTween(begin: [modifier], end: const []);

        expect(
          addition.lerp(belowSnap),
          isNull,
          reason: '${modifier.runtimeType} has no neutral addition anchor',
        );
        expect(
          addition.lerp(snap)?.single.runtimeType,
          modifier.runtimeType,
          reason: '${modifier.runtimeType} must snap in at the midpoint',
        );
        expect(
          removal.lerp(belowSnap)?.single.runtimeType,
          modifier.runtimeType,
          reason: '${modifier.runtimeType} must remain before the midpoint',
        );
        expect(
          removal.lerp(snap),
          isNull,
          reason: '${modifier.runtimeType} has no neutral removal anchor',
        );
      });
    }
  });

  group('ModifierListTween.lerp — mixed membership keeps target order', () {
    test('union is ordered by the canonical modifier order', () {
      // Opacity is outermost-last in the default order; Padding precedes it.
      final tween = ModifierListTween(
        begin: [OpacityModifier(0.2)],
        end: [PaddingModifier(const EdgeInsets.all(8)), OpacityModifier(0.8)],
      );

      final mid = tween.lerp(0.5)!;
      final types = mid.map((m) => m.runtimeType).toList();
      expect(
        types.indexOf(PaddingModifier),
        lessThan(types.indexOf(OpacityModifier)),
      );
    });

    test('preserves a resolved non-default target order', () {
      final tween = ModifierListTween(
        begin: [OpacityModifier(0.2), PaddingModifier(const EdgeInsets.all(4))],
        end: [OpacityModifier(0.8), PaddingModifier(const EdgeInsets.all(8))],
      );

      expect(tween.lerp(0.5)!.map((modifier) => modifier.runtimeType), [
        OpacityModifier,
        PaddingModifier,
      ]);
    });
  });
}
