import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
const mutedColor = Color(0xFF8B8B93);
const accentColor = Color(0xFF7C6AF7);

/// Paste this file into DartPad to run the example.
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    home: const Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Center(
          child: Padding(padding: .all(24), child: BranchedMenu()),
        ),
      ),
    ),
  ),
);

final branchSections = FlexBoxStyler()
    .direction(.vertical)
    .spacing(8)
    .crossAxisAlignment(.start)
    .mainAxisSize(.min);

final branchItems = FlexBoxStyler()
    .direction(.vertical)
    .spacing(4)
    .crossAxisAlignment(.start)
    .mainAxisSize(.min);

/// Emphasizes the expanded section.
TextStyler branchHeadingStyle({required bool isSelected}) => TextStyler()
    .fontSize(14)
    .fontWeight(.w600)
    .color(isSelected ? inkColor : mutedColor);

/// Animates the branch height without changing its children's layout.
BoxStyler branchFoldStyle({required bool isSelected}) => BoxStyler()
    // Leave room for the selected row's horizontal spring inside the clip.
    .padding(.right(8))
    .wrap(
      .align(
        alignment: .topLeft,
        widthFactor: 1,
        heightFactor: isSelected ? 1 : 0,
      ),
    )
    .animate(.easeOut(300.ms));

/// Offsets the selected item with a short spring.
BoxStyler branchItemStyle({required bool isSelected}) => BoxStyler()
    .padding(.horizontal(8))
    .border(.color(isSelected ? accentColor : Colors.transparent).width(1))
    .borderRadius(.circular(4))
    .translate(isSelected ? 6 : 0, 0)
    .animate(.spring(240.ms, bounce: 0.12));

/// Highlights the selected item's label.
TextStyler branchLabelStyle({required bool isSelected}) => TextStyler()
    .fontSize(12)
    .fontWeight(.w500)
    .color(isSelected ? accentColor : mutedColor);

/// Select a section to unfold its items, then select an accented row.
class BranchedMenu extends StatefulWidget {
  const BranchedMenu({super.key});

  @override
  State<BranchedMenu> createState() => _BranchedMenuState();
}

class _BranchedMenuState extends State<BranchedMenu> {
  int _section = 0;
  int _item = 0;

  static const _tree = [
    ('Design', ['Tokens', 'Type', 'Color']),
    ('Motion', ['Spring', 'Keyframes']),
  ];

  @override
  Widget build(BuildContext context) {
    return branchSections(
      key: const Key('branched-menu'),
      children: [
        for (var s = 0; s < _tree.length; s++)
          branchItems(
            children: [
              Pressable(
                onPress: () => setState(() {
                  _section = s;
                  _item = 0;
                }),
                child: branchHeadingStyle(isSelected: _section == s)(
                  _tree[s].$1,
                ),
              ),
              IgnorePointer(
                ignoring: _section != s,
                child: ExcludeFocus(
                  excluding: _section != s,
                  child: ExcludeSemantics(
                    excluding: _section != s,
                    child: ClipRect(
                      key: Key('branch-fold-$s'),
                      child: branchFoldStyle(isSelected: _section == s)(
                        child: branchItems(
                          children: [
                            for (var i = 0; i < _tree[s].$2.length; i++)
                              PressableBox(
                                onPress: () => setState(() => _item = i),
                                style: branchItemStyle(isSelected: _item == i),
                                child: branchLabelStyle(isSelected: _item == i)(
                                  _tree[s].$2[i],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
