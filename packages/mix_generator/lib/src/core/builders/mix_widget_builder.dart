import '../models/mix_widget_param_model.dart';

enum MixWidgetSourceKind { variable, function }

/// Emits the full `class <Name> extends StatelessWidget { ... }` source for a
/// `@MixWidget` annotation. Purely string-driven; no analyzer types.
class MixWidgetBuilder {
  final String widgetName;
  final MixWidgetSourceKind sourceKind;
  final String sourceName;
  final List<MixWidgetParam> sourceParams;
  final List<MixWidgetParam> callParams;
  final bool callHasPositional;
  final bool stylable;
  final String stylerTypeDisplay;

  const MixWidgetBuilder({
    required this.widgetName,
    required this.sourceKind,
    required this.sourceName,
    required this.sourceParams,
    required this.callParams,
    required this.callHasPositional,
    required this.stylable,
    required this.stylerTypeDisplay,
  });

  String build() {
    final merged = mergeMixWidgetParams(
      source: sourceParams,
      call: callParams,
    );

    final fields = StringBuffer();
    for (final p in merged) {
      fields.writeln('  final ${p.typeDisplay} ${p.name};');
    }
    if (stylable) {
      fields.writeln('  final $stylerTypeDisplay? style;');
    }

    final ctorParams = StringBuffer('super.key');
    for (final p in merged) {
      ctorParams.write(', ');
      if (p.isRequired) {
        ctorParams.write('required this.${p.name}');
      } else if (p.defaultValueCode != null) {
        ctorParams.write('this.${p.name} = ${p.defaultValueCode}');
      } else {
        ctorParams.write('this.${p.name}');
      }
    }
    if (stylable) {
      ctorParams.write(', this.style');
    }

    final invocation = _buildInvocation();

    return '''
class $widgetName extends StatelessWidget {
${fields.toString().trimRight()}

  const $widgetName({$ctorParams});

  @override
  Widget build(BuildContext context) => $invocation;
}
''';
  }

  String _buildInvocation() {
    final head = switch (sourceKind) {
      MixWidgetSourceKind.variable => sourceName,
      MixWidgetSourceKind.function => '$sourceName(${_renderFnArgs()})',
    };
    final maybeMerge = stylable ? '.merge(style)' : '';
    final callArgs = _renderCallArgs();
    return '$head$maybeMerge($callArgs)';
  }

  String _renderFnArgs() {
    final positional = sourceParams.where((p) => p.isPositional).map((p) => p.name);
    final named =
        sourceParams.where((p) => !p.isPositional).map((p) => '${p.name}: ${p.name}');
    return [...positional, ...named].join(', ');
  }

  String _renderCallArgs() {
    if (callHasPositional) {
      return callParams.map((p) => p.name).join(', ');
    }
    return callParams
        .where((p) => p.name != 'key')
        .map((p) => '${p.name}: ${p.name}')
        .join(', ');
  }
}
