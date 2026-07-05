import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  test('Phase 10 registeredTypes includes all built-in styler branches', () {
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

  test('Phase 10 minimal payloads decode for every remaining styler', () {
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

  test('Phase 10 flex and stack encode representative layout fields', () {
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
        'type': 'stack',
        'alignment': 'center',
        'fit': 'expand',
        'textDirection': 'ltr',
        'clipBehavior': 'antiAlias',
      },
    );
  });

  test('Phase 10 icon and image use scoped registries for identity fields', () {
    const icon = IconData(0xe88a, fontFamily: 'MaterialIcons');
    final image = MemoryImage(Uint8List.fromList([0, 1, 2, 3]));
    final builder = MixSchemaContractBuilder()
      ..registry.iconData('home', icon)
      ..registry.imageProvider('pixels', image);
    final contract = builder.builtIn().freeze();

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
        'type': 'icon',
        'icon': 'home',
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
        'type': 'image',
        'image': 'pixels',
        'width': 64.0,
        'fit': 'cover',
        'alignment': 'center',
      },
    );
  });

  test('Phase 10 flex_box and stack_box encode combined fields', () {
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
        'type': 'stack_box',
        'margin': {'top': 4.0},
        'stackAlignment': 'center',
        'fit': 'passthrough',
        'stackClipBehavior': 'none',
      },
    );
  });
}

JsonMap _encode(MixSchemaContract contract, Object value) {
  return switch (contract.encode(value)) {
    MixSchemaEncodeSuccess(:final value) => value,
    MixSchemaEncodeFailure(:final errors) => throw TestFailure('$errors'),
  };
}
