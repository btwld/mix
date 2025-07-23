import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TextStyle color type behavior', () {
    // Test 1: Runtime TextStyle
    final style1 = TextStyle(color: Colors.red);
    print('Runtime TextStyle color type: ${style1.color.runtimeType}');
    print('Is MaterialColor? ${style1.color is MaterialColor}');
    
    // Test 2: Const TextStyle
    const style2 = TextStyle(color: Colors.red);
    print('\nConst TextStyle color type: ${style2.color.runtimeType}');
    print('Is MaterialColor? ${style2.color is MaterialColor}');
    
    // Test 3: Direct comparison
    print('\nColors.red type: ${Colors.red.runtimeType}');
    print('Are they equal? ${style1.color == Colors.red}');
    print('Are styles equal? ${style1 == style2}');
  });
}
