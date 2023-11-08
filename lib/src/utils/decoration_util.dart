import 'package:flutter/material.dart';

import '../attributes/decoration_attribute.dart';
import '../helpers/extensions/values_ext.dart';

BoxDecorationAttribute backgroundColor(Color color) {
  return BoxDecorationAttribute(color: color.toAttribute());
}

const boxDecoration = BoxDecorationAttribute.new;
