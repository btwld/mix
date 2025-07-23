import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'helpers/testing_utils.dart';

void main() {
  test('Trace color type through utility', () {
    final utility = TextStyleUtility(MixProp<TextStyle>.new);
    
    // Test color.red()
    final attr = utility.color.red();
    print('utility.color.red() returns: $attr');
    print('attr.value: ${attr.value}');
    
    // Check the internal Mix
    if (attr.value is MixProp<TextStyle>) {
      final mixProp = attr.value as MixProp<TextStyle>;
      print('MixProp source: ${mixProp.source}');
      
      if (mixProp.source is MixPropValueSource<TextStyle>) {
        final valueSource = mixProp.source as MixPropValueSource<TextStyle>;
        final mix = valueSource.value;
        print('Mix type: ${mix.runtimeType}');
        
        if (mix is TextStyleMix) {
          print('TextStyleMix.color: ${mix.color}');
          if (mix.color \!= null && mix.color\!.hasValue) {
            print('Color value type: ${mix.color\!.value.runtimeType}');
            print('Is MaterialColor: ${mix.color\!.value is MaterialColor}');
          }
        }
      }
    }
  });
}
