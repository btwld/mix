import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../mixer/mix_context.dart';
import '../mixer/mix_context_notifier.dart';
import '../mixer/mix_factory.dart';
import '../variants/variant.dart';

/// Mix Widget
abstract class MixableWidget extends StatelessWidget {
  /// Constructor
  const MixableWidget(
    Mix? mix, {
    Key? key,
    bool? inherit,
    List<Variant>? variants,
  })  : _mix = mix ?? Mix.constant,
        _variants = variants,
        _inherit = inherit ?? false,
        super(key: key);

  final Mix _mix;

  final List<Variant>? _variants;
  final bool _inherit;

  MixContext createMixContext(BuildContext context) {
    var combinedMix = _mix;

    if (_inherit) {
      /// Get ancestor context
      final inheritedMixContext = MixContextNotifier.of(context);

      if (inheritedMixContext != null) {
        final inheritedValues = inheritedMixContext.toValues();
        combinedMix = combinedMix.copyWith(values: inheritedValues);
      }
    }

    return MixContext.create(
      context: context,
      mix: combinedMix.selectVariants(_variants ?? []),
    );
  }

  @override
  Widget build(BuildContext context);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(
      DiagnosticsProperty<Mix>('mix', _mix, defaultValue: null),
    );
    properties.add(
      DiagnosticsProperty<List<Variant>>(
        'variants',
        _variants,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>('inherit', _inherit, defaultValue: true),
    );
  }
}

/// Mixer Widget
abstract class MixedWidget extends StatelessWidget {
  /// Constructor
  const MixedWidget(
    this.mixContext, {
    Key? key,
  }) : super(key: key);

  final MixContext mixContext;

  @override
  Widget build(BuildContext context);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);

    properties.add(
      DiagnosticsProperty<MixContext>(
        'mixContext',
        mixContext,
        defaultValue: null,
      ),
    );
  }
}
