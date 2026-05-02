import 'package:mix_schema/mix_schema.dart';
import 'package:test/test.dart';

void main() {
  group('PropertyValue', () {
    test('ValueLiteral round-trip with primitive', () {
      const v = ValueLiteral(16);
      final j = v.toJson();
      expect(PropertyValue.fromJson(j), equals(v));
      expect(j, equals({'value': 16}));
    });

    test('ValueLiteral with directives round-trips', () {
      final v = ValueLiteral(
        '#ffffffff',
        directives: const [DirectiveDarken(10), DirectiveOpacity(0.5)],
      );
      expect(PropertyValue.fromJson(v.toJson()), equals(v));
    });

    test('ValueToken round-trip', () {
      const v = ValueToken('color.primary');
      final decoded = PropertyValue.fromJson(v.toJson());
      expect(decoded, equals(v));
    });

    test('ValueDirectivesOnly round-trip', () {
      final v = ValueDirectivesOnly(const [DirectiveOpacity(0.8)]);
      expect(PropertyValue.fromJson(v.toJson()), equals(v));
    });

    test('rejects empty object', () {
      expect(PropertyValue.fromJson(<String, Object?>{}), isNull);
    });

    test('rejects mutual-exclusion violation (value + token)', () {
      expect(
        PropertyValue.fromJson({'value': 1, 'token': 'color.primary'}),
        isNull,
      );
    });

    test('rejects null literal (Decision: value.null-forbidden)', () {
      expect(PropertyValue.fromJson({'value': null}), isNull);
    });

    test('rejects bare scalar (canonicalizer is responsible for sugar)', () {
      expect(PropertyValue.fromJson(16), isNull);
      expect(PropertyValue.fromJson('hello'), isNull);
    });
  });

  group('HostRef', () {
    test('round-trip', () {
      const h = HostRef('clipper.ticket');
      final j = h.toJson();
      expect(HostRef.fromJson(j), equals(h));
      expect(j, equals({'host': 'clipper.ticket'}));
    });

    test('rejects empty id', () {
      expect(() => HostRef.fromJson({'host': ''}), throwsFormatException);
    });
  });

  group('structured literals — round-trip every shape', () {
    test('EdgeInsets', () {
      final e = EdgeInsetsLiteral(
        top: const ValueLiteral(8),
        left: const ValueLiteral(8),
        right: const ValueLiteral(8),
        bottom: const ValueLiteral(8),
      );
      expect(EdgeInsetsLiteral.fromJson(e.toJson()), equals(e));
    });

    test('BorderRadius', () {
      final b = BorderRadiusLiteral(
        topLeft: const ValueLiteral(4),
        topRight: const ValueLiteral(4),
        bottomLeft: const ValueLiteral(4),
        bottomRight: const ValueLiteral(4),
      );
      expect(BorderRadiusLiteral.fromJson(b.toJson()), equals(b));
    });

    test('BoxConstraints', () {
      final c = BoxConstraintsLiteral(
        minWidth: const ValueLiteral(0),
        maxWidth: const ValueLiteral(100),
      );
      expect(BoxConstraintsLiteral.fromJson(c.toJson()), equals(c));
    });

    test('Size / Offset / Rect', () {
      final s = SizeLiteral(
          width: const ValueLiteral(10), height: const ValueLiteral(20));
      expect(SizeLiteral.fromJson(s.toJson()), equals(s));

      final o = OffsetLiteral(
          dx: const ValueLiteral(1), dy: const ValueLiteral(2));
      expect(OffsetLiteral.fromJson(o.toJson()), equals(o));

      final r = RectLiteral(
        left: const ValueLiteral(0),
        top: const ValueLiteral(0),
        right: const ValueLiteral(10),
        bottom: const ValueLiteral(10),
      );
      expect(RectLiteral.fromJson(r.toJson()), equals(r));
    });

    test('Alignment', () {
      final a = AlignmentLiteral(
          x: const ValueLiteral(0), y: const ValueLiteral(0));
      expect(AlignmentLiteral.fromJson(a.toJson()), equals(a));
    });

    test('Matrix4 with mixed ops', () {
      final m = Matrix4Literal([
        const Matrix4Identity(),
        Matrix4Translate(
            x: const ValueLiteral(1), y: const ValueLiteral(2)),
        Matrix4Scale(x: const ValueLiteral(2), y: const ValueLiteral(2)),
        Matrix4RotateZ(radians: const ValueLiteral(0.1)),
      ]);
      expect(Matrix4Literal.fromJson(m.toJson()), equals(m));
    });

    test('Shadow / BorderSide / Border', () {
      final s = ShadowLiteral(
        color: const ValueLiteral('#00000080'),
        blurRadius: const ValueLiteral(4),
      );
      expect(ShadowLiteral.fromJson(s.toJson()), equals(s));

      final bs = BorderSideLiteral(
          color: const ValueLiteral('#000000ff'), width: const ValueLiteral(1));
      expect(BorderSideLiteral.fromJson(bs.toJson()), equals(bs));

      final b = BorderLiteral(top: const ValueLiteral({}));
      expect(BorderLiteral.fromJson(b.toJson()), equals(b));
    });

    test('Decoration', () {
      final d = DecorationLiteral(
        color: const ValueLiteral('#ffffffff'),
        shape: const ValueLiteral('rectangle'),
      );
      expect(DecorationLiteral.fromJson(d.toJson()), equals(d));
    });

    test('Gradient — all 3 kinds', () {
      final linear = LinearGradientLiteral(begin: const ValueLiteral({}));
      expect(GradientLiteral.fromJson(linear.toJson()), isA<LinearGradientLiteral>());

      final radial = RadialGradientLiteral(radius: const ValueLiteral(10));
      expect(GradientLiteral.fromJson(radial.toJson()), isA<RadialGradientLiteral>());

      final sweep = SweepGradientLiteral(startAngle: const ValueLiteral(0));
      expect(GradientLiteral.fromJson(sweep.toJson()), isA<SweepGradientLiteral>());
    });

    test('TextStyle / StrutStyle / TextHeightBehavior', () {
      final t = TextStyleLiteral(
        color: const ValueLiteral('#000000ff'),
        fontSize: const ValueLiteral(14),
        fontWeight: const ValueLiteral('w600'),
      );
      expect(TextStyleLiteral.fromJson(t.toJson()), equals(t));

      final s = StrutStyleLiteral(fontSize: const ValueLiteral(14));
      expect(StrutStyleLiteral.fromJson(s.toJson()), equals(s));

      final h = TextHeightBehaviorLiteral(
          applyHeightToFirstAscent: const ValueLiteral(true));
      expect(TextHeightBehaviorLiteral.fromJson(h.toJson()), equals(h));
    });

    test('TextScaler — both kinds', () {
      final linear = TextScalerLinearLiteral(scaleFactor: const ValueLiteral(1.5));
      expect(TextScalerLiteral.fromJson(linear.toJson()), equals(linear));

      const noScaling = TextScalerNoScalingLiteral();
      expect(TextScalerLiteral.fromJson(noScaling.toJson()), equals(noScaling));
    });

    test('Icon — all 3 sources', () {
      const m = IconMaterialLiteral(name: 'add');
      expect(IconLiteral.fromJson(m.toJson()), equals(m));

      const c = IconCupertinoLiteral(name: 'plus');
      expect(IconLiteral.fromJson(c.toJson()), equals(c));

      const cu = IconCustomLiteral(family: 'mix', codePoint: 0xe000);
      expect(IconLiteral.fromJson(cu.toJson()), equals(cu));
    });

    test('Image — all 3 sources, distinct from HostRef', () {
      const a = ImageAssetLiteral(path: 'assets/logo.png');
      expect(ImageLiteral.fromJson(a.toJson()), equals(a));

      const n = ImageNetworkLiteral(url: 'https://example/x.png');
      expect(ImageLiteral.fromJson(n.toJson()), equals(n));

      const h = ImageHostLiteral(id: 'banner.hero');
      expect(ImageLiteral.fromJson(h.toJson()), equals(h));

      // Confirm Image source: host is structurally distinct from HostRef.
      expect(h.toJson(), equals({'source': 'host', 'id': 'banner.hero'}));
      const ref = HostRef('clipper.x');
      expect(ref.toJson(), equals({'host': 'clipper.x'}));
    });
  });
}
