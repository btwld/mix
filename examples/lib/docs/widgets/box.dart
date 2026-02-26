// ignore_for_file: avoid-unused-instances

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  Box(
    style: BoxStyler.width(
      100,
    ).height(100).color(Colors.blue).borderRadius(.circular(8)),
    child: Text('Styled Box'),
  );
}
