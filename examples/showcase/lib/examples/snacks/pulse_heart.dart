import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
const mutedColor = Color(0xFF8B8B93);
const trackColor = Color(0xFF27272F);
const likeColor = Color(0xFFFF4D6D);

/// Paste this file into DartPad to run the example.
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    home: const Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Center(
          child: Padding(padding: .all(24), child: PulseHeart()),
        ),
      ),
    ),
  ),
);

final heartButton = BoxStyler()
    .padding(.horizontal(14))
    .padding(.vertical(10))
    .shape(.stadium())
    .color(trackColor)
    .onPressed(.scale(0.94))
    .animate(.spring(220.ms, bounce: 0.08));

final heartRow = FlexBoxStyler()
    .direction(.horizontal)
    .spacing(8)
    .crossAxisAlignment(.center)
    .mainAxisSize(.min);

/// Replays a pulse for each activation, independently of the press spring.
BoxStyler heartPulseStyle({required Listenable trigger}) =>
    BoxStyler().keyframeAnimation(
      trigger: trigger,
      timeline: [
        KeyframeTrack<double>('scale', [
          .easeIn(0.72, 160.ms),
          .elasticOut(1.18, 280.ms),
          .easeOut(1, 140.ms),
        ], initial: 1),
      ],
      styleBuilder: (values, style) => style.scale(values.get<double>('scale')),
    );

/// Transitions the heart's color as the liked state changes.
IconStyler heartIconStyle({required bool isLiked}) => IconStyler()
    .size(22)
    .color(isLiked ? likeColor : mutedColor)
    .animate(.easeOut(160.ms));

final heartCount = TextStyler().color(inkColor).fontSize(14).fontWeight(.w600);

/// Tap to like or unlike; the press spring and heart pulse animate independently.
class PulseHeart extends StatefulWidget {
  const PulseHeart({super.key});

  @override
  State<PulseHeart> createState() => _PulseHeartState();
}

class _PulseHeartState extends State<PulseHeart> {
  final _trigger = ValueNotifier(0);
  bool _liked = false;
  int _count = 128;

  @override
  void dispose() {
    _trigger.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final heartPulse = heartPulseStyle(trigger: _trigger);
    final heartIcon = heartIconStyle(isLiked: _liked);

    return PressableBox(
      key: const Key('pulse-heart'),
      onPress: () {
        setState(() {
          _liked = !_liked;
          _count += _liked ? 1 : -1;
        });
        _trigger.value++;
      },
      style: heartButton,
      child: heartRow(
        children: [
          heartPulse(
            child: heartIcon(
              icon: _liked
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
            ),
          ),
          heartCount('$_count'),
        ],
      ),
    );
  }
}
