import 'package:flutter/material.dart';

import '../parsers.dart';

/// Base abstract parser for Decoration types with shared functionality
abstract class BaseDecorationParser<T extends Decoration> extends Parser<T> {
  const BaseDecorationParser();

  /// Shared encoding logic for common decoration properties
  Map<String, Object?> encodeCommon(Decoration decoration) {
    final result = <String, dynamic>{};

    // Handle color property (available in BoxDecoration and ShapeDecoration)
    if (decoration is BoxDecoration && decoration.color != null) {
      result['color'] = MixParsers.encode(decoration.color);
    }
    if (decoration is ShapeDecoration && decoration.color != null) {
      result['color'] = MixParsers.encode(decoration.color);
    }

    // Handle shadows (available in both BoxDecoration and ShapeDecoration)
    List<BoxShadow>? shadows;
    if (decoration is BoxDecoration && decoration.boxShadow != null) {
      shadows = decoration.boxShadow;
    }
    if (decoration is ShapeDecoration && decoration.shadows != null) {
      shadows = decoration.shadows;
    }

    if (shadows != null) {
      result['shadows'] = shadows.map(MixParsers.encode).toList();
    }

    // Handle gradient (available in both BoxDecoration and ShapeDecoration)
    Gradient? gradient;
    if (decoration is BoxDecoration && decoration.gradient != null) {
      gradient = decoration.gradient;
    }
    if (decoration is ShapeDecoration && decoration.gradient != null) {
      gradient = decoration.gradient;
    }

    if (gradient != null) {
      result['gradient'] = MixParsers.encode(gradient);
    }

    // Handle image (available in both BoxDecoration and ShapeDecoration)
    DecorationImage? image;
    if (decoration is BoxDecoration && decoration.image != null) {
      image = decoration.image;
    }
    if (decoration is ShapeDecoration && decoration.image != null) {
      image = decoration.image;
    }

    if (image != null) {
      result['image'] = MixParsers.encode(image);
    }

    return result;
  }

  /// Decode color from map with fallback
  Color? decodeColor(Map<String, Object?> map) =>
      MixParsers.decode(map['color']);

  /// Decode shadows from map with fallback
  List<BoxShadow>? decodeShadows(Map<String, Object?> map) {
    final shadowList = map['shadows'] as List?;
    if (shadowList == null) return null;

    return shadowList
        .map((s) => MixParsers.decode<BoxShadow>(s))
        .whereType<BoxShadow>()
        .toList();
  }

  /// Decode gradient from map with fallback
  Gradient? decodeGradient(Map<String, Object?> map) =>
      MixParsers.decode(map['gradient']);

  /// Decode decoration image from map with fallback
  DecorationImage? decodeImage(Map<String, Object?> map) =>
      MixParsers.decode(map['image']);
}
