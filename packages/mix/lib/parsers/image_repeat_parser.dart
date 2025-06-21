import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for ImageRepeat enum following KISS principle
class ImageRepeatParser implements Parser<ImageRepeat> {
  static const instance = ImageRepeatParser();

  const ImageRepeatParser();

  @override
  Object? encode(ImageRepeat? value) {
    if (value == null) return null;

    return switch (value) {
      ImageRepeat.repeat => 'repeat',
      ImageRepeat.repeatX => 'repeatX',
      ImageRepeat.repeatY => 'repeatY',
      ImageRepeat.noRepeat => 'noRepeat',
    };
  }

  @override
  ImageRepeat? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      'repeat' => ImageRepeat.repeat,
      'repeatX' => ImageRepeat.repeatX,
      'repeatY' => ImageRepeat.repeatY,
      'noRepeat' => ImageRepeat.noRepeat,
      _ => null,
    };
  }
}
