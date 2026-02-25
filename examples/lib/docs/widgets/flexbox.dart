// ignore_for_file: avoid-unused-instances

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  // 1.
  FlexBox(
    style: FlexBoxStyler()
        .color(Colors.blue)
        .direction(.horizontal)
        .mainAxisAlignment(.spaceBetween),

    children: [
      Box(child: Text('Box 1')),
      Box(child: Text('Box 2')),
      Box(child: Text('Box 3')),
    ],
  );

  // 2.
  RowBox(
    style: FlexBoxStyler().color(Colors.blue).mainAxisAlignment(.spaceBetween),
    children: [
      //...
    ],
  );

  // 3.
  ColumnBox(
    style: FlexBoxStyler().color(Colors.blue).mainAxisAlignment(.spaceBetween),
    children: [
      //...
    ],
  );
}
