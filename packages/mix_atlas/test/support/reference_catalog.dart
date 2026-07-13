import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_atlas/mix_atlas.dart';

final referenceCatalog = AtlasCatalog(
  id: 'mix-atlas-reference',
  label: 'Mix Atlas reference',
  themes: [
    AtlasTheme(
      'light',
      label: 'Light',
      background: const Color(0xFFF4F6FA),
      builder: (_, child) => child,
    ),
    AtlasTheme(
      'dark',
      label: 'Dark',
      brightness: Brightness.dark,
      background: const Color(0xFF151821),
      builder: (_, child) => child,
    ),
  ],
  atlases: [_buttonAtlas],
);

final _buttonAtlas = ComponentAtlas(
  id: 'button',
  label: 'Button',
  rowAxes: const [AtlasAxis('tone', 'Tone')],
  scenarios: const [
    ...AtlasScenarios.interactive,
    AtlasScenario('loading', label: 'Loading', props: {'loading': true}),
  ],
  rows: [
    AtlasRow(
      'primary',
      (context, cell) => _ReferenceButton(
        cell: cell,
        label: 'Primary',
        style: _buttonStyle(
          light: const Color(0xFF3157D5),
          dark: const Color(0xFF7895FF),
          hovered: const Color(0xFF2447BC),
          pressed: const Color(0xFF193695),
        ),
      ),
      values: const {'tone': AtlasAxisValue('primary', 'Primary')},
    ),
    AtlasRow(
      'accent',
      (context, cell) => _ReferenceButton(
        cell: cell,
        label: 'Accent',
        style: _buttonStyle(
          light: const Color(0xFFD64A21),
          dark: const Color(0xFFFF8A66),
          hovered: const Color(0xFFB93A17),
          pressed: const Color(0xFF8F2A10),
        ),
      ),
      values: const {'tone': AtlasAxisValue('accent', 'Accent')},
    ),
  ],
);

BoxStyler _buttonStyle({
  required Color light,
  required Color dark,
  required Color hovered,
  required Color pressed,
}) {
  return BoxStyler()
      .height(40)
      .width(112)
      .alignment(.center)
      .borderRounded(10)
      .color(light)
      .onDark(.color(dark))
      .onHovered(.color(hovered))
      .onPressed(.color(pressed))
      .onFocused(.color(hovered))
      .onDisabled(.color(const Color(0xFF8B909C)));
}

class _ReferenceButton extends StatelessWidget {
  const _ReferenceButton({
    required this.cell,
    required this.label,
    required this.style,
  });

  final AtlasCellContext cell;
  final String label;
  final BoxStyler style;

  @override
  Widget build(BuildContext context) {
    final loading = cell.propOr('loading', false);
    final enabled = !cell.disabled && !loading;
    final effectiveStyle = loading
        ? style.merge(
            BoxStyler()
                .color(const Color(0xFF656B78))
                .onDark(.color(const Color(0xFF656B78))),
          )
        : style;

    return Pressable(
      enabled: enabled,
      onPress: enabled ? () {} : null,
      child: Box(
        style: effectiveStyle,
        child: StyledText(
          loading ? 'Loading…' : label,
          style: TextStyler()
              .fontFamily('Roboto')
              .fontSize(13)
              .fontWeight(.w600)
              .color(Colors.white),
        ),
      ),
    );
  }
}
