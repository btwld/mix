import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  group('TextStyler codec', () {
    test('encodes and decodes representative fields', () {
      final contract = MixSchemaContract.builtIn();
      final style = TextStyler(
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        maxLines: 2,
        softWrap: false,
        textDirection: TextDirection.rtl,
        textDirectives: const [TitleCaseStringDirective()],
        selectionColor: const Color(0xFF336699),
        semanticsLabel: 'headline',
        locale: const Locale('en', 'US'),
      );

      final encoded = contract.encode(style);

      expect(encoded.ok, isTrue);
      expect(encoded.value, {
        'type': 'text',
        'overflow': 'ellipsis',
        'textAlign': 'center',
        'maxLines': 2,
        'textDirection': 'rtl',
        'softWrap': false,
        'textTransform': 'titleCase',
        'selectionColor': '#336699FF',
        'semanticsLabel': 'headline',
        'locale': {'languageCode': 'en', 'countryCode': 'US'},
      });

      final decoded = contract.decode(encoded.value!);
      expect(decoded.ok, isTrue);
      expect(contract.encode(decoded.value!).value, encoded.value);
    });
  });

  group('ImageStyler codec', () {
    test('encodes and decodes representative fields with registered image', () {
      final image = MemoryImage(Uint8List.fromList([0, 0, 0, 0]));
      final images = RegistryBuilder<ImageProvider<Object>>.builtIn(
        scope: MixSchemaScope.imageProvider,
      )..register('hero', image);
      final contract = MixSchemaContract.builtIn(registries: [images.freeze()]);
      final style = ImageStyler(
        image: image,
        width: 320,
        height: 180,
        fit: BoxFit.cover,
        alignment: Alignment.topRight,
        repeat: ImageRepeat.repeatX,
        semanticLabel: 'Hero image',
        excludeFromSemantics: true,
        gaplessPlayback: true,
        isAntiAlias: true,
        matchTextDirection: true,
      );

      final encoded = contract.encode(style);

      expect(encoded.ok, isTrue);
      expect(encoded.value, {
        'type': 'image',
        'image': 'hero',
        'width': 320.0,
        'height': 180.0,
        'repeat': 'repeatX',
        'fit': 'cover',
        'alignment': {'x': 1.0, 'y': -1.0},
        'semanticLabel': 'Hero image',
        'excludeFromSemantics': true,
        'gaplessPlayback': true,
        'isAntiAlias': true,
        'matchTextDirection': true,
      });

      final decoded = contract.decode(encoded.value!);
      expect(decoded.ok, isTrue);
      expect(contract.encode(decoded.value!).value, encoded.value);
    });
  });

  group('IconStyler codec', () {
    test('encodes and decodes representative fields without icon data', () {
      final contract = MixSchemaContract.builtIn();
      final style = IconStyler(
        color: const Color(0xFF112233),
        size: 24,
        weight: 500,
        grade: 100,
        opticalSize: 32,
        textDirection: TextDirection.ltr,
        applyTextScaling: true,
        fill: 1,
        semanticsLabel: 'Add item',
        opacity: 0.75,
        blendMode: BlendMode.srcIn,
      );

      final encoded = contract.encode(style);

      expect(encoded.ok, isTrue);
      expect(encoded.value, {
        'type': 'icon',
        'color': '#112233FF',
        'size': 24.0,
        'weight': 500.0,
        'grade': 100.0,
        'opticalSize': 32.0,
        'textDirection': 'ltr',
        'applyTextScaling': true,
        'fill': 1.0,
        'semanticsLabel': 'Add item',
        'opacity': 0.75,
        'blendMode': 'srcIn',
      });

      final decoded = contract.decode(encoded.value!);
      expect(decoded.ok, isTrue);
      expect(contract.encode(decoded.value!).value, encoded.value);
    });

    test('encodes and decodes icon data through a registered id', () {
      const icon = IconData(0xe145, fontFamily: 'MaterialIcons');
      final icons = RegistryBuilder<IconData>.builtIn(
        scope: MixSchemaScope.iconData,
      )..register('add', icon);
      final contract = MixSchemaContract.builtIn(registries: [icons.freeze()]);
      final style = IconStyler(icon: icon);

      final encoded = contract.encode(style);

      expect(encoded.ok, isTrue);
      expect(encoded.value, {'type': 'icon', 'icon': 'add'});

      final decoded = contract.decode(encoded.value!);
      expect(decoded.ok, isTrue);
      expect(contract.encode(decoded.value!).value, encoded.value);
    });
  });
}
