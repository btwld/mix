import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
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
          child: Padding(padding: .all(24), child: FolderFloat()),
        ),
      ),
    ),
  ),
);

final folderStack = StackBoxStyler().stackAlignment(.bottomCenter);

final folderTab = BoxStyler()
    .size(28, 12)
    .borderRadius(.circular(4))
    .color(warningColor)
    .translate(-20, -50);

/// Fades notes separately from their spring-driven movement.
BoxStyler folderFadeStyle({required bool isOpen}) =>
    BoxStyler().wrap(.opacity(isOpen ? 1 : 0)).animate(.easeOut(180.ms));

/// Spreads each note around the folder while preserving its own rotation.
BoxStyler folderNoteStyle({required bool isOpen, required int index}) =>
    BoxStyler()
        .size(68, 34)
        .alignment(.center)
        .borderRadius(.circular(10))
        .color(inkColor)
        .translate(
          (index - 1) * (isOpen ? 76.0 : 0.0),
          isOpen ? -78 + index * 2 : -18,
        )
        .rotate(isOpen ? (index - 1) * 0.08 : 0)
        .animate(.spring(380.ms, bounce: 0.22));

final folderLabel = TextStyler()
    .fontSize(12)
    .fontWeight(.w600)
    .color(pageColor);

/// Nudges the folder front as the notes unfold.
BoxStyler folderFrontStyle({required bool isOpen}) => BoxStyler()
    .size(72, 56)
    .borderRadius(
      .only(
        topLeft: const .circular(8),
        topRight: const .circular(18),
        bottomLeft: const .circular(12),
        bottomRight: const .circular(12),
      ),
    )
    .color(warningColor)
    .alignment(.center)
    .translate(0, isOpen ? 4 : 0)
    .animate(.spring(320.ms, bounce: 0.18));

/// Hover or click the folder to reveal three independently animated notes.
class FolderFloat extends StatefulWidget {
  const FolderFloat({super.key});

  @override
  State<FolderFloat> createState() => _FolderFloatState();
}

class _FolderFloatState extends State<FolderFloat> {
  bool _open = false;

  static const _notes = ['Brief', 'Tokens', 'Motion'];

  @override
  Widget build(BuildContext context) {
    final folderFade = folderFadeStyle(isOpen: _open);
    final folderFront = folderFrontStyle(isOpen: _open);

    return MouseRegion(
      key: const Key('folder-float'),
      onEnter: (_) => setState(() => _open = true),
      onExit: (_) => setState(() => _open = false),
      child: SizedBox(
        width: 240,
        height: 140,
        child: folderStack(
          children: [
            folderTab(),
            for (var i = 0; i < _notes.length; i++)
              ExcludeSemantics(
                excluding: !_open,
                child: folderFade(
                  child: folderNoteStyle(isOpen: _open, index: i)(
                    key: Key('folder-note-$i'),
                    child: folderLabel(_notes[i]),
                  ),
                ),
              ),
            PressableBox(
              onPress: () => setState(() => _open = !_open),
              style: folderFront,
              child: folderLabel('Files'),
            ),
          ],
        ),
      ),
    );
  }
}
