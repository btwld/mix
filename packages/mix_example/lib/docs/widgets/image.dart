// ignore_for_file: avoid-unused-instances

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  // 1.
  StyledImage(
    style:
        ImageStyler() //
            .width(152)
            .height(152)
            .fit(BoxFit.cover),
    image: AssetImage('assets/image.jpg'),
  );
}
