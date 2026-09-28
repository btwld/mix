import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const _ink = Color(0xFF0C1733);
const _muted = Color(0xFF62708E);
const _blueSoft = Color(0xFFE8F0FF);
const _stage = Color(0xFFF3F6FA);
const _card = Color(0xFFFFFFFF);
const _edge = Color(0xFFDCE4F0);

/// Local breakpoints follow the width control.
///
/// 640px keeps four columns, 420px selects two, and 240px selects one.
/// Narrower branches are listed last so they win when several match.
GridBoxStyler responsiveGrid() {
  final GridBoxStyler style = .equalColumns(4)
      .gap(12)
      .onConstraints(.maxWidth(520), .equalColumns(2).gap(10))
      .onConstraints(.maxWidth(300), .equalColumns(1).gap(8));
  return style;
}

BoxStyler gridCard({required bool emphasis}) => BoxStyler()
    .color(emphasis ? _blueSoft : _card)
    .padding(.all(12))
    .borderRadius(.circular(10))
    .border(.color(_edge).width(1));

FlexBoxStyler gridCopy() => FlexBoxStyler()
    .direction(.vertical)
    .spacing(4)
    .crossAxisAlignment(.start)
    .mainAxisSize(.min);

TextStyler gridHeadline({required bool detailed}) => TextStyler()
    .fontSize(detailed ? 14 : 20)
    .fontWeight(detailed ? FontWeight.w700 : FontWeight.w800)
    .color(_ink);

TextStyler gridSupport() =>
    TextStyler().fontSize(12).fontWeight(FontWeight.w600).color(_muted);

TextStyler gridCaption() =>
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
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 64,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _muted,
            ),
          ),
        ),
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
    );
  }
}

/// Shows [width] as the width offered to [child], scrolling either axis when
/// the surrounding preview is smaller than the layout.
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
    home: Scaffold(body: GridExample()),
  ),
);

enum GridWidth {
  compact(240, 'Compact'),
  medium(420, 'Medium'),
  wide(640, 'Wide');

  const GridWidth(this.pixels, this.label);
  final double pixels;
  final String label;
}

enum GridContent {
  metrics('Metrics'),
  notes('Notes');

  const GridContent(this.label);
  final String label;
}

class _GridCell {
  const _GridCell(this.headline, this.support);
  final String headline;
  final String support;
}

const _metrics = [
  _GridCell(r'$84.2k', 'Revenue'),
  _GridCell('1,429', 'Orders'),
  _GridCell('4.86%', 'Conversion'),
  _GridCell('8,702', 'Active users'),
];

const _notes = [
  _GridCell('Release', 'Ship the responsive grid.'),
  _GridCell(
    'Migration',
    'Move spacing into the styler and drop the extra rows.',
  ),
  _GridCell('Tokens', 'Blue accent, quiet borders.'),
  _GridCell(
    'Motion',
    'Keep this example still so the tracks stay easy to read.',
  ),
  _GridCell('Tracks', 'Fractional columns share the offered width.'),
  _GridCell('Rows', 'Implicit rows grow with the taller note.'),
];

/// Responsive GridBox. The width control offers a new parent width, and the
/// content control swaps short metrics for unequal notes.
class GridExample extends StatefulWidget {
  const GridExample({super.key});

  @override
  State<GridExample> createState() => _GridExampleState();
}

class _GridExampleState extends State<GridExample> {
  GridWidth? _chosenWidth;
  GridContent _content = GridContent.metrics;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final width =
          _chosenWidth ??
          (constraints.maxWidth < 500 ? GridWidth.compact : GridWidth.medium);
      final detailed = _content == GridContent.notes;
      final cells = detailed ? _notes : _metrics;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Picker<GridWidth>(
            label: 'Width',
            values: GridWidth.values,
            selected: width,
            labelOf: (value) => value.label,
            onChanged: (value) => setState(() => _chosenWidth = value),
          ),
          const SizedBox(height: 8),
          _Picker<GridContent>(
            label: 'Content',
            values: GridContent.values,
            selected: _content,
            labelOf: (value) => value.label,
            onChanged: (value) => setState(() => _content = value),
          ),
          const SizedBox(height: 8),
          StyledText('${width.pixels.toInt()}px offered', style: gridCaption()),
          const SizedBox(height: 10),
          Expanded(
            child: _OfferedWidth(
              width: width.pixels,
              panelKey: const Key('grid-layout'),
              child: GridBox(
                style: responsiveGrid(),
                children: [
                  for (var index = 0; index < cells.length; index++)
                    Box(
                      key: Key('grid-cell-$index'),
                      style: gridCard(emphasis: index == 0 && !detailed),
                      child: FlexBox(
                        style: gridCopy(),
                        children: [
                          StyledText(
                            cells[index].headline,
                            style: gridHeadline(detailed: detailed),
                          ),
                          StyledText(
                            cells[index].support,
                            style: gridSupport(),
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
    },
  );
}
