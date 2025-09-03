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
    final boxStyle = BoxStyler()
        .height(200)
        .width(200)
        .paddingAll(8)
        .alignment(Alignment.bottomCenter)
        .borderRounded(10)
        .backgroundImageUrl(
          'https://images.pexels.com/photos/5472603/pexels-photo-5472603.jpeg',
          fit: BoxFit.cover,
        )
        .borderAll(
          color: Colors.white,
          width: 6,
          strokeAlign: BorderSide.strokeAlignOutside,
        )
        .color(Colors.blueGrey.shade50)
        .shadowColor(Colors.black.withValues(alpha: 0.35))
        .shadowBlurRadius(100);

    final columnBoxStyle = Style.flexbox()
        .paddingAll(8)
        .width(double.infinity)
        .color(Colors.black.withValues(alpha: 0.1))
        .mainAxisSize(MainAxisSize.min)
        .crossAxisAlignment(CrossAxisAlignment.start);

    final titleStyle = TextStyler()
        .color(Colors.white)
        .fontWeight(FontWeight.bold)
        .fontSize(16);

    final subtitleStyle = TextStyler().color(Colors.white70).fontSize(14);

    return Box(
      style: boxStyle,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: ColumnBox(
            style: columnBoxStyle,
            children: [titleStyle('Okinawa'), subtitleStyle('Japan')],
          ),
        ),
      ),
    );
  }
}
