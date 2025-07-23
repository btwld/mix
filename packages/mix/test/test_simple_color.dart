import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'helpers/testing_utils.dart';

void main() {
  test('Color preservation through Mix', () {
    // Create TextStyleMix with Colors.red
    final mix = TextStyleMix.only(color: Colors.red);
    
    print('Input type: ${Colors.red.runtimeType}');
    print('Prop type: ${mix.color?.runtimeType}');
    
    // Check if the Prop has the value
    if (mix.color != null && mix.color!.hasValue) {
      print('Prop value type: ${mix.color!.value.runtimeType}');
    }
    
    // Resolve it
    final context = MockBuildContext();
    final resolved = mix.resolve(context);
    
    print('\nResolved color type: ${resolved.color?.runtimeType}');
    print('Is MaterialColor? ${resolved.color is MaterialColor}');
    
    // Compare with direct TextStyle
    final directStyle = TextStyle(color: Colors.red);
    print('\nDirect TextStyle color type: ${directStyle.color?.runtimeType}');
    print('Direct is MaterialColor? ${directStyle.color is MaterialColor}');
  });
}
