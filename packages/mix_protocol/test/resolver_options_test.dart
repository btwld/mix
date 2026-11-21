import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_protocol/mix_protocol.dart';

void main() {
  test(
    'built-in singleton decodes icon value forms without registry state',
    () {
      final result = mixProtocol.decodeStyle<IconStyler>({
        'v': 1,
        'type': 'icon',
        'icon': {
          'codePoint': 0xe88a,
          'fontFamily': 'MaterialIcons',
          'fontPackage': 'material',
          'fontFamilyFallback': ['MaterialSymbolsRounded', 'MaterialIcons'],
          'matchTextDirection': true,
        },
      });

      final styler = switch (result) {
        MixProtocolSuccess<IconStyler>(:final value) => value,
        MixProtocolFailure<IconStyler>(:final errors) => fail('$errors'),
      };
      final source = styler.$icon!.sources.single as ValueSource<IconData>;

      expect(source.value.codePoint, 0xe88a);
      expect(source.value.fontFamily, 'MaterialIcons');
      expect(source.value.fontPackage, 'material');
      expect(source.value.fontFamilyFallback, [
        'MaterialSymbolsRounded',
        'MaterialIcons',
      ]);
      expect(source.value.matchTextDirection, isTrue);
    },
  );

  test('built-in singleton decodes icon names with per-call resolver', () {
    const icon = IconData(0xe88a, fontFamily: 'MaterialIcons');

    final result = mixProtocol.decodeStyle<IconStyler>(
      {'v': 1, 'type': 'icon', 'icon': 'home'},
      options: MixProtocolDecodeOptions(
        resolveIcon: (name) {
          return name == 'home' ? icon : null;
        },
      ),
    );

    final styler = switch (result) {
      MixProtocolSuccess<IconStyler>(:final value) => value,
      MixProtocolFailure<IconStyler>(:final errors) => fail('$errors'),
    };
    final source = styler.$icon!.sources.single as ValueSource<IconData>;

    expect(source.value, icon);
  });

  test('built-in singleton encodes named icons with per-call options', () {
    const icon = IconData(0xe88a, fontFamily: 'MaterialIcons');

    final result = mixProtocol.encodeStyle(
      IconStyler(icon: icon),
      options: const MixProtocolEncodeOptions(iconNames: {'home': icon}),
    );

    final payload = switch (result) {
      MixProtocolSuccess<JsonMap>(:final value) => value,
      MixProtocolFailure<JsonMap>(:final errors) => fail('$errors'),
    };

    expect(payload, {'v': 1, 'type': 'icon', 'icon': 'home'});
  });

  test('built-in singleton encodes icon value forms without options', () {
    final result = mixProtocol.encodeStyle(
      IconStyler(
        icon: const IconData(
          0xe88a,
          fontFamily: 'MaterialIcons',
          fontFamilyFallback: ['MaterialSymbolsRounded'],
          matchTextDirection: true,
        ),
      ),
    );

    final payload = switch (result) {
      MixProtocolSuccess<JsonMap>(:final value) => value,
      MixProtocolFailure<JsonMap>(:final errors) => fail('$errors'),
    };

    expect(payload['icon'], {
      'codePoint': 0xe88a,
      'fontFamily': 'MaterialIcons',
      'fontFamilyFallback': ['MaterialSymbolsRounded'],
      'matchTextDirection': true,
    });
  });

  test(
    'built-in singleton decodes image value forms without registry state',
    () {
      final urlResult = mixProtocol.decodeStyle<ImageStyler>({
        'v': 1,
        'type': 'image',
        'image': {
          'url': 'https://example.com/avatar.png',
          'scale': 2,
          'webHtmlElementStrategy': 'prefer',
        },
      });
      final urlStyler = switch (urlResult) {
        MixProtocolSuccess<ImageStyler>(:final value) => value,
        MixProtocolFailure<ImageStyler>(:final errors) => fail('$errors'),
      };
      final urlSource =
          urlStyler.$image!.sources.single
              as ValueSource<ImageProvider<Object>>;

      final urlImage = urlSource.value as NetworkImage;

      expect(urlImage.url, 'https://example.com/avatar.png');
      expect(urlImage.scale, 2);
      expect(urlImage.webHtmlElementStrategy, WebHtmlElementStrategy.prefer);

      final assetResult = mixProtocol.decodeStyle<ImageStyler>({
        'v': 1,
        'type': 'image',
        'image': {'asset': 'assets/avatar.png', 'package': 'app'},
      });
      final assetStyler = switch (assetResult) {
        MixProtocolSuccess<ImageStyler>(:final value) => value,
        MixProtocolFailure<ImageStyler>(:final errors) => fail('$errors'),
      };
      final assetSource =
          assetStyler.$image!.sources.single
              as ValueSource<ImageProvider<Object>>;

      expect(assetSource.value, isA<AssetImage>());
    },
  );

  test('built-in singleton decodes image names with per-call resolver', () {
    const image = AssetImage('assets/avatar.png', package: 'app');

    final result = mixProtocol.decodeStyle<ImageStyler>(
      {'v': 1, 'type': 'image', 'image': 'avatar'},
      options: MixProtocolDecodeOptions(
        resolveImage: (name) {
          return name == 'avatar' ? image : null;
        },
      ),
    );

    final styler = switch (result) {
      MixProtocolSuccess<ImageStyler>(:final value) => value,
      MixProtocolFailure<ImageStyler>(:final errors) => fail('$errors'),
    };
    final source =
        styler.$image!.sources.single as ValueSource<ImageProvider<Object>>;

    expect(source.value, image);
  });

  test('built-in singleton encodes named images with per-call options', () {
    const image = AssetImage('assets/avatar.png', package: 'app');

    final result = mixProtocol.encodeStyle(
      ImageStyler(image: image),
      options: const MixProtocolEncodeOptions(imageNames: {'avatar': image}),
    );

    final payload = switch (result) {
      MixProtocolSuccess<JsonMap>(:final value) => value,
      MixProtocolFailure<JsonMap>(:final errors) => fail('$errors'),
    };

    expect(payload, {'v': 1, 'type': 'image', 'image': 'avatar'});
  });

  test(
    'built-in singleton encodes image value forms with supported fields',
    () {
      const image = NetworkImage(
        'https://example.com/avatar.png',
        scale: 2,
        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
      );

      final result = mixProtocol.encodeStyle(
        ImageStyler(image: image as ImageProvider<Object>),
      );
      final payload = switch (result) {
        MixProtocolSuccess<JsonMap>(:final value) => value,
        MixProtocolFailure<JsonMap>(:final errors) => fail('$errors'),
      };

      expect(payload['image'], {
        'url': 'https://example.com/avatar.png',
        'scale': 2.0,
        'webHtmlElementStrategy': 'prefer',
      });
    },
  );

  test('unresolved identity names use resolver-flavored diagnostics', () {
    final result = mixProtocol.decodeStyle<IconStyler>({
      'v': 1,
      'type': 'icon',
      'icon': 'missing',
    });

    final errors = switch (result) {
      MixProtocolFailure<IconStyler>(:final errors) => errors,
      MixProtocolSuccess<IconStyler>() => fail('expected failure'),
    };

    expect(errors.single.code, MixProtocolErrorCode.unresolvedIdentityName);
    expect(errors.single.path, '/icon');
  });

  test('identity names enforce the documented 1-96 character grammar', () {
    const icon = IconData(0xe88a, fontFamily: 'MaterialIcons');
    final validBoundary = 'a' * 96;

    final validResult = mixProtocol.decodeStyle<IconStyler>({
      'v': 1,
      'type': 'icon',
      'icon': validBoundary,
    }, options: MixProtocolDecodeOptions(resolveIcon: (_) => icon));
    final validEncode = mixProtocol.encodeStyle(
      IconStyler(icon: icon),
      options: MixProtocolEncodeOptions(iconNames: {validBoundary: icon}),
    );

    expect(validResult, isA<MixProtocolSuccess<IconStyler>>());
    expect(validEncode, isA<MixProtocolSuccess<JsonMap>>());

    for (final invalidName in ['', 'invalid.name', 'a' * 97]) {
      final decodeResult = mixProtocol.decodeStyle<IconStyler>({
        'v': 1,
        'type': 'icon',
        'icon': invalidName,
      }, options: MixProtocolDecodeOptions(resolveIcon: (_) => icon));
      final encodeResult = mixProtocol.encodeStyle(
        IconStyler(icon: icon),
        options: MixProtocolEncodeOptions(iconNames: {invalidName: icon}),
      );

      expect(
        decodeResult,
        isA<MixProtocolFailure<IconStyler>>(),
        reason: 'expected "$invalidName" to be rejected on decode',
      );
      expect(
        encodeResult,
        isA<MixProtocolFailure<JsonMap>>(),
        reason: 'expected "$invalidName" to be rejected on encode',
      );
    }
  });

  test('unsupported image providers fail encode with resolver diagnostics', () {
    final result = mixProtocol.encodeStyle(
      ImageStyler(image: MemoryImage(Uint8List.fromList([1]))),
    );

    final errors = switch (result) {
      MixProtocolFailure<JsonMap>(:final errors) => errors,
      MixProtocolSuccess<JsonMap>() => fail('expected failure'),
    };

    expect(errors.single.code, MixProtocolErrorCode.unresolvedIdentityValue);
    expect(errors.single.path, '/image');
  });

  test(
    'unmodeled image value state fails encode with resolver diagnostics',
    () {
      for (final image in <ImageProvider<Object>>[
        const NetworkImage(
              'https://example.com/avatar.png',
              headers: {'authorization': 'redacted'},
            )
            as ImageProvider<Object>,
        AssetImage('assets/avatar.png', bundle: _UnsupportedAssetBundle())
            as ImageProvider<Object>,
      ]) {
        final result = mixProtocol.encodeStyle(ImageStyler(image: image));
        final errors = switch (result) {
          MixProtocolFailure<JsonMap>(:final errors) => errors,
          MixProtocolSuccess<JsonMap>() => fail('expected failure'),
        };

        expect(
          errors.single.code,
          MixProtocolErrorCode.unresolvedIdentityValue,
        );
        expect(errors.single.path, '/image');
      }
    },
  );
}

final class _UnsupportedAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async => ByteData(0);
}
