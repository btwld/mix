import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../specs/markdown_alert_spec.dart';
import '../specs/markdown_alert_type.dart';
import '../specs/markdown_alert_type_spec.dart';
import 'markdown_blocks.dart';

class MarkdownAlert extends StatelessWidget {
  const MarkdownAlert({
    super.key,
    required this.type,
    required this.styleSpec,
    this.blockSpacing,
    required this.children,
  });

  final MarkdownAlertType type;
  final StyleSpec<MarkdownAlertSpec>? styleSpec;
  final double? blockSpacing;
  final List<Widget> children;

  StyleSpec<MarkdownAlertTypeSpec> _typeSpec(MarkdownAlertSpec spec) {
    final selected = switch (type) {
      MarkdownAlertType.note => spec.note,
      MarkdownAlertType.tip => spec.tip,
      MarkdownAlertType.important => spec.important,
      MarkdownAlertType.warning => spec.warning,
      MarkdownAlertType.caution => spec.caution,
    };

    return selected ?? const StyleSpec(spec: MarkdownAlertTypeSpec());
  }

  Widget _buildHeader(MarkdownAlertTypeSpec spec) {
    final header = spec.header ?? const StyleSpec(spec: FlexBoxSpec());
    final flex = header.spec.flex ?? const StyleSpec(spec: FlexSpec());

    return RowBox(
      styleSpec: flex.spec.mainAxisSize != null
          ? header
          : header.copyWith(
              spec: header.spec.copyWith(
                flex: flex.copyWith(
                  spec: flex.spec.copyWith(mainAxisSize: .min),
                ),
              ),
            ),
      children: [
        StyledIcon(
          icon: spec.icon?.spec.icon ?? type.defaultIcon,
          styleSpec: spec.icon,
        ),
        const FlexibleModifier().build(
          StyledText(spec.label ?? type.defaultLabel, styleSpec: spec.title),
        ),
      ],
    );
  }

  Widget _buildAlert(BuildContext context, MarkdownAlertTypeSpec spec) => Box(
    styleSpec: spec.container,
    child: MarkdownBlocks(
      spacing: blockSpacing,
      children: [_buildHeader(spec), ...children],
    ),
  );

  @override
  Widget build(BuildContext context) => StyleSpecBuilder<MarkdownAlertSpec>(
    builder: (context, spec) => StyleSpecBuilder<MarkdownAlertTypeSpec>(
      builder: _buildAlert,
      styleSpec: _typeSpec(spec),
    ),
    styleSpec: styleSpec ?? const StyleSpec(spec: MarkdownAlertSpec()),
  );
}
