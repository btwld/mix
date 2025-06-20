import 'package:flutter/material.dart' hide Badge;
import 'package:remix/remix.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Badge Component',
  type: RxBadge,
)
Widget buildAvatarUseCase(BuildContext context) {
  return Scaffold(
    body: Center(
      child: RxBadge(
        label: context.knobs.string(
          label: 'Label',
          initialValue: 'New',
        ),
      ),
    ),
  );
}
