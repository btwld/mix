// ignore_for_file: avoid-unused-instances

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  // 1
  final boxStyle = BoxStyler().size(100, 100).color(Colors.blue);

  Box(style: boxStyle);

  // 2
  final flexStyle = FlexBoxStyler()
      .mainAxisAlignment(.spaceBetween)
      .color(Colors.blue)
      .direction(.vertical);

  FlexBox(
    style: flexStyle,
    children: [Text('Item 1'), Text('Item 2'), Text('Item 3')],
  );

  // 3
  final style = TextStyler().color(Colors.blue).fontSize(20);

  StyledText('Hello, World!', style: style);

  // 4
  final iconStyle = IconStyler().color(Colors.blue).size(30);

  StyledIcon(icon: Icons.ac_unit, style: iconStyle);

  // 5
  final imageStyle = ImageStyler().width(200).height(150);

  StyledImage(
    style: imageStyle,
    image: NetworkImage('https://example.com/image.png'),
  );

  // 6
  final pressableStyle = BoxStyler().color(Colors.blue).size(100, 100);

  PressableBox(
    style: pressableStyle,
    onPress: () => debugPrint('Pressed!'),
    child: Text('Tap me'),
  );
}
