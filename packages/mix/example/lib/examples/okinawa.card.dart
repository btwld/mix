import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(home: DemoApp());
  }
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: Center(child: OkinawaCard()),
    );
  }
}

class OkinawaCard extends StatelessWidget {
  const OkinawaCard({super.key});

  @override
  Widget build(BuildContext context) {
    final boxStyle = Style.box(
      BoxStyle()
          .height(200)
          .width(200)
          .borderRadius(BorderRadiusMix.circular(10))
          .border(
            BoxBorderMix.all(
              BorderSideMix.color(
                Colors.white,
              ).width(6).strokeAlign(BorderSide.strokeAlignOutside),
            ),
          )
          .clipBehavior(Clip.antiAlias)
          .color(Colors.blueGrey.shade50)
          .shadow(
            BoxShadowMix.color(
              Colors.black.withValues(alpha: 0.15),
            ).blurRadius(100).offset(const Offset(0, 0)),
          ),
    );

    final vBoxStyle = FlexBoxStyle()
        .container(
          ContainerSpecMix()
              .padding(EdgeInsetsMix.all(8))
              .width(double.infinity)
              .color(Colors.black.withValues(alpha: 0.1)),
        )
        .flex(
          FlexPropertiesMix()
              .mainAxisSize(MainAxisSize.min)
              .crossAxisAlignment(CrossAxisAlignment.start),
        );

    final zbox = StackBoxStyle()
        .stack(StackStyle().alignment(Alignment.bottomCenter))
        .box(
          BoxStyle()
              .transformAlignment(Alignment.center)
              .modifier(ModifierConfig.scale(1)),
        )
        .onHovered(
          StackBoxStyle().box(BoxStyle().modifier(ModifierConfig.scale(1.05))),
        );

    final titleStyle = Style.text(
      TextMix().color(Colors.white).fontWeight(FontWeight.bold).fontSize(16),
    );

    final subtitleStyle = Style.text(
      TextMix().color(Colors.white70).fontSize(14),
    );

    final imageStyle = Style.image(ImageStyle().fit(BoxFit.cover));

    return Box(
      style: boxStyle,
      child: ZBox(
        style: zbox,
        children: [
          Positioned.fill(
            child: StyledImage(
              image: const NetworkImage(
                'https://images.pexels.com/photos/5472603/pexels-photo-5472603.jpeg',
              ),
              style: imageStyle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: VBox(
                  style: vBoxStyle,
                  children: [
                    StyledText('Okinawa', style: titleStyle),
                    StyledText('Japan', style: subtitleStyle),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
