import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/theme/material_theme/material_tokens.dart';

/// _Mix_ corollary to Flutter _Checkbox_ widget
///
/// Default _Mix_ values:
/// ```
///      animated(),
///      rounded(5),
///      width(25),
///      height(25),
///      icon(
///        size: 18,
///        color: MaterialTokens.colorScheme.primary,
///      ),
///      border(
///        color: Colors.grey[300],
///        width: 2,
///      ),
///      active(
///        iconColor(MaterialTokens.colorScheme.primary),
///      ),
///      disabled(
///        border(color: Colors.grey.shade300),
///      ),
///      (hover | active)(
///        borderColor(MaterialTokens.colorScheme.primary),
///      )
/// ```
/// {@category Mixable Widgets}
class CheckboxX extends RemixableWidget {
  const CheckboxX({
    Key? key,
    required this.checked,
    required this.onChanged,
    Mix? mix,
  }) : super(mix, key: key);

  final bool checked;
  final ValueChanged<bool>? onChanged;

  @override
  Mix get baseMix {
    return Mix(
      animated(),
      rounded(5),
      width(25),
      height(25),
      icon(
        size: 18,
        color: MaterialTokens.colorScheme.primary,
      ),
      border(
        color: Colors.grey[300],
        width: 2,
      ),
      active(
        iconColor(MaterialTokens.colorScheme.primary),
      ),
      disabled(
        border(color: Colors.grey.shade300),
      ),
      (hover | active)(
        borderColor(MaterialTokens.colorScheme.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fn = onChanged;

    return Pressable(
      onPressed: fn == null ? null : () => fn(!checked),
      child: Box(
        mix: Mix.chooser(
          condition: checked,
          ifTrue: mix.withVariant(active),
          ifFalse: mix.withVariant(inactive),
        ),
        child: IconMix(
          Icons.check_rounded,
          mix: Mix(hide(!checked)),
        ),
      ),
    );
  }
}
