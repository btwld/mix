import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  // 1.
  StyledImage(
    image: AssetImage('assets/image.jpg'),
    style:
        ImageStyler() //
            .width(152)
            .height(152)
            .fit(BoxFit.cover),
  );
}
