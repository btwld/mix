import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('TransformMixin', () {
    group('Transform convenience methods', () {
      test('rotate() creates correct rotation matrix', () {
        final attribute = BoxSpecAttribute().rotate(1.5);
        
        // Should have transform set
        expect(attribute.$transform, isNotNull);
        
        // Check the rotation matrix values
        final matrix = attribute.$transform!.value;
        final expectedMatrix = Matrix4.rotationZ(1.5);
        
        for (int i = 0; i < 16; i++) {
          expect(
            matrix.storage[i], 
            closeTo(expectedMatrix.storage[i], 0.0001),
            reason: 'Matrix element $i should match',
          );
        }
      });

      test('scale() creates correct scale matrix', () {
        final attribute = BoxSpecAttribute().scale(2.0);
        
        expect(attribute.$transform, isNotNull);
        
        final matrix = attribute.$transform!.value;
        final expectedMatrix = Matrix4.diagonal3Values(2.0, 2.0, 1.0);
        
        for (int i = 0; i < 16; i++) {
          expect(
            matrix.storage[i], 
            closeTo(expectedMatrix.storage[i], 0.0001),
            reason: 'Matrix element $i should match',
          );
        }
      });

      test('translate() creates correct translation matrix', () {
        final attribute = BoxSpecAttribute().translate(10.0, 20.0);
        
        expect(attribute.$transform, isNotNull);
        
        final matrix = attribute.$transform!.value;
        final expectedMatrix = Matrix4.translationValues(10.0, 20.0, 0.0);
        
        for (int i = 0; i < 16; i++) {
          expect(
            matrix.storage[i], 
            closeTo(expectedMatrix.storage[i], 0.0001),
            reason: 'Matrix element $i should match',
          );
        }
      });

      test('skew() creates correct skew matrix', () {
        final attribute = BoxSpecAttribute().skew(0.5, 0.3);
        
        expect(attribute.$transform, isNotNull);
        
        final matrix = attribute.$transform!.value;
        final expectedMatrix = Matrix4.identity();
        expectedMatrix.setEntry(0, 1, 0.5);
        expectedMatrix.setEntry(1, 0, 0.3);
        
        for (int i = 0; i < 16; i++) {
          expect(
            matrix.storage[i], 
            closeTo(expectedMatrix.storage[i], 0.0001),
            reason: 'Matrix element $i should match',
          );
        }
      });

      test('transformReset() creates identity matrix', () {
        final attribute = BoxSpecAttribute().transformReset();
        
        expect(attribute.$transform, isNotNull);
        
        final matrix = attribute.$transform!.value;
        final expectedMatrix = Matrix4.identity();
        
        for (int i = 0; i < 16; i++) {
          expect(
            matrix.storage[i], 
            closeTo(expectedMatrix.storage[i], 0.0001),
            reason: 'Matrix element $i should match',
          );
        }
      });
    });

    group('Method chaining', () {
      test('transform methods can be chained', () {
        final attribute = BoxSpecAttribute()
            .rotate(1.0)
            .scale(2.0)
            .translate(10.0, 20.0);
        
        // Should only have the last transform (translate) since each creates a new instance
        expect(attribute.$transform, isNotNull);
        
        final matrix = attribute.$transform!.value;
        final expectedMatrix = Matrix4.translationValues(10.0, 20.0, 0.0);
        
        for (int i = 0; i < 16; i++) {
          expect(
            matrix.storage[i], 
            closeTo(expectedMatrix.storage[i], 0.0001),
            reason: 'Matrix element $i should match',
          );
        }
      });

      test('transform methods return new instances', () {
        final original = BoxSpecAttribute();
        final rotated = original.rotate(1.0);
        final scaled = original.scale(2.0);
        
        // Should be different instances
        expect(identical(original, rotated), isFalse);
        expect(identical(original, scaled), isFalse);
        expect(identical(rotated, scaled), isFalse);
        
        // Original should remain unchanged
        expect(original.$transform, isNull);
        
        // New instances should have transforms
        expect(rotated.$transform, isNotNull);
        expect(scaled.$transform, isNotNull);
      });
    });

    group('Edge cases', () {
      test('zero rotation works correctly', () {
        final attribute = BoxSpecAttribute().rotate(0.0);
        
        expect(attribute.$transform, isNotNull);
        
        final matrix = attribute.$transform!.value;
        final expectedMatrix = Matrix4.rotationZ(0.0);
        
        for (int i = 0; i < 16; i++) {
          expect(
            matrix.storage[i], 
            closeTo(expectedMatrix.storage[i], 0.0001),
            reason: 'Matrix element $i should match',
          );
        }
      });

      test('scale of 1.0 works correctly', () {
        final attribute = BoxSpecAttribute().scale(1.0);
        
        expect(attribute.$transform, isNotNull);
        
        final matrix = attribute.$transform!.value;
        final expectedMatrix = Matrix4.diagonal3Values(1.0, 1.0, 1.0);
        
        for (int i = 0; i < 16; i++) {
          expect(
            matrix.storage[i], 
            closeTo(expectedMatrix.storage[i], 0.0001),
            reason: 'Matrix element $i should match',
          );
        }
      });

      test('zero translation works correctly', () {
        final attribute = BoxSpecAttribute().translate(0.0, 0.0);
        
        expect(attribute.$transform, isNotNull);
        
        final matrix = attribute.$transform!.value;
        final expectedMatrix = Matrix4.translationValues(0.0, 0.0, 0.0);
        
        for (int i = 0; i < 16; i++) {
          expect(
            matrix.storage[i], 
            closeTo(expectedMatrix.storage[i], 0.0001),
            reason: 'Matrix element $i should match',
          );
        }
      });

      test('zero skew works correctly', () {
        final attribute = BoxSpecAttribute().skew(0.0, 0.0);
        
        expect(attribute.$transform, isNotNull);
        
        final matrix = attribute.$transform!.value;
        final expectedMatrix = Matrix4.identity();
        expectedMatrix.setEntry(0, 1, 0.0);
        expectedMatrix.setEntry(1, 0, 0.0);
        
        for (int i = 0; i < 16; i++) {
          expect(
            matrix.storage[i], 
            closeTo(expectedMatrix.storage[i], 0.0001),
            reason: 'Matrix element $i should match',
          );
        }
      });
    });

    group('Integration with other properties', () {
      test('transform methods work with other BoxSpecAttribute methods', () {
        final attribute = BoxSpecAttribute()
            .color(Colors.red)
            .rotate(1.0)
            .padding(EdgeInsetsMix.all(10.0));
        
        // Should have all properties set
        expect(attribute.$decoration, isNotNull);
        expect(attribute.$transform, isNotNull);
        expect(attribute.$padding, isNotNull);
      });

      test('merge preserves transform', () {
        final first = BoxSpecAttribute().rotate(1.0);
        final second = BoxSpecAttribute().color(Colors.blue);
        
        final merged = first.merge(second);
        
        // Should have both transform and decoration
        expect(merged.$transform, isNotNull);
        expect(merged.$decoration, isNotNull);
      });

      test('later transform overrides earlier transform in merge', () {
        final first = BoxSpecAttribute().rotate(1.0);
        final second = BoxSpecAttribute().scale(2.0);
        
        final merged = first.merge(second);
        
        // Should have the scale transform (from second)
        expect(merged.$transform, isNotNull);
        
        final matrix = merged.$transform!.value;
        final expectedMatrix = Matrix4.diagonal3Values(2.0, 2.0, 1.0);
        
        for (int i = 0; i < 16; i++) {
          expect(
            matrix.storage[i], 
            closeTo(expectedMatrix.storage[i], 0.0001),
            reason: 'Matrix element $i should match scale matrix',
          );
        }
      });
    });
  });
}