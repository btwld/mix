import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
const mutedColor = Color(0xFF8B8B93);
const trackColor = Color(0xFF27272F);

/// Paste this file into DartPad to run the example.
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    home: const Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Center(
          child: Padding(padding: .all(24), child: RubberSegment()),
        ),
      ),
    ),
  ),
);

final segmentTrack = BoxStyler()
    .color(trackColor)
    .borderRounded(10)
    .paddingAll(3)
    .width(252)
    .height(42);

final segmentStack = StackBoxStyler().stackAlignment(.centerLeft);

/// Springs the highlight's position independently of its shape.
BoxStyler segmentTravelStyle({required int index}) => BoxStyler()
    .width(80)
    .height(36)
    .translate(index * 82, 0)
    .animate(.spring(380.ms, bounce: 0.26));

/// Replays an area-preserving stretch on each selection change.
BoxStyler segmentStretchStyle({required Listenable trigger}) => BoxStyler()
    .size(80, 36)
    .color(inkColor)
    .borderRounded(8)
    .keyframeAnimation(
      trigger: trigger,
      timeline: [
        KeyframeTrack<double>('stretch', [
          .easeOut(1.16, 90.ms),
          .easeOut(.98, 170.ms),
          .easeOut(1, 120.ms),
        ], initial: 1),
      ],
      styleBuilder: (values, style) {
        final stretch = values.get<double>('stretch');
        return style.wrap(.scale(x: stretch, y: 1 / stretch));
      },
    );

final segmentRow = FlexBoxStyler()
    .direction(.horizontal)
    .mainAxisAlignment(.spaceBetween);

final segmentOption = BoxStyler().alignment(.center).height(36);

/// Transitions the selected label's contrast.
TextStyler segmentLabelStyle({required bool isSelected}) => TextStyler()
    .fontSize(13)
    .fontWeight(.w700)
    .color(isSelected ? pageColor : mutedColor)
    .animate(.easeOut(180.ms));

/// Choose a period; the highlight travels and stretches on separate layers.
class RubberSegment extends StatefulWidget {
  const RubberSegment({super.key});

  @override
  State<RubberSegment> createState() => _RubberSegmentState();
}

class _RubberSegmentState extends State<RubberSegment> {
  static const _labels = ['Day', 'Week', 'Month'];
  int _index = 1;
  final _stretch = ValueNotifier(0);

  @override
  void dispose() {
    _stretch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final segmentTravel = segmentTravelStyle(index: _index);
    final segmentStretch = segmentStretchStyle(trigger: _stretch);

    return segmentTrack(
      key: const Key('rubber-segment'),
      child: segmentStack(
        children: [
          segmentTravel(child: segmentStretch()),
          segmentRow(
            children: [
              for (var i = 0; i < _labels.length; i++)
                Expanded(
                  child: PressableBox(
                    onPress: () {
                      if (_index == i) return;
                      setState(() => _index = i);
                      _stretch.value++;
                    },
                    style: segmentOption,
                    child: segmentLabelStyle(isSelected: _index == i)(
                      _labels[i],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
