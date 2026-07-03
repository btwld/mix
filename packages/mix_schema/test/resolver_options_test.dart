import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

void main() {
  test(
    'built-in singleton decodes icon value forms without registry state',
    () {
      final result = builtInMixSchemaContract.decode<IconStyler>({
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
        MixSchemaDecodeSuccess<IconStyler>(:final value) => value,
        MixSchemaDecodeFailure<IconStyler>(:final errors) => fail('$errors'),
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

    final result = builtInMixSchemaContract.decode<IconStyler>(
      {'type': 'icon', 'icon': 'home'},
      options: MixSchemaDecodeOptions(
        resolveIcon: (name) {
          return name == 'home' ? icon : null;
        },
      ),
    );

    final styler = switch (result) {
      MixSchemaDecodeSuccess<IconStyler>(:final value) => value,
      MixSchemaDecodeFailure<IconStyler>(:final errors) => fail('$errors'),
    };
    final source = styler.$icon!.sources.single as ValueSource<IconData>;

    expect(source.value, icon);
  });

  test('built-in singleton encodes named icons with per-call options', () {
    const icon = IconData(0xe88a, fontFamily: 'MaterialIcons');

    final result = builtInMixSchemaContract.encode(
      IconStyler(icon: icon),
      options: const MixSchemaEncodeOptions(iconNames: {'home': icon}),
    );

    final payload = switch (result) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
    };

    expect(payload, {'v': 1, 'type': 'icon', 'icon': 'home'});
  });

  test('built-in singleton encodes icon value forms without options', () {
    final result = builtInMixSchemaContract.encode(
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
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
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
      final urlResult = builtInMixSchemaContract.decode<ImageStyler>({
        'type': 'image',
        'image': {
          'url': 'https://example.com/avatar.png',
          'scale': 2,
          'webHtmlElementStrategy': 'prefer',
        },
      });
      final urlStyler = switch (urlResult) {
        MixSchemaDecodeSuccess<ImageStyler>(:final value) => value,
        MixSchemaDecodeFailure<ImageStyler>(:final errors) => fail('$errors'),
      };
      final urlSource =
          urlStyler.$image!.sources.single
              as ValueSource<ImageProvider<Object>>;

      final urlImage = urlSource.value as NetworkImage;

      expect(urlImage.url, 'https://example.com/avatar.png');
      expect(urlImage.scale, 2);
      expect(urlImage.webHtmlElementStrategy, WebHtmlElementStrategy.prefer);

      final assetResult = builtInMixSchemaContract.decode<ImageStyler>({
        'type': 'image',
        'image': {'asset': 'assets/avatar.png', 'package': 'app'},
      });
      final assetStyler = switch (assetResult) {
        MixSchemaDecodeSuccess<ImageStyler>(:final value) => value,
        MixSchemaDecodeFailure<ImageStyler>(:final errors) => fail('$errors'),
      };
      final assetSource =
          assetStyler.$image!.sources.single
              as ValueSource<ImageProvider<Object>>;

      expect(assetSource.value, isA<AssetImage>());
    },
  );

  test('built-in singleton decodes image names with per-call resolver', () {
    const image = AssetImage('assets/avatar.png', package: 'app');

    final result = builtInMixSchemaContract.decode<ImageStyler>(
      {'type': 'image', 'image': 'avatar'},
      options: MixSchemaDecodeOptions(
        resolveImage: (name) {
          return name == 'avatar' ? image : null;
        },
      ),
    );

    final styler = switch (result) {
      MixSchemaDecodeSuccess<ImageStyler>(:final value) => value,
      MixSchemaDecodeFailure<ImageStyler>(:final errors) => fail('$errors'),
    };
    final source =
        styler.$image!.sources.single as ValueSource<ImageProvider<Object>>;

    expect(source.value, image);
  });

  test('built-in singleton encodes named images with per-call options', () {
    const image = AssetImage('assets/avatar.png', package: 'app');

    final result = builtInMixSchemaContract.encode(
      ImageStyler(image: image),
      options: const MixSchemaEncodeOptions(imageNames: {'avatar': image}),
    );

    final payload = switch (result) {
      MixSchemaEncodeSuccess(:final value) => value,
      MixSchemaEncodeFailure(:final errors) => fail('$errors'),
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

      final result = builtInMixSchemaContract.encode(
        ImageStyler(image: image as ImageProvider<Object>),
      );
      final payload = switch (result) {
        MixSchemaEncodeSuccess(:final value) => value,
        MixSchemaEncodeFailure(:final errors) => fail('$errors'),
      };

      expect(payload['image'], {
        'url': 'https://example.com/avatar.png',
        'scale': 2.0,
        'webHtmlElementStrategy': 'prefer',
      });
    },
  );

  test('unresolved identity names use resolver-flavored diagnostics', () {
    final result = builtInMixSchemaContract.decode<IconStyler>({
      'type': 'icon',
      'icon': 'missing',
    });

    final errors = switch (result) {
      MixSchemaDecodeFailure<IconStyler>(:final errors) => errors,
      MixSchemaDecodeSuccess<IconStyler>() => fail('expected failure'),
    };

    expect(errors.single.code, MixSchemaErrorCode.unresolvedIdentityName);
    expect(errors.single.path, '/icon');
  });

  test('unsupported image providers fail encode with resolver diagnostics', () {
    final result = builtInMixSchemaContract.encode(
      ImageStyler(image: MemoryImage(Uint8List.fromList([1]))),
    );

    final errors = switch (result) {
      MixSchemaEncodeFailure(:final errors) => errors,
      MixSchemaEncodeSuccess() => fail('expected failure'),
    };

    expect(errors.single.code, MixSchemaErrorCode.unresolvedIdentityValue);
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
        final result = builtInMixSchemaContract.encode(
          ImageStyler(image: image),
        );
        final errors = switch (result) {
          MixSchemaEncodeFailure(:final errors) => errors,
          MixSchemaEncodeSuccess() => fail('expected failure'),
        };

        expect(errors.single.code, MixSchemaErrorCode.unresolvedIdentityValue);
        expect(errors.single.path, '/image');
      }
    },
  );
}

final class _UnsupportedAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async => ByteData(0);
}
