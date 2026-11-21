import 'package:flutter/material.dart';

class LabeledSlider extends StatelessWidget {
  const LabeledSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.divisions,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      value: value.toStringAsFixed(1),
      child: Row(
        children: [
          SizedBox(width: 108, child: Text(label)),
          Expanded(
            child: Slider(
              key: Key('slider-${label.toLowerCase().replaceAll(' ', '-')}'),
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              label: value.toStringAsFixed(1),
              onChanged: onChanged,
            ),
          ),
          SizedBox(width: 42, child: Text(value.toStringAsFixed(1))),
        ],
      ),
    );
  }
}

class LabeledSwitch extends StatelessWidget {
  const LabeledSwitch({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      key: Key('switch-${label.toLowerCase().replaceAll(' ', '-')}'),
      contentPadding: EdgeInsets.zero,
      dense: true,
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }
}

enum DemoPaletteArrangement {
  standard('Standard', [0, 1, 2, 3]),
  shifted('Shifted', [2, 3, 0, 1]),
  reversed('Reversed', [3, 2, 1, 0]);

  const DemoPaletteArrangement(this.label, this.indices);

  final String label;
  final List<int> indices;

  List<T> arrange<T>(List<T> values) => [
    for (final index in indices) values[index],
  ];
}

class PalettePicker extends StatelessWidget {
  const PalettePicker({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final DemoPaletteArrangement selected;
  final ValueChanged<DemoPaletteArrangement> onSelected;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<DemoPaletteArrangement>(
      segments: [
        for (final arrangement in DemoPaletteArrangement.values)
          ButtonSegment(value: arrangement, label: Text(arrangement.label)),
      ],
      selected: {selected},
      onSelectionChanged: (value) => onSelected(value.single),
    );
  }
}
