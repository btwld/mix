// ignore_for_file: avoid-flexible-outside-flex

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

final scaffoldContainer = FlexBoxStyler.mainAxisSize(
  .max,
).crossAxisAlignment(.stretch).mainAxisAlignment(.start).color(Colors.white);

final appHeaderContainer = BoxStyler.height(80)
    .color(Colors.black)
    .paddingAll(16)
    .alignment(.center)
    .wrap(
      .new().defaultText(
        TextStyler.fontSize(20).fontWeight(.bold).color(Colors.white),
      ),
    );

final scaffoldBodyContainer = BoxStyler.color(
  Colors.grey.shade50,
).padding(.all(16));

class CustomScaffold extends StatelessWidget {
  final Widget? appBar;

  final Widget body;
  const CustomScaffold({super.key, this.appBar, required this.body});

  @override
  Widget build(BuildContext context) {
    return ColumnBox(
      style: scaffoldContainer,
      children: [
        ?appBar,
        Expanded(
          child: SizedBox(width: .infinity, child: body),
        ),
      ],
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Box(style: appHeaderContainer, child: Text(title));
  }
}
