import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

const _ink = Color(0xFF0C1733);
const _muted = Color(0xFF62708E);
const _blueSoft = Color(0xFFE8F0FF);
const _stage = Color(0xFFF3F6FA);
const _card = Color(0xFFFFFFFF);
const _edge = Color(0xFFDCE4F0);

/// Spacing and run spacing are the Wrap. A narrower offered width starts
/// the next run sooner; longer phrases do the same at either width.
WrapBoxStyler tagCloud() {
  final WrapBoxStyler style = WrapBoxStyler()
      .padding(.all(12))
      .color(_card)
      .borderRadius(.circular(12))
      .border(.color(_edge).width(1))
      .spacing(8)
      .runSpacing(8)
      .wrapAlignment(.start)
      .crossAxisAlignment(.center);
  return style;
}

BoxStyler tagChip() => BoxStyler()
    .color(_blueSoft)
    .padding(.symmetric(horizontal: 10, vertical: 6))
    .borderRadius(.circular(999));

TextStyler tagLabel() =>
    TextStyler().fontSize(13).fontWeight(.w600).color(_ink);

TextStyler wrapCaption() =>
    TextStyler().fontSize(12).fontWeight(.w600).color(_muted);

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
    home: Scaffold(body: WrapExample()),
  ),
);

enum WrapWidth {
  narrow(220, 'Narrow'),
  wide(460, 'Wide');

  const WrapWidth(this.pixels, this.label);
  final double pixels;
  final String label;
}

enum WrapContent {
  tags('Tags'),
  phrases('Phrases');

  const WrapContent(this.label);
  final String label;
}

const _tags = ['Flutter', 'Mix', 'Tokens', 'Variants', 'Themes', 'Motion'];

const _phrases = [
  'Design tokens',
  'Context variants',
  'Implicit motion',
  'Responsive tracks',
  'Typed styles',
  'Fluent chaining',
];

/// WrapBox flows children onto new runs. Width and content both change
/// where those runs break.
class WrapExample extends StatefulWidget {
  const WrapExample({super.key});

  @override
  State<WrapExample> createState() => _WrapExampleState();
}

class _WrapExampleState extends State<WrapExample> {
  WrapWidth _width = WrapWidth.narrow;
  WrapContent _content = WrapContent.tags;

  @override
  Widget build(BuildContext context) {
    final labels = _content == WrapContent.phrases ? _phrases : _tags;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Picker<WrapWidth>(
          label: 'Width',
          values: WrapWidth.values,
          selected: _width,
          labelOf: (value) => value.label,
          onChanged: (value) => setState(() => _width = value),
        ),
        const SizedBox(height: 8),
        _Picker<WrapContent>(
          label: 'Content',
          values: WrapContent.values,
          selected: _content,
          labelOf: (value) => value.label,
          onChanged: (value) => setState(() => _content = value),
        ),
        const SizedBox(height: 8),
        StyledText('${_width.pixels.toInt()}px offered', style: wrapCaption()),
        const SizedBox(height: 10),
        Expanded(
          child: _OfferedWidth(
            width: _width.pixels,
            panelKey: const Key('wrap-layout'),
            child: WrapBox(
              style: tagCloud(),
              children: [
                for (var index = 0; index < labels.length; index++)
                  Box(
                    key: Key('wrap-child-$index'),
                    style: tagChip(),
                    child: StyledText(labels[index], style: tagLabel()),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
