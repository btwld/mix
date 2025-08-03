import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

final scaffoldContainer = Style.flexbox(
    .flex(
      FlexMix.mainAxisSize(MainAxisSize.max)
      .crossAxisAlignment(CrossAxisAlignment.stretch)
      .mainAxisAlignment(MainAxisAlignment.start),
    )
    .box(
      BoxMix.color(Colors.white)
    )
);

final appHeaderContainer = Style.box(
    .height(80)
    .width(double.infinity)
    .color(Colors.blue.shade100)
    .padding(EdgeInsetsMix.all(16))
    .wrap(
      WidgetDecoratorConfig.defaultText(
        Style.text(
            .fontSize(20)
            .fontWeight(FontWeight.bold)
            .color(Colors.blue.shade800)
        ),
      ),
    )
);

final scaffoldBodyContainer = Style.box(
    .color(Colors.grey.shade50)
    .padding(EdgeInsetsMix.all(16))
    .width(double.infinity)
);

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    this.appBar,
    required this.body,
  });

  final Widget? appBar;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return VBox(
      style: scaffoldContainer,
      children: [
        if (appBar != null) appBar!,
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: body,
          ),
        ),
      ],
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Box(
      style: appHeaderContainer,
      child: Text(title),
    );
  }
}