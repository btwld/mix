import 'package:flutter/material.dart' show kElevationToShadow;
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/src/properties/painting/elevation_shadows.dart';
import 'package:mix/src/properties/painting/shadow_mix.dart';

void main() {
  group('elevationToShadow', () {
    test('matches the Material elevation shadows', () {
      expect(elevationToShadow, equals(kElevationToShadow));
    });

    test('defines shadows for every ElevationShadow level', () {
      for (final level in ElevationShadow.values) {
        expect(
          elevationToShadow[level.elevation],
          isNotEmpty,
          reason: 'missing shadows for elevation ${level.elevation}',
        );
      }
    });
  });
}
