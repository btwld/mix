import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('TextStyle equality with different color types', () {
    final style1 = TextStyle(color: Colors.red);
    final style2 = TextStyle(color: Color(Colors.red.value));
    
    print('style1.color type: ${style1.color.runtimeType}');
    print('style2.color type: ${style2.color.runtimeType}');
    print('Colors are value equal: ${style1.color!.value == style2.color!.value}');
    print('Colors are == equal: ${style1.color == style2.color}');
    print('TextStyles are equal: ${style1 == style2}');
  });
}
