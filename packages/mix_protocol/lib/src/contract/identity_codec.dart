import 'package:ack/ack.dart' hide JsonMap;
import 'package:flutter/widgets.dart';

import 'identity_resolution.dart';
import 'json_map.dart';
import '../errors/mix_protocol_error.dart';

CodecSchema<Object, IconData> iconDataIdentityCodec(
  MixProtocolIdentityContext Function() context,
) {
  return Ack.anyOf([
    Ack.string().matches(
      identityNamePattern,
      message:
          'Identity name must be 1-96 characters using letters, digits, "_" or "-".',
    ),
    Ack.object({
      'codePoint': Ack.integer().min(0),
      'fontFamily': Ack.string().optional(),
      'fontPackage': Ack.string().optional(),
      'fontFamilyFallback': Ack.list(Ack.string()).optional(),
      'matchTextDirection': Ack.boolean().optional(),
    }),
  ]).codec<IconData>(
    decode: (value) {
      if (value is String) {
        final resolved = context().resolveIcon?.call(value);
        if (resolved != null) return resolved;
        throw UnresolvedIdentityNameError('icon', value);
      }

      final data = value as JsonMap;
      // Wire values are decoded at runtime by design. Flutter marks these
      // arguments as constant-only so icon tree shaking can diagnose apps that
      // construct IconData dynamically.
      return IconData(
        // ignore: non_const_argument_for_const_parameter
        data['codePoint']! as int,
        // ignore: non_const_argument_for_const_parameter
        fontFamily: data['fontFamily'] as String?,
        // ignore: non_const_argument_for_const_parameter
        fontPackage: data['fontPackage'] as String?,
        fontFamilyFallback: (data['fontFamilyFallback'] as List?)
            ?.cast<String>(),
        matchTextDirection: data['matchTextDirection'] as bool? ?? false,
      );
    },
    encode: (value) {
      final name = context().nameForIcon(value);
      if (name != null) return name;

      return {
        'codePoint': value.codePoint,
        if (value.fontFamily != null) 'fontFamily': value.fontFamily,
        if (value.fontPackage != null) 'fontPackage': value.fontPackage,
        if (value.fontFamilyFallback != null)
          'fontFamilyFallback': value.fontFamilyFallback,
        if (value.matchTextDirection) 'matchTextDirection': true,
      };
    },
  );
}

CodecSchema<Object, ImageProvider<Object>> imageProviderIdentityCodec(
  MixProtocolIdentityContext Function() context,
) {
  return Ack.anyOf([
    Ack.string().matches(
      identityNamePattern,
      message:
          'Identity name must be 1-96 characters using letters, digits, "_" or "-".',
    ),
    Ack.anyOf([
      Ack.object({
        'url': Ack.string(),
        'scale': _numberAsDoubleCodec().optional(),
        'webHtmlElementStrategy': Ack.enumString(
          _webHtmlElementStrategyNames,
        ).optional(),
      }),
      Ack.object({'asset': Ack.string(), 'package': Ack.string().optional()}),
    ]),
  ]).codec<ImageProvider<Object>>(
    decode: (value) {
      if (value is String) {
        final resolved = context().resolveImage?.call(value);
        if (resolved != null) return resolved;
        throw UnresolvedIdentityNameError('image', value);
      }

      final data = value as JsonMap;
      final url = data['url'];
      if (url is String) {
        final webHtmlElementStrategy =
            data['webHtmlElementStrategy'] as String?;

        return NetworkImage(
          url,
          scale: data['scale'] as double? ?? 1.0,
          webHtmlElementStrategy: webHtmlElementStrategy == null
              ? WebHtmlElementStrategy.never
              : _decodeWebHtmlElementStrategy(webHtmlElementStrategy),
        );
      }

      return AssetImage(
        data['asset']! as String,
        package: data['package'] as String?,
      );
    },
    encode: (value) {
      final name = context().nameForImage(value);
      if (name != null) return name;

      return switch (value) {
        NetworkImage(
          :final url,
          :final scale,
          :final headers,
          :final webHtmlElementStrategy,
        ) =>
          _encodeNetworkImage(
            value,
            url: url,
            scale: scale,
            headers: headers,
            webHtmlElementStrategy: webHtmlElementStrategy,
          ),
        AssetImage(:final assetName, :final package, :final bundle) =>
          _encodeAssetImage(
            value,
            assetName: assetName,
            package: package,
            bundle: bundle,
          ),
        _ => throw UnresolvedIdentityValueError('image', value),
      };
    },
  );
}

CodecSchema<num, double> _numberAsDoubleCodec() {
  return Ack.number().codec<double>(
    decode: (value) => value.toDouble(),
    encode: (value) => value,
  );
}

final List<String> _webHtmlElementStrategyNames = [
  for (final value in WebHtmlElementStrategy.values) value.name,
];

WebHtmlElementStrategy _decodeWebHtmlElementStrategy(String value) {
  for (final strategy in WebHtmlElementStrategy.values) {
    if (strategy.name == value) return strategy;
  }

  throw UnresolvedIdentityValueError('image.webHtmlElementStrategy', value);
}

JsonMap _encodeNetworkImage(
  NetworkImage image, {
  required String url,
  required double scale,
  required Map<String, String>? headers,
  required WebHtmlElementStrategy webHtmlElementStrategy,
}) {
  if (headers != null) throw UnresolvedIdentityValueError('image', image);

  return {
    'url': url,
    if (scale != 1.0) 'scale': scale,
    if (webHtmlElementStrategy != WebHtmlElementStrategy.never)
      'webHtmlElementStrategy': webHtmlElementStrategy.name,
  };
}

JsonMap _encodeAssetImage(
  AssetImage image, {
  required String assetName,
  required String? package,
  required AssetBundle? bundle,
}) {
  if (bundle != null) throw UnresolvedIdentityValueError('image', image);

  return {'asset': assetName, 'package': ?package};
}
