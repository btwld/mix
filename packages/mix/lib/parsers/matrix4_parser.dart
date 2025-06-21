import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'base/parser_base.dart';

/// Parser for Matrix4 following KISS principle
class Matrix4Parser extends Parser<Matrix4> {
  static const instance = Matrix4Parser();

  const Matrix4Parser();

  Matrix4? _decodeFromMap(Map<String, Object?> map) {
    if (map.containsKey('matrix')) {
      final matrixData = map['matrix'] as List<Object?>?;
      if (matrixData != null && matrixData.length == 16) {
        return Matrix4.fromList(
          matrixData.map((e) => (e as num).toDouble()).toList(),
        );
      }
    }

    if (map.containsKey('translate')) {
      final translate = map['translate'] as List<Object?>?;
      if (translate != null && translate.length >= 2) {
        final x = (translate[0] as num).toDouble();
        final y = (translate[1] as num).toDouble();
        final z = translate.length > 2 ? (translate[2] as num).toDouble() : 0.0;

        return Matrix4.translationValues(x, y, z);
      }
    }

    if (map.containsKey('scale')) {
      final scale = map['scale'] as num?;
      if (scale != null) {
        final scaleValue = scale.toDouble();

        return Matrix4.diagonal3Values(scaleValue, scaleValue, 1.0);
      }
    }

    if (map.containsKey('rotateZ')) {
      final rotation = map['rotateZ'] as num?;
      if (rotation != null) {
        return Matrix4.rotationZ(rotation.toDouble());
      }
    }

    return null;
  }

  bool _isIdentity(Matrix4 matrix) {
    return matrix.isIdentity();
  }

  bool _isTranslation(Matrix4 matrix) {
    final translation = matrix.getTranslation();
    final testMatrix =
        Matrix4.translationValues(translation.x, translation.y, translation.z);

    return _matricesEqual(matrix, testMatrix);
  }

  bool _isScale(Matrix4 matrix) {
    final scale = matrix.getMaxScaleOnAxis();
    final testMatrix = Matrix4.diagonal3Values(scale, scale, 1.0);

    return _matricesEqual(matrix, testMatrix);
  }

  bool _isRotationZ(Matrix4 matrix) {
    try {
      final rotation = _getRotationZ(matrix);
      final testMatrix = Matrix4.rotationZ(rotation);

      return _matricesEqual(matrix, testMatrix);
    } catch (e) {
      return false;
    }
  }

  double _getRotationZ(Matrix4 matrix) {
    // Extract rotation from matrix - simplified approach
    // Get the rotation angle from the 2D rotation part of the matrix
    final m11 = matrix.entry(0, 0);
    final m12 = matrix.entry(0, 1);

    return math.atan2(m12, m11);
  }

  bool _matricesEqual(Matrix4 a, Matrix4 b, {double tolerance = 1e-10}) {
    for (int i = 0; i < 16; i++) {
      if ((a.storage[i] - b.storage[i]).abs() > tolerance) {
        return false;
      }
    }

    return true;
  }

  @override
  Object? encode(Matrix4? value) {
    if (value == null) return null;

    // Check for common transformations to use shortcuts
    if (_isIdentity(value)) {
      return 'identity';
    }

    if (_isTranslation(value)) {
      return {
        'translate': [
          value.getTranslation().x,
          value.getTranslation().y,
          value.getTranslation().z,
        ],
      };
    }

    if (_isScale(value)) {
      final scale = value.getMaxScaleOnAxis();

      return {'scale': scale};
    }

    if (_isRotationZ(value)) {
      final rotation = _getRotationZ(value);

      return {'rotateZ': rotation};
    }

    // Full matrix representation
    return {'matrix': value.storage.toList()};
  }

  @override
  Matrix4? decode(Object? json) {
    if (json == null) return null;

    return switch (json) {
      'identity' => Matrix4.identity(),
      Map<String, Object?> map => _decodeFromMap(map),
      List<Object?> list when list.length == 16 => Matrix4.fromList(
          list.map((e) => (e as num).toDouble()).toList(),
        ),
      _ => null,
    };
  }
}
