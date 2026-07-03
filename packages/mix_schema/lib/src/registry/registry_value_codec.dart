import 'package:ack/ack.dart' hide JsonMap;
import 'package:flutter/widgets.dart';

import '../contract/identity_resolution.dart';
import '../contract/json_map.dart';
import '../errors/mix_schema_error.dart';
import 'registry.dart';

CodecSchema<String, T> registryValueCodec<T extends Object>(
  FrozenRegistry Function() registry,
  MixSchemaScope scope,
) {
  return Ack.string()
      .matches(
        registryIdPattern,
        message:
            'Registry id must be 1-96 characters using letters, digits, "_" or "-".',
      )
      .codec<T>(
        decode: (id) => registry().lookup<T>(scope, id),
        encode: (value) => registry().idFor(scope, value),
      );
}

CodecSchema<Object, IconData> iconDataIdentityCodec(
  MixSchemaIdentityContext Function() context,
) {
  return Ack.anyOf([
    Ack.string().matches(
      registryIdPattern,
      message:
          'Identity name must be 1-96 characters using letters, digits, "_" or "-".',
    ),
    Ack.object({
      'codePoint': Ack.integer().min(0),
      'fontFamily': Ack.string().optional(),
      'fontPackage': Ack.string().optional(),
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
      return IconData(
        data['codePoint']! as int,
        fontFamily: data['fontFamily'] as String?,
        fontPackage: data['fontPackage'] as String?,
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
        if (value.matchTextDirection) 'matchTextDirection': true,
      };
    },
  );
}

CodecSchema<Object, ImageProvider<Object>> imageProviderIdentityCodec(
  MixSchemaIdentityContext Function() context,
) {
  return Ack.anyOf([
    Ack.string().matches(
      registryIdPattern,
      message:
          'Identity name must be 1-96 characters using letters, digits, "_" or "-".',
    ),
    Ack.anyOf([
      Ack.object({'url': Ack.string()}),
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
      if (url is String) return NetworkImage(url);

      return AssetImage(
        data['asset']! as String,
        package: data['package'] as String?,
      );
    },
    encode: (value) {
      final name = context().nameForImage(value);
      if (name != null) return name;

      return switch (value) {
        NetworkImage(:final url) => {'url': url},
        AssetImage(:final assetName, :final package) => {
          'asset': assetName,
          'package': ?package,
        },
        _ => throw UnresolvedIdentityValueError('image', value),
      };
    },
  );
}
