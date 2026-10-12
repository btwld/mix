import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const pageColor = Color(0xFF07070B);
const inkColor = Color(0xFFF5F5F7);
const mutedColor = Color(0xFF8B8B93);
const trackColor = Color(0xFF27272F);
const hoverColor = Color(0xFF32323C);

/// Paste this file into DartPad to run the example.
void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark(useMaterial3: true),
    home: const Scaffold(
      backgroundColor: pageColor,
      body: SafeArea(
        child: Center(
          child: Padding(padding: .all(24), child: GlideSelect()),
        ),
      ),
    ),
  ),
);

/// Scales and fades the menu around its anchored top-left corner.
BoxStyler selectMenuStyle({required bool isOpen}) => BoxStyler()
    .width(176)
    .color(trackColor)
    .borderRadius(.circular(10))
    .padding(.all(4))
    .border(.color(const Color(0x22FFFFFF)).width(1))
    .wrap(.opacity(isOpen ? 1 : 0))
    .wrap(.scale(x: isOpen ? 1 : .95, y: isOpen ? 1 : .95, alignment: .topLeft))
    .animate(.easeOut(isOpen ? 180.ms : 120.ms));

final selectStack = StackBoxStyler().stackAlignment(.topLeft);

/// Slides the highlight to the hovered option.
BoxStyler selectHighlightStyle({required int hoveredIndex}) => BoxStyler()
    .height(30)
    .width(166)
    .color(hoverColor)
    .borderRadius(.circular(8))
    .translate(0, hoveredIndex * 31)
    .animate(.easeOut(220.ms));

final selectItems = FlexBoxStyler()
    .direction(.vertical)
    .spacing(1)
    .mainAxisSize(.min);

final selectItem = BoxStyler()
    .height(30)
    .padding(.horizontal(10))
    .alignment(.centerLeft);

final selectLabel = TextStyler().color(inkColor).fontSize(13).fontWeight(.w600);

final selectTrigger = BoxStyler()
    .width(128)
    .height(32)
    .padding(.horizontal(10))
    .borderRadius(.circular(8))
    .color(trackColor)
    .onHovered(.color(hoverColor))
    .onPressed(.scale(.97))
    .animate(.easeOut(160.ms));

final selectRow = FlexBoxStyler()
    .direction(.horizontal)
    .mainAxisAlignment(.spaceBetween)
    .crossAxisAlignment(.center);

/// Rotates the trigger's chevron while the menu is open.
BoxStyler selectChevronStyle({required bool isOpen}) => BoxStyler()
    .rotate(isOpen ? 3.141592653589793 : 0)
    .animate(.easeOut(200.ms));

final selectIcon = IconStyler().size(18).color(mutedColor);

/// Open the menu and hover its options to move the highlight before selecting.
class GlideSelect extends StatefulWidget {
  const GlideSelect({super.key});

  @override
  State<GlideSelect> createState() => _GlideSelectState();
}

class _GlideSelectState extends State<GlideSelect> {
  static const _items = ['Gemini', 'Claude', 'Grok'];
  final _overlay = OverlayPortalController();
  final _anchor = LayerLink();
  Timer? _closing;
  int _selected = 0;
  int _hover = 0;
  bool _open = false;

  @override
  void dispose() {
    _closing?.cancel();
    super.dispose();
  }

  void _close() {
    setState(() => _open = false);
    _closing?.cancel();
    _closing = Timer(120.ms, _overlay.hide);
  }

  void _toggle() {
    if (_open) return _close();
    _closing?.cancel();
    _hover = _selected;
    if (_overlay.isShowing) {
      setState(() => _open = true);
    } else {
      _overlay.show();
      // Mount the collapsed style first so Mix can interpolate its entrance.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _overlay.isShowing) setState(() => _open = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectMenu = selectMenuStyle(isOpen: _open);
    final selectHighlight = selectHighlightStyle(hoveredIndex: _hover);
    final selectChevron = selectChevronStyle(isOpen: _open);

    return TapRegion(
      groupId: _anchor,
      onTapOutside: (_) {
        if (_open) _close();
      },
      child: OverlayPortal(
        controller: _overlay,
        overlayChildBuilder: (context) => Positioned(
          width: 176,
          child: CompositedTransformFollower(
            link: _anchor,
            targetAnchor: .bottomLeft,
            followerAnchor: .topLeft,
            offset: const Offset(0, 6),
            showWhenUnlinked: false,
            child: TapRegion(
              groupId: _anchor,
              child: IgnorePointer(
                ignoring: !_open,
                child: ExcludeSemantics(
                  excluding: !_open,
                  child: selectMenu(
                    key: const Key('glide-menu'),
                    child: selectStack(
                      children: [
                        selectHighlight(key: const Key('glide-highlight')),
                        selectItems(
                          children: [
                            for (var i = 0; i < _items.length; i++)
                              MouseRegion(
                                onEnter: (_) => setState(() => _hover = i),
                                child: PressableBox(
                                  onPress: () {
                                    setState(() {
                                      _selected = i;
                                      _hover = i;
                                    });
                                    _close();
                                  },
                                  style: selectItem,
                                  child: selectLabel(_items[i]),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        child: TapRegion(
          groupId: _anchor,
          child: CompositedTransformTarget(
            link: _anchor,
            child: PressableBox(
              key: const Key('glide-select'),
              onPress: _toggle,
              style: selectTrigger,
              child: selectRow(
                children: [
                  selectLabel(_items[_selected]),
                  selectChevron(
                    child: selectIcon(icon: Icons.expand_more_rounded),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
