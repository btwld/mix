import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:todo_list/style/components/checkbox.dart';
import 'package:todo_list/style/design_tokens.dart';
import 'package:todo_list/style/patterns/scale_effect.dart';

const _colors = ColorTokens();
const _textStyles = TextStyleTokens();

class CheckboxTileVariant {
  static const checked = Variant("checked");
  static const unchecked = Variant("unchecked");
}

class TodoCheckboxListTile extends StatelessWidget {
  final String text;
  final bool checked;
  final Function(bool) onChanged;

  const TodoCheckboxListTile({
    super.key,
    required this.text,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onPress: () => onChanged(!checked),
      child: HBox(
        style: Style(
          $flex.gap(32),
          $flex.mainAxisAlignment.spaceBetween(),
          scaleEffect(0.98),
        ).animate(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        ),
        children: [
          StyledText(
            text,
            style: Style(
              $text.style.ref(_textStyles.heading3),
              $text.style.color.ref(_colors.onSurface),
              CheckboxTileVariant.checked(
                $text.style.decoration.lineThrough(),
                $text.style.color.ref(_colors.onSurfaceVariant),
              ),
            )
                .applyVariant(
                  checked
                      ? CheckboxTileVariant.checked
                      : CheckboxTileVariant.unchecked,
                )
                .animate(duration: const Duration(milliseconds: 100)),
          ),
          TodoCheckbox(
            onChanged: onChanged,
            value: checked,
          )
        ],
      ),
    );
  }
}
