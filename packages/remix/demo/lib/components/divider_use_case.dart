import 'package:flutter/material.dart';

import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Divider Component',
  type: RxDivider,
)
Widget buildDivider(BuildContext context) {
  return const Scaffold(
    body: Center(
      child: SizedBox(
        height: 100,
        width: 100,
        child: Center(
          child: RxDivider(),
        ),
      ),
    ),
  );
}
