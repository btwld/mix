import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix_atlas/mix_atlas.dart';

final exampleCatalog = AtlasCatalog(
  id: 'mix-atlas-example',
  themes: [
    AtlasTheme(
      'light',
      label: 'Light',
      background: const Color(0xfff4f6fa),
      builder: (_, child) => child,
    ),
    AtlasTheme(
      'dark',
      label: 'Dark',
      brightness: .dark,
      background: const Color(0xff151821),
      builder: (_, child) => child,
    ),
  ],
  atlases: [_buttonAtlas],
  label: 'Mix Atlas example',
);

final _buttonAtlas = ComponentAtlas(
  id: 'button',
  scenarios: const [
    ...AtlasScenarios.interactive,
    AtlasScenario('loading', label: 'Loading', props: {'loading': true}),
  ],
  rows: [
    AtlasRow(
      'primary',
      (context, cell) => _ExampleButton(
        cell: cell,
        label: 'Primary',
        style: _buttonStyle(
          light: const Color(0xff3157d5),
          dark: const Color(0xff7895ff),
          hovered: const Color(0xff2447bc),
          pressed: const Color(0xff193695),
        ),
      ),
      values: const {'tone': AtlasAxisValue('primary', 'Primary')},
    ),
    AtlasRow(
      'accent',
      (context, cell) => _ExampleButton(
        cell: cell,
        label: 'Accent',
        style: _buttonStyle(
          light: const Color(0xffd64a21),
          dark: const Color(0xffff8a66),
          hovered: const Color(0xffb93a17),
          pressed: const Color(0xff8f2a10),
        ),
      ),
      values: const {'tone': AtlasAxisValue('accent', 'Accent')},
    ),
  ],
  label: 'Button',
  rowAxes: const [AtlasAxis('tone', 'Tone')],
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
      .onDisabled(.color(const Color(0xff8b909c)));
}

class _ExampleButton extends StatelessWidget {
  const _ExampleButton({
    required this.cell,
    required this.label,
    required this.style,
  });

  final AtlasCellContext cell;
  final String label;
  final BoxStyler style;

  void _handlePress() => debugPrint('$label button pressed');

  @override
  Widget build(BuildContext context) {
    final loading = cell.propOr('loading', false);
    final enabled = !cell.disabled && !loading;
    final effectiveStyle = loading
        ? style.merge(
            BoxStyler()
                .color(const Color(0xff656b78))
                .onDark(.color(const Color(0xff656b78))),
          )
        : style;

    return Pressable(
      enabled: enabled,
      onPress: enabled ? _handlePress : null,
      child: Box(
        style: effectiveStyle,
        child: StyledText(
          loading ? 'Loading…' : label,
          style: TextStyler()
              .fontSize(13)
              .fontWeight(.w600)
              .color(Colors.white),
        ),
      ),
    );
  }
}
