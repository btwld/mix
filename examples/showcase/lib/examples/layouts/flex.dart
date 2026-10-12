import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const _ink = Color(0xFF0C1733);
const _muted = Color(0xFF62708E);
const _blue = Color(0xFF3468F5);
const _blueSoft = Color(0xFFE8F0FF);
const _stage = Color(0xFFF3F6FA);
const _card = Color(0xFFFFFFFF);
const _edge = Color(0xFFDCE4F0);

/// Direction and spacing stay on the styler. Briefs use a wider gap so the
/// extra line of copy does not collide with its neighbors.
FlexBoxStyler actionRow({required Axis direction, required bool briefs}) {
  final FlexBoxStyler style = FlexBoxStyler()
      .direction(direction)
      .spacing(briefs ? 16 : 8)
      .mainAxisAlignment(.start)
      .crossAxisAlignment(.center)
      .mainAxisSize(.min)
      .padding(.all(12))
      .color(_card)
      .borderRadius(.circular(12))
      .border(.color(_edge).width(1));
  return style;
}

BoxStyler actionChip({required bool briefs}) {
  final style = BoxStyler()
      .color(_blueSoft)
      .padding(.symmetric(horizontal: 10, vertical: 8))
      .borderRadius(.circular(10));
  return briefs ? style.width(120) : style;
}

FlexBoxStyler actionBody({required bool briefs}) => FlexBoxStyler()
    .direction(briefs ? .vertical : .horizontal)
    .spacing(briefs ? 6 : 8)
    .crossAxisAlignment(briefs ? .start : .center)
    .mainAxisSize(.min);

FlexBoxStyler actionCopy() => FlexBoxStyler()
    .direction(.vertical)
    .spacing(2)
    .crossAxisAlignment(.start)
    .mainAxisSize(.min);

TextStyler actionLabel() =>
    TextStyler().fontSize(14).fontWeight(FontWeight.w700).color(_ink);

TextStyler actionDetail() =>
    TextStyler().fontSize(12).fontWeight(FontWeight.w500).color(_muted);

IconStyler actionIcon() => IconStyler().size(18).color(_blue);

TextStyler flexCaption() =>
    TextStyler().fontSize(12).fontWeight(FontWeight.w600).color(_muted);

class _Picker<T> extends StatelessWidget {
  const _Picker({
    required this.label,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
  });

  final String label;
  final List<T> values;
  final T selected;
  final String Function(T value) labelOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: _muted,
          ),
        ),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final value in values)
              ChoiceChip(
                label: Text(labelOf(value)),
                selected: value == selected,
                showCheckmark: false,
                visualDensity: VisualDensity.compact,
                selectedColor: _blueSoft,
                onSelected: (selected) {
                  if (selected) onChanged(value);
                },
              ),
          ],
        ),
      ],
    );
  }
}

class _OfferedWidth extends StatelessWidget {
  const _OfferedWidth({
    required this.width,
    required this.child,
    this.panelKey,
  });

  final double width;
  final Widget child;
  final Key? panelKey;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = constraints.maxWidth;
        final viewportHeight = constraints.maxHeight;
        final scrollWidth = width > viewportWidth ? width : viewportWidth;
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: scrollWidth,
            height: viewportHeight,
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                key: panelKey,
                width: width,
                height: viewportHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ColoredBox(
                    color: _stage,
                    child: SingleChildScrollView(child: child),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(body: FlexExample()),
  ),
);

enum FlexDirectionChoice {
  row('Row'),
  column('Column');

  const FlexDirectionChoice(this.label);
  final String label;

  Axis get axis => this == row ? Axis.horizontal : Axis.vertical;
}

enum FlexContent {
  actions('Actions'),
  briefs('Briefs');

  const FlexContent(this.label);
  final String label;
}

class _Action {
  const _Action(this.icon, this.label, this.detail);
  final IconData icon;
  final String label;
  final String detail;
}

const _actions = [
  _Action(Icons.save_outlined, 'Save', 'Keep draft'),
  _Action(Icons.share_outlined, 'Share', 'Copy link'),
  _Action(Icons.archive_outlined, 'Archive', 'Move away'),
];

/// FlexBox in one direction. Switch the axis or replace icon actions with
/// two-line briefs; both changes come from the same styler.
class FlexExample extends StatefulWidget {
  const FlexExample({super.key});

  @override
  State<FlexExample> createState() => _FlexExampleState();
}

class _FlexExampleState extends State<FlexExample> {
  FlexDirectionChoice _direction = FlexDirectionChoice.row;
  FlexContent _content = FlexContent.actions;

  @override
  Widget build(BuildContext context) {
    final briefs = _content == FlexContent.briefs;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Picker<FlexDirectionChoice>(
          label: 'Direction',
          values: FlexDirectionChoice.values,
          selected: _direction,
          labelOf: (value) => value.label,
          onChanged: (value) => setState(() => _direction = value),
        ),
        const SizedBox(height: 8),
        _Picker<FlexContent>(
          label: 'Content',
          values: FlexContent.values,
          selected: _content,
          labelOf: (value) => value.label,
          onChanged: (value) => setState(() => _content = value),
        ),
        const SizedBox(height: 8),
        StyledText(briefs ? 'Spacing 16' : 'Spacing 8', style: flexCaption()),
        const SizedBox(height: 10),
        Expanded(
          child: _OfferedWidth(
            width: 420,
            panelKey: const Key('flex-layout'),
            child: FlexBox(
              style: actionRow(direction: _direction.axis, briefs: briefs),
              children: [
                for (var index = 0; index < _actions.length; index++)
                  Box(
                    key: Key('flex-child-$index'),
                    style: actionChip(briefs: briefs),
                    child: FlexBox(
                      style: actionBody(briefs: briefs),
                      children: [
                        StyledIcon(
                          icon: _actions[index].icon,
                          style: actionIcon(),
                        ),
                        FlexBox(
                          style: actionCopy(),
                          children: [
                            StyledText(
                              _actions[index].label,
                              style: actionLabel(),
                            ),
                            if (briefs)
                              StyledText(
                                _actions[index].detail,
                                style: actionDetail(),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
