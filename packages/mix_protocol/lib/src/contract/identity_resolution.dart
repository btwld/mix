import 'package:flutter/widgets.dart';

/// Wire grammar for caller-resolved icon and image identity names.
const identityNamePattern = r'^[A-Za-z0-9_-]{1,96}$';

final _identityNamePattern = RegExp(identityNamePattern);

/// Whether [value] is a valid caller-resolved identity name.
bool isValidIdentityName(String value) => _identityNamePattern.hasMatch(value);

/// Resolves a named icon identity during decode.
typedef MixProtocolIconResolver = IconData? Function(String name);

/// Resolves a named image identity during decode.
typedef MixProtocolImageResolver = ImageProvider<Object>? Function(String name);

final class MixProtocolIdentityContext {
  const MixProtocolIdentityContext({
    this.resolveIcon,
    this.resolveImage,
    this.iconNames = const {},
    this.imageNames = const {},
  });

  static const empty = MixProtocolIdentityContext();

  final MixProtocolIconResolver? resolveIcon;
  final MixProtocolImageResolver? resolveImage;
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

final class MixProtocolIdentityContextHolder {
  MixProtocolIdentityContext current = MixProtocolIdentityContext.empty;
}
