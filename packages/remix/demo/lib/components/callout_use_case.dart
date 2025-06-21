import 'package:flutter/material.dart' as m;
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

final _key = GlobalKey();

@widgetbook.UseCase(
  name: 'Callout Component',
  type: RxCallout,
)
Widget buildCalloutUseCase(BuildContext context) {
  return KeyedSubtree(
    key: _key,
    child: Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: RxCallout(
            icon: m.Icons.info_outline,
            text: 'Lucas',
          ),
        ),
      ),
    ),
  );
}
