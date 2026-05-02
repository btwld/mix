import 'package:mix_schema/mix_schema.dart';
import 'package:test/test.dart';

void roundTrip(DirectiveNode node) {
  final encoded = node.toJson();
  final decoded = DirectiveNode.fromJson(encoded);
  expect(decoded, isNotNull);
  expect(decoded, equals(node), reason: 'round-trip failed for ${node.op}');
  expect(decoded!.toJson(), equals(encoded));
}

void main() {
  group('color directives', () {
    test('round-trip every op', () {
      roundTrip(const DirectiveOpacity(0.5));
      roundTrip(const DirectiveWithValues(alpha: 1, red: 0.5));
      roundTrip(const DirectiveAlpha(128));
      roundTrip(const DirectiveDarken(10));
      roundTrip(const DirectiveLighten(10));
      roundTrip(const DirectiveSaturate(5));
      roundTrip(const DirectiveDesaturate(5));
      roundTrip(const DirectiveTint(20));
      roundTrip(const DirectiveShade(20));
      roundTrip(const DirectiveBrighten(15));
      roundTrip(const DirectiveWithRed(200));
      roundTrip(const DirectiveWithGreen(150));
      roundTrip(const DirectiveWithBlue(100));
    });

    test('all carry the ColorDirective marker', () {
      expect(const DirectiveDarken(1), isA<ColorDirective>());
      expect(const DirectiveOpacity(0.5), isA<ColorDirective>());
      expect(const DirectiveWithValues(red: 1), isA<ColorDirective>());
    });
  });

  group('string directives', () {
    test('round-trip every op (no-arg)', () {
      roundTrip(const DirectiveCapitalize());
      roundTrip(const DirectiveUppercase());
      roundTrip(const DirectiveLowercase());
      roundTrip(const DirectiveTitleCase());
      roundTrip(const DirectiveSentenceCase());
    });

    test('all carry the StringDirective marker', () {
      expect(const DirectiveUppercase(), isA<StringDirective>());
    });
  });

  group('number directives', () {
    test('round-trip every op', () {
      roundTrip(const DirectiveMultiply(2));
      roundTrip(const DirectiveAdd(5));
      roundTrip(const DirectiveSubtract(3));
      roundTrip(const DirectiveDivide(4));
      roundTrip(const DirectiveClamp(min: 0, max: 100));
      roundTrip(const DirectiveAbs());
      roundTrip(const DirectiveRound());
      roundTrip(const DirectiveFloor());
      roundTrip(const DirectiveCeil());
    });

    test('all carry the NumberDirective marker', () {
      expect(const DirectiveMultiply(2), isA<NumberDirective>());
      expect(const DirectiveClamp(min: 0, max: 1), isA<NumberDirective>());
    });
  });

  test('unknown op returns null', () {
    expect(DirectiveNode.fromJson({'op': 'made_up_op'}), isNull);
    expect(DirectiveNode.fromJson({'op': 42}), isNull);
    expect(DirectiveNode.fromJson(<String, Object?>{}), isNull);
  });

  test('27 distinct discriminator strings — full catalog coverage', () {
    final ops = <String>{
      const DirectiveOpacity(0).op,
      const DirectiveWithValues().op,
      const DirectiveAlpha(0).op,
      const DirectiveDarken(0).op,
      const DirectiveLighten(0).op,
      const DirectiveSaturate(0).op,
      const DirectiveDesaturate(0).op,
      const DirectiveTint(0).op,
      const DirectiveShade(0).op,
      const DirectiveBrighten(0).op,
      const DirectiveWithRed(0).op,
      const DirectiveWithGreen(0).op,
      const DirectiveWithBlue(0).op,
      const DirectiveCapitalize().op,
      const DirectiveUppercase().op,
      const DirectiveLowercase().op,
      const DirectiveTitleCase().op,
      const DirectiveSentenceCase().op,
      const DirectiveMultiply(0).op,
      const DirectiveAdd(0).op,
      const DirectiveSubtract(0).op,
      const DirectiveDivide(1).op,
      const DirectiveClamp(min: 0, max: 0).op,
      const DirectiveAbs().op,
      const DirectiveRound().op,
      const DirectiveFloor().op,
      const DirectiveCeil().op,
    };
    expect(ops, hasLength(27));
  });
}
