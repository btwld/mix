import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
const trackColor = Color(0xFF27272F);
const accentColor = Color(0xFF7C6AF7);
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
          child: Padding(padding: .all(24), child: RefineFrame()),
        ),
      ),
    ),
  ),
);

final refineFrame = StackBoxStyler()
    .width(180)
    .height(112)
    .borderRadius(.circular(16))
    .clipBehavior(.antiAlias)
    .color(trackColor)
    .stackAlignment(.topLeft);

/// Resolves the preview's blur and scale as generation advances.
BoxStyler refineArtworkStyle({required int stage, required double blur}) =>
    BoxStyler()
        .width(180)
        .height(112)
        .linearGradient(
          colors: [accentColor, likeColor],
          begin: .topLeft,
          end: .bottomRight,
        )
        .scale(stage == 3 ? 1 : 1.06)
        .wrap(.blur(blur))
        .animate(.easeInOut(420.ms));

final refineInset = BoxStyler().padding(.all(8));

final refineBadge = BoxStyler()
    .padding(.horizontal(8))
    .padding(.vertical(4))
    .shape(.stadium())
    .color(pageColor.withValues(alpha: 0.8));

final refineLabel = TextStyler().color(inkColor).fontSize(11).fontWeight(.w600);

/// Tap through four stages to watch a blurred preview resolve into artwork.
class RefineFrame extends StatefulWidget {
  const RefineFrame({super.key});

  @override
  State<RefineFrame> createState() => _RefineFrameState();
}

class _RefineFrameState extends State<RefineFrame> {
  int _stage = 0;
  static const _labels = ['Queued', 'Generating', 'Refining', 'Complete'];

  @override
  Widget build(BuildContext context) {
    final blur = switch (_stage) {
      0 => 8.0,
      1 => 4.0,
      2 => 1.5,
      _ => 0.0,
    };
    final refineArtwork = refineArtworkStyle(stage: _stage, blur: blur);

    return Pressable(
      key: const Key('refine-frame'),
      onPress: () => setState(() => _stage = (_stage + 1) % 4),
      child: refineFrame(
        children: [
          refineArtwork(),
          refineInset(child: refineBadge(child: refineLabel(_labels[_stage]))),
        ],
      ),
    );
  }
}
