/// MixWidget builder for generating `StatelessWidget` wrappers.
///
/// Emits a `class <Name> extends StatelessWidget` whose constructor mirrors
/// the factory's parameters plus the styler's `call()` parameters, and whose
/// `build()` delegates to that styler's `call()`.
library;

import '../models/mix_widget_model.dart';

/// Builds the `StatelessWidget` wrapper for a `@MixWidget`-annotated factory.
class MixWidgetBuilder {
  final MixWidgetModel model;

  const MixWidgetBuilder(this.model);

  /// Emits the constructor: positional factory params first, then named
  /// (`{super.key, ...named factory, ...named call}`).
  void _writeConstructor(StringBuffer buffer) {
    final positional = model.allParams.where((p) => p.isPositional).toList();
    final named = model.allParams.where((p) => !p.isPositional).toList();

    buffer.write('  const ${model.widgetName}(');

    if (positional.isEmpty && named.isEmpty) {
      buffer.writeln('{super.key});');

      return;
    }

    for (final param in positional) {
      buffer.write(_constructorParam(param));
      buffer.write(', ');
    }

    buffer.write('{super.key');
    for (final param in named) {
      buffer.write(', ');
      buffer.write(_constructorParam(param));
    }
    buffer.writeln('});');
  }

  /// Emits one parameter inside the constructor's parameter list.
  /// `required` precedes the `this.<name>` for required named params.
  String _constructorParam(MixWidgetParam param) {
    final required = param.isRequired && !param.isPositional ? 'required ' : '';
    final defaultClause = param.defaultValueCode != null
        ? ' = ${param.defaultValueCode}'
        : '';

    return '${required}this.${param.name}$defaultClause';
  }

  /// Emits `final <type> <name>;` for each parameter.
  void _writeFields(StringBuffer buffer) {
    for (final param in model.allParams) {
      buffer.writeln('  final ${param.typeCode} ${param.name};');
      buffer.writeln();
    }
  }

  /// Emits the `build` method that delegates to the styler's `call()`.
  void _writeBuildMethod(StringBuffer buffer) {
    buffer.writeln('  @override');
    buffer.writeln('  Widget build(BuildContext context) {');

    final invocation = model.isFunctionFactory
        ? '${model.factoryReference}(${_factoryArgs()})'
        : model.factoryReference;

    final callArgs = _callArgs();
    if (callArgs.isEmpty) {
      buffer.writeln('    return $invocation.call();');
    } else {
      buffer.writeln('    return $invocation.call(');
      for (final arg in callArgs) {
        buffer.writeln('      $arg,');
      }
      buffer.writeln('    );');
    }

    buffer.writeln('  }');
  }

  /// Renders the comma-separated argument list passed to the factory function.
  /// Positionals are forwarded by reference; named by `name: name`.
  String _factoryArgs() {
    final positional = model.factoryParams
        .where((p) => p.isPositional)
        .map((p) => p.name);
    final named = model.factoryParams
        .where((p) => !p.isPositional)
        .map((p) => '${p.name}: ${p.name}');

    return [...positional, ...named].join(', ');
  }

  /// Renders the lines passed to `.call(...)`. `key: key` leads when the
  /// styler `call()` forwards keys.
  List<String> _callArgs() {
    return [
      if (model.stylerCallForwardsKey) 'key: key',
      for (final p in model.callParams.where((p) => p.isPositional)) p.name,
      for (final p in model.callParams.where((p) => !p.isPositional))
        '${p.name}: ${p.name}',
    ];
  }

  String build() {
    final buffer = StringBuffer();

    if (model.doc != null) {
      buffer.writeln(model.doc);
    }

    buffer.writeln('class ${model.widgetName} extends StatelessWidget {');

    _writeConstructor(buffer);
    buffer.writeln();

    _writeFields(buffer);

    _writeBuildMethod(buffer);

    buffer.writeln('}');

    return buffer.toString();
  }
}
