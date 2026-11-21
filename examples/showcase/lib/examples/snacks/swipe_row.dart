import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const cardColor = Color(0xFF121218);
const inkColor = Color(0xFFF5F5F7);
const mutedColor = Color(0xFF8B8B93);
const dangerColor = Color(0xFFFF5C7A);

/// Paste this file into DartPad to run the example.
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    home: const Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Center(
          child: Padding(padding: .all(24), child: SwipeRow()),
        ),
      ),
    ),
  ),
);

final swipeStage = StackBoxStyler()
    .size(260, 56)
    .color(Colors.transparent)
    .stackAlignment(.center)
    .clipBehavior(.hardEdge);

/// Fades in the restore action after the row leaves.
BoxStyler swipeRestoreStyle({required bool isGone}) => BoxStyler()
    .padding(.all(12))
    .wrap(.opacity(isGone ? 1 : 0))
    .animate(.easeOut(200.ms));

final swipeRestoreLabel = TextStyler()
    .color(mutedColor)
    .fontSize(12)
    .fontWeight(.w500);

/// Moves and fades the removed row out of its clipped stage.
BoxStyler swipeDepartureStyle({required bool isGone}) => BoxStyler()
    .translate(isGone ? -260 : 0, 0)
    .wrap(.opacity(isGone ? 0 : 1))
    .animate(.easeOut(240.ms));

final swipeCard = StackBoxStyler()
    .borderRadius(.circular(16))
    .clipBehavior(.antiAlias)
    .color(cardColor);

/// Reveals the danger background only once a swipe starts.
BoxStyler swipeDeleteStyle({required double offset}) => BoxStyler()
    .color(offset < 0 ? dangerColor : cardColor)
    .padding(.horizontal(18))
    .alignment(.centerRight)
    .height(56);

final swipeDeleteLabel = TextStyler().fontWeight(.w700).color(inkColor);

/// Follows the pointer during a drag and springs to the release target.
BoxStyler swipeFrontStyle({required bool isDragging, required double offset}) =>
    BoxStyler()
        .color(cardColor)
        .height(56)
        .padding(.horizontal(16))
        .alignment(.centerLeft)
        .translate(offset, 0)
        .animate(isDragging ? .linear(1.ms) : .spring(320.ms, bounce: 0.18));

final swipeLabel = TextStyler().color(inkColor).fontSize(14).fontWeight(.w600);

/// Swipe left to reveal Delete, swipe farther to remove, then tap Restore.
class SwipeRow extends StatefulWidget {
  const SwipeRow({super.key});

  @override
  State<SwipeRow> createState() => _SwipeRowState();
}

class _SwipeRowState extends State<SwipeRow> {
  double _x = 0;
  bool _gone = false;
  bool _dragging = false;
  bool _canceled = false;

  @override
  Widget build(BuildContext context) {
    final swipeRestore = swipeRestoreStyle(isGone: _gone);
    final swipeDeparture = swipeDepartureStyle(isGone: _gone);
    final swipeDelete = swipeDeleteStyle(offset: _x);
    final swipeFront = swipeFrontStyle(isDragging: _dragging, offset: _x);

    return swipeStage(
      key: const Key('swipe-row'),
      children: [
        IgnorePointer(
          ignoring: !_gone,
          child: ExcludeSemantics(
            excluding: !_gone,
            child: PressableBox(
              onPress: () => setState(() {
                _gone = false;
                _x = 0;
              }),
              style: swipeRestore,
              child: swipeRestoreLabel('Restore row'),
            ),
          ),
        ),
        IgnorePointer(
          ignoring: _gone,
          child: ExcludeSemantics(
            excluding: _gone,
            child: swipeDeparture(
              child: SizedBox(
                width: 260,
                height: 56,
                child: swipeCard(
                  children: [
                    PressableBox(
                      onPress: () => setState(() => _gone = true),
                      style: swipeDelete,
                      child: swipeDeleteLabel('Delete'),
                    ),
                    Listener(
                      onPointerCancel: (_) => setState(() {
                        _canceled = true;
                        _dragging = false;
                        _x = 0;
                      }),
                      child: GestureDetector(
                        onHorizontalDragStart: (_) => setState(() {
                          _dragging = true;
                          _canceled = false;
                        }),
                        onHorizontalDragUpdate: (details) {
                          setState(
                            () =>
                                _x = (_x + details.delta.dx).clamp(-180.0, 0.0),
                          );
                        },
                        onHorizontalDragEnd: (_) {
                          if (_canceled) return;
                          setState(() {
                            _dragging = false;
                            if (_x < -120) {
                              _gone = true;
                            } else {
                              _x = _x < -56 ? -88 : 0;
                            }
                          });
                        },
                        onHorizontalDragCancel: () => setState(() {
                          _dragging = false;
                          _x = 0;
                        }),
                        child: swipeFront(child: swipeLabel('Inbox from Leo')),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
