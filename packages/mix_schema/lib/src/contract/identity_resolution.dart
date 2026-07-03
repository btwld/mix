import 'package:flutter/widgets.dart';

/// Resolves a named icon identity during decode.
typedef MixSchemaIconResolver = IconData? Function(String name);

/// Resolves a named image identity during decode.
typedef MixSchemaImageResolver = ImageProvider<Object>? Function(String name);

final class MixSchemaIdentityContext {
  const MixSchemaIdentityContext({
    this.resolveIcon,
    this.resolveImage,
    this.iconNames = const {},
    this.imageNames = const {},
  });

  static const empty = MixSchemaIdentityContext();

  final MixSchemaIconResolver? resolveIcon;
  final MixSchemaImageResolver? resolveImage;
  final Map<String, IconData> iconNames;
  final Map<String, ImageProvider<Object>> imageNames;

  String? nameForIcon(IconData value) {
    for (final entry in iconNames.entries) {
      if (entry.value == value) return entry.key;
    }

    return null;
  }

  String? nameForImage(ImageProvider<Object> value) {
    for (final entry in imageNames.entries) {
      if (identical(entry.value, value) || entry.value == value) {
        return entry.key;
      }
    }

    return null;
  }
}

final class MixSchemaIdentityContextHolder {
  MixSchemaIdentityContext current = MixSchemaIdentityContext.empty;
}
