import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const mutedColor = Color(0xFF8B8B93);
const warningColor = Color(0xFFF5C542);

/// Paste this file into DartPad to run the example.
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    home: const Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Center(
          child: Padding(padding: .all(24), child: PeekRating()),
        ),
      ),
    ),
  ),
);

final ratingColumn = FlexBoxStyler()
    .direction(.vertical)
    .spacing(10)
    .crossAxisAlignment(.center)
    .mainAxisSize(.min);

final ratingRow = FlexBoxStyler()
    .direction(.horizontal)
    .spacing(4)
    .crossAxisAlignment(.center)
    .mainAxisSize(.min);

/// Lifts and scales active stars without replacing either transform.
BoxStyler ratingStarStyle({required bool isActive, required bool isHovered}) {
  final scale = isActive ? (isHovered ? 1.18 : 1.08) : 0.92;
  return BoxStyler()
      .paddingAll(4)
      .wrap(
        // Separate modifiers preserve both translation and scale.
        .translate(x: 0, y: isActive ? -4 : 0)
            .scale(scale, scale)
            .orderOfModifiers(const [TranslateModifier, ScaleModifier]),
      )
      .animate(.spring(260.ms, bounce: 0.28));
}

/// Transitions star color independently of its movement.
IconStyler ratingIconStyle({required bool isActive}) => IconStyler()
    .size(28)
    .color(isActive ? warningColor : mutedColor)
    .animate(.easeOut(160.ms));

final ratingCaption = TextStyler()
    .color(mutedColor)
    .fontSize(12)
    .fontWeight(.w500);

/// Hover to preview a rating, then click to commit it.
class PeekRating extends StatefulWidget {
  const PeekRating({super.key});

  @override
  State<PeekRating> createState() => _PeekRatingState();
}

class _PeekRatingState extends State<PeekRating> {
  int _value = 3;
  int? _peek;

  int get _shown => _peek ?? _value;

  void _commit(int next) => setState(() {
    _value = next;
    _peek = null;
  });

  @override
  Widget build(BuildContext context) {
    return ratingColumn(
      children: [
        ratingRow(
          key: const Key('peek-rating'),
          children: [
            for (var i = 1; i <= 5; i++)
              PressableBox(
                onPress: () => _commit(i),
                style: ratingStarStyle(
                  isActive: _shown >= i,
                  isHovered: _peek == i,
                ),
                child: MouseRegion(
                  onEnter: (_) => setState(() => _peek = i),
                  onExit: (_) => setState(() => _peek = null),
                  child: ratingIconStyle(isActive: _shown >= i)(
                    icon: _shown >= i
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                  ),
                ),
              ),
          ],
        ),
        ratingCaption(_peek == null ? '$_value / 5' : 'Peek $_peek'),
      ],
    );
  }
}
