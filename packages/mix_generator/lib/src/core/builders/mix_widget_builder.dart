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
  final bool stylable;
  final String stylerTypeDisplay;

  const MixWidgetBuilder({
    required this.widgetName,
    required this.sourceKind,
    required this.sourceName,
    required this.sourceParams,
    required this.callParams,
    required this.stylable,
    required this.stylerTypeDisplay,
  });

  String build() {
    final merged = mergeMixWidgetParams(source: sourceParams, call: callParams);

    final fields = StringBuffer();
    for (final p in merged) {
      fields.writeln('  final ${p.typeDisplay} ${p.name};');
    }
    if (stylable) {
      fields.writeln('  final $stylerTypeDisplay? style;');
    }

    // Dart forbids mixing `[positional-optional]` with `{named}`, and the
    // wrapper always needs `{super.key}`. Only required-positional params can
    // stay positional on the widget ctor; positional-optional degrades to
    // named.
    final positional = <MixWidgetParam>[];
    final named = <MixWidgetParam>[];
    for (final p in merged) {
      if (p.isPositional && p.isRequired && p.defaultValueCode == null) {
        positional.add(p);
      } else {
        named.add(p);
      }
    }

    final ctorSegments = <String>[
      for (final p in positional) 'this.${p.name}',
    ];
    final namedBuffer = StringBuffer('super.key');
    for (final p in named) {
      namedBuffer.write(', ');
      if (p.isRequired) {
        namedBuffer.write('required this.${p.name}');
      } else if (p.defaultValueCode != null) {
        namedBuffer.write('this.${p.name} = ${p.defaultValueCode}');
      } else {
        namedBuffer.write('this.${p.name}');
      }
    }
    if (stylable) {
      namedBuffer.write(', this.style');
    }
    ctorSegments.add('{$namedBuffer}');
    final ctorParams = ctorSegments.join(', ');

    final invocation = _buildInvocation();

    return '''
class $widgetName extends StatelessWidget {
${fields.toString().trimRight()}

  const $widgetName($ctorParams);

  @override
  Widget build(BuildContext context) => $invocation;
}
''';
  }

  String _buildInvocation() {
    final head = switch (sourceKind) {
      MixWidgetSourceKind.variable => sourceName,
      MixWidgetSourceKind.function =>
        '$sourceName(${_renderArgs(sourceParams)})',
    };
    final maybeMerge = stylable ? '.merge(style)' : '';
    final callArgs = _renderArgs(callParams, skipKey: true);
    return '$head$maybeMerge($callArgs)';
  }

  String _renderArgs(List<MixWidgetParam> params, {bool skipKey = false}) {
    return params
        .where((p) => !skipKey || p.name != 'key')
        .map((p) => p.isPositional ? p.name : '${p.name}: ${p.name}')
        .join(', ');
  }
}
