// ignore_for_file: avoid_print, avoid-unused-instances

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  // 1.
  Pressable(onPress: () => print('Pressed!'), child: StyledText('Press Me'));

  // 2.
  Pressable(
    onPress: () => print('Pressed'),
    onLongPress: () => print('Long pressed'),
    onFocusChange: (focused) => print('Focus: $focused'),
    autofocus: true,
    child: StyledText('Interactive Button'),
  );

  // 3.
  Pressable(
    enabled: false,
    onPress: () => print('This won\'t be called'),
    child: StyledText('Disabled Button'),
  );

  // 4.
  PressableBox(
    style: BoxStyler().color(Colors.blue).paddingAll(16).borderRounded(8),
    onPress: () => print('PressableBox pressed'),
    child: StyledText('Styled Button'),
  );
}
