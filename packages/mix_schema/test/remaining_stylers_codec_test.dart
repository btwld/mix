import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  test('registeredTypes includes all built-in styler branches', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();

    expect(contract.registeredTypes, [
      'box',
      'text',
      'flex',
      'stack',
      'icon',
      'image',
      'flex_box',
      'stack_box',
    ]);
  });

  test('minimal payloads decode for every remaining styler', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();

    expect(
      contract.decode<FlexStyler>({'type': 'flex'}),
      isA<MixSchemaDecodeSuccess>(),
    );
    expect(
      contract.decode<StackStyler>({'type': 'stack'}),
      isA<MixSchemaDecodeSuccess>(),
    );
    expect(
      contract.decode<IconStyler>({'type': 'icon'}),
      isA<MixSchemaDecodeSuccess>(),
    );
    expect(
      contract.decode<ImageStyler>({'type': 'image'}),
      isA<MixSchemaDecodeSuccess>(),
    );
    expect(
      contract.decode<FlexBoxStyler>({'type': 'flex_box'}),
      isA<MixSchemaDecodeSuccess>(),
    );
    expect(
      contract.decode<StackBoxStyler>({'type': 'stack_box'}),
      isA<MixSchemaDecodeSuccess>(),
    );
  });

  test('flex and stack encode representative layout fields', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();

    expect(
      _encode(
        contract,
        FlexStyler(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          clipBehavior: Clip.hardEdge,
        ),
      ),
      {
        'v': 1,
        'type': 'flex',
        'direction': 'horizontal',
        'mainAxisAlignment': 'spaceBetween',
        'crossAxisAlignment': 'center',
        'mainAxisSize': 'min',
        'clipBehavior': 'hardEdge',
        'spacing': 8.0,
      },
    );

    expect(
      _encode(
        contract,
        StackStyler(
          alignment: Alignment.center,
          fit: StackFit.expand,
          textDirection: TextDirection.ltr,
          clipBehavior: Clip.antiAlias,
        ),
      ),
      {
        'v': 1,
        'type': 'stack',
        'alignment': 'center',
        'fit': 'expand',
        'textDirection': 'ltr',
        'clipBehavior': 'antiAlias',
      },
    );
  });

  test('icon and image use value forms for identity fields', () {
    const icon = IconData(0xe88a, fontFamily: 'MaterialIcons');
    const image = NetworkImage('https://example.com/pixels.png');
    final contract = MixSchemaContractBuilder().builtIn().freeze();

    expect(
      _encode(
        contract,
        IconStyler(
          icon: icon,
          color: const Color(0xFF112233),
          size: 24,
          blendMode: BlendMode.srcIn,
        ),
      ),
      {
        'v': 1,
        'type': 'icon',
        'icon': {'codePoint': 0xe88a, 'fontFamily': 'MaterialIcons'},
        'color': '#112233',
        'size': 24.0,
        'blendMode': 'srcIn',
      },
    );

    expect(
      _encode(
        contract,
        ImageStyler(
          image: image as ImageProvider<Object>,
          width: 64,
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
      {
        'v': 1,
        'type': 'image',
        'image': {'url': 'https://example.com/pixels.png'},
        'width': 64.0,
        'fit': 'cover',
        'alignment': 'center',
      },
    );
  });

  test('icon and image resolver failures surface through the contract', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();

    for (final payload in [
      {'type': 'icon', 'icon': 'missing'},
      {'type': 'image', 'image': 'missing'},
    ]) {
      final result = contract.decode<Object>(payload);
      final errors = switch (result) {
        MixSchemaDecodeFailure<Object>(:final errors) => errors,
        MixSchemaDecodeSuccess<Object>() => fail('expected failure'),
      };

      expect(
        errors.map((error) => error.code),
        contains(MixSchemaErrorCode.unresolvedIdentityName),
      );
    }

    for (final payload in [
      {'type': 'icon', 'icon': 'bad id'},
      {'type': 'image', 'image': 'bad id'},
    ]) {
      final invalidGrammar = contract.validate(payload);
      final errors = switch (invalidGrammar) {
        MixSchemaValidationFailure(:final errors) => errors,
        MixSchemaValidationSuccess() => fail('expected failure'),
      };

      expect(
        errors.map((error) => error.code),
        contains(MixSchemaErrorCode.constraintViolation),
      );
    }
  });

  test('flex_box and stack_box encode combined fields', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();

    expect(
      _encode(
        contract,
        FlexBoxStyler(
          padding: EdgeInsetsMix.all(8),
          decoration: BoxDecorationMix(color: const Color(0xFF112233)),
          direction: Axis.vertical,
          spacing: 4,
          flexClipBehavior: Clip.hardEdge,
        ),
      ),
      {
        'v': 1,
        'type': 'flex_box',
        'padding': 8.0,
        'decoration': {'color': '#112233'},
        'direction': 'vertical',
        'flexClipBehavior': 'hardEdge',
        'spacing': 4.0,
      },
    );

    expect(
      _encode(
        contract,
        StackBoxStyler(
          margin: EdgeInsetsMix(top: 4),
          stackAlignment: Alignment.center,
          fit: StackFit.passthrough,
          stackClipBehavior: Clip.none,
        ),
      ),
      {
        'v': 1,
        'type': 'stack_box',
        'margin': {'top': 4.0},
        'stackAlignment': 'center',
        'fit': 'passthrough',
        'stackClipBehavior': 'none',
      },
    );
  });

  test('flex_box keeps box and flex clipBehavior wire fields distinct', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final payload = {
      'v': 1,
      'type': 'flex_box',
      'clipBehavior': 'hardEdge',
      'flexClipBehavior': 'antiAlias',
    };

    final decoded = switch (contract.decode<FlexBoxStyler>(payload)) {
      MixSchemaDecodeSuccess<FlexBoxStyler>(:final value) => value,
      MixSchemaDecodeFailure<FlexBoxStyler>(:final errors) => fail('$errors'),
    };

    expect(_encode(contract, decoded), payload);
  });

  test('stack_box keeps box and stack clipBehavior wire fields distinct', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final payload = {
      'v': 1,
      'type': 'stack_box',
      'clipBehavior': 'antiAlias',
      'stackClipBehavior': 'none',
    };

    final decoded = switch (contract.decode<StackBoxStyler>(payload)) {
      MixSchemaDecodeSuccess<StackBoxStyler>(:final value) => value,
      MixSchemaDecodeFailure<StackBoxStyler>(:final errors) => fail('$errors'),
    };

    expect(_encode(contract, decoded), payload);
  });

  test(
    'stack_box keeps box alignment and stackAlignment wire fields distinct',
    () {
      final contract = MixSchemaContractBuilder().builtIn().freeze();
      final payload = {
        'v': 1,
        'type': 'stack_box',
        'alignment': 'topLeft',
        'stackAlignment': 'center',
      };

      final decoded = switch (contract.decode<StackBoxStyler>(payload)) {
        MixSchemaDecodeSuccess<StackBoxStyler>(:final value) => value,
        MixSchemaDecodeFailure<StackBoxStyler>(:final errors) => fail(
          '$errors',
        ),
      };

      expect(_encode(contract, decoded), payload);
    },
  );

  test('remaining data-only styler fields round-trip', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final payloads = <JsonMap>[
      {
        'v': 1,
        'type': 'box',
        'foregroundDecoration': {'color': '#000000'},
      },
      {
        'v': 1,
        'type': 'icon',
        'shadows': [
          {
            'color': '#000000',
            'offset': {'x': 1.0, 'y': 2.0},
            'blurRadius': 3.0,
          },
        ],
      },
      {
        'v': 1,
        'type': 'image',
        'centerSlice': {'left': 1.0, 'top': 2.0, 'right': 3.0, 'bottom': 4.0},
      },
      {
        'v': 1,
        'type': 'text',
        'strutStyle': {
          'fontFamily': 'Inter',
          'fontFamilyFallback': ['Roboto', 'Arial'],
          'fontSize': 12.0,
          'fontWeight': 'w600',
          'fontStyle': 'italic',
          'height': 1.2,
          'leading': 0.1,
          'forceStrutHeight': true,
        },
        'textScaler': {'linear': 1.25},
        'textWidthBasis': 'longestLine',
        'locale': {
          'languageCode': 'en',
          'scriptCode': 'Latn',
          'countryCode': 'US',
        },
        'style': {
          'debugLabel': 'body',
          'fontFamilyFallback': ['Inter', 'Arial'],
          'fontFeatures': [
            {'feature': 'kern', 'value': 1},
          ],
          'fontVariations': [
            {'axis': 'wght', 'value': 600.0},
          ],
          'textBaseline': 'alphabetic',
        },
      },
    ];

    for (final payload in payloads) {
      final decoded = contract.decode<Object>(payload);
      final styler = switch (decoded) {
        MixSchemaDecodeSuccess<Object>(:final value) => value,
        MixSchemaDecodeFailure<Object>(:final errors) => fail('$errors'),
      };

      expect(_encode(contract, styler), payload);
    }
  });

  test('non-linear text scalers fail encode explicitly', () {
    final contract = MixSchemaContractBuilder().builtIn().freeze();
    final result = contract.encode(
      TextStyler(textScaler: const _NonLinearTextScaler()),
    );
    final errors = switch (result) {
      MixSchemaEncodeFailure(:final errors) => errors,
      MixSchemaEncodeSuccess() => fail('expected encode failure'),
    };

    expect(
      errors.map((error) => error.code),
      contains(MixSchemaErrorCode.unsupportedEncodeValue),
    );
  });

  test(
    'composite child styler metadata fails encode instead of being dropped',
    () {
      final contract = MixSchemaContractBuilder().builtIn().freeze();
      final cases = <Object>[
        FlexBoxStyler.create(
          box: Prop.mix(
            BoxStyler(
              variants: [
                VariantStyle(const NamedVariant('nested'), BoxStyler()),
              ],
            ),
          ),
        ),
        FlexBoxStyler.create(
          box: Prop.mix(
            BoxStyler(
              modifier: WidgetModifierConfig.modifiers([
                OpacityModifierMix(opacity: 0.5),
              ]),
            ),
          ),
        ),
        FlexBoxStyler.create(
          box: Prop.mix(
            BoxStyler(
              animation: CurveAnimationConfig.linear(
                const Duration(milliseconds: 100),
              ),
            ),
          ),
        ),
        FlexBoxStyler.create(
          flex: Prop.mix(
            FlexStyler(
              modifier: WidgetModifierConfig.modifiers([
                OpacityModifierMix(opacity: 0.5),
              ]),
            ),
          ),
        ),
        StackBoxStyler.create(
          stack: Prop.mix(
            StackStyler(
              animation: CurveAnimationConfig.linear(
                const Duration(milliseconds: 100),
              ),
            ),
          ),
        ),
      ];

      for (final styler in cases) {
        final result = contract.encode(styler);
        final errors = switch (result) {
          MixSchemaEncodeFailure(:final errors) => errors,
          MixSchemaEncodeSuccess() => fail(
            'expected encode failure for $styler',
          ),
        };

        expect(
          errors.map((error) => error.code),
          contains(MixSchemaErrorCode.unsupportedEncodeValue),
        );
      }
    },
  );
}

JsonMap _encode(MixSchemaContract contract, Object value) {
  return switch (contract.encode(value)) {
    MixSchemaEncodeSuccess(:final value) => value,
    MixSchemaEncodeFailure(:final errors) => throw TestFailure('$errors'),
  };
}

final class _NonLinearTextScaler extends TextScaler {
  const _NonLinearTextScaler();

  @override
  double scale(double fontSize) => fontSize * 1.2 + 1;

  @override
  // ignore: deprecated_member_use
  double get textScaleFactor => 1.2;
}
