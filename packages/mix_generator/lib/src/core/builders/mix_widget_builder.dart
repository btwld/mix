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
    _writeConstructorDeclaration(buffer, model.widgetName, model.allParams);
  }

  /// Emits the constructors derived from the convention-matched enum values.
  void _writeVariantConstructors(StringBuffer buffer) {
    final variantParamName = model.variantParamName;
    if (variantParamName == null || model.variantConstructors.isEmpty) return;

    final constructorParams = model.allParams
        .where((param) => param.name != variantParamName)
        .toList();

    for (final variant in model.variantConstructors) {
      if (variant.doc != null) {
        _writeIndentedLines(buffer, variant.doc!);
      }
      if (variant.deprecationCode != null) {
        _writeIndentedLines(buffer, variant.deprecationCode!);
      }

      _writeConstructorDeclaration(
        buffer,
        '${model.widgetName}.${variant.name}',
        constructorParams,
        initializer: '$variantParamName = ${variant.valueCode}',
      );
      buffer.writeln();
    }
  }

  void _writeConstructorDeclaration(
    StringBuffer buffer,
    String constructorName,
    List<WidgetCallParam> constructorParams, {
    String? initializer,
  }) {
    final positional = constructorParams
        .where((param) => param.isPositional)
        .toList();
    final named = constructorParams
        .where((param) => !param.isPositional)
        .toList();

    buffer.write('  const $constructorName(');

    if (positional.isEmpty && named.isEmpty) {
      buffer.write('{super.key})');
    } else {
      for (final param in positional) {
        buffer.write(_constructorParam(param));
        buffer.write(', ');
      }

      buffer.write('{super.key');
      for (final param in named) {
        buffer.write(', ');
        buffer.write(_constructorParam(param));
      }
      buffer.write('})');
    }

    if (initializer != null) {
      buffer.write(' : $initializer');
    }
    buffer.writeln(';');
  }

  void _writeIndentedLines(StringBuffer buffer, String value) {
    for (final line in value.split('\n')) {
      buffer.writeln('  $line');
    }
  }

  /// Emits one parameter inside the constructor's parameter list.
  ///
  /// `required` precedes `this.<name>` for required named parameters.
  String _constructorParam(WidgetCallParam param) {
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
    buffer.writeln('  Widget build(BuildContext _) {');

    final invocation = model.isFunctionFactory
        ? '${model.factoryReference}(${_factoryArgs()})'
        : model.factoryReference;

    // Bind the target type here so the emitter takes it non-null: interpolating
    // a null reference would silently emit `null(...)` as the widget name.
    if (model.targetTypeReference case final targetTypeReference?) {
      _writeDirectTargetBuild(buffer, invocation, targetTypeReference);
      buffer.writeln('  }');

      return;
    }

    final callArgs = _callArgs();
    final callTarget = '$invocation.call${model.typeParameterInvocation}';

    if (callArgs.isEmpty) {
      buffer.writeln('    return $callTarget();');
    } else {
      buffer.writeln('    return $callTarget(');
      for (final arg in callArgs) {
        buffer.writeln('      $arg,');
      }
      buffer.writeln('    );');
    }

    buffer.writeln('  }');
  }

  void _writeDirectTargetBuild(
    StringBuffer buffer,
    String styleInvocation,
    String targetTypeReference,
  ) {
    final constructorName = model.targetConstructorName;
    final constructorSuffix = constructorName == null
        ? ''
        : '.$constructorName';
    final target =
        '$targetTypeReference${model.typeParameterInvocation}'
        '$constructorSuffix';
    final args = [
      for (final p in model.callParams.where((p) => p.isPositional)) p.name,
      if (model.stylerCallForwardsKey) 'key: key',
      'style: $styleInvocation',
      for (final p in model.callParams.where((p) => !p.isPositional))
        '${p.name}: ${p.name}',
    ];

    buffer.writeln('    return $target(');
    for (final arg in args) {
      buffer.writeln('      $arg,');
    }
    buffer.writeln('    );');
  }

  /// Renders the comma-separated argument list passed to the factory function.
  /// The unused build context is a wildcard, so fields named `context`
  /// remain accessible without redundant `this` qualifiers.
  String _factoryArgs() {
    final positional = model.factoryParams
        .where((p) => p.isPositional)
        .map((p) => p.name);
    final named = model.factoryParams
        .where((p) => !p.isPositional)
        .map((p) => '${p.name}: ${p.name}');

    return [...positional, ...named].join(', ');
  }

  /// Renders the lines passed to `.call(...)`.
  List<String> _callArgs() {
    return [
      for (final p in model.callParams.where((p) => p.isPositional)) p.name,
      if (model.stylerCallForwardsKey) 'key: key',
      for (final p in model.callParams.where((p) => !p.isPositional))
        '${p.name}: ${p.name}',
    ];
  }

  String build() {
    final buffer = StringBuffer();

    if (model.doc != null) {
      buffer.writeln(model.doc);
    }

    buffer.writeln(
      'class ${model.widgetName}${model.typeParameterDeclaration} '
      'extends StatelessWidget {',
    );

    _writeConstructor(buffer);
    buffer.writeln();

    _writeVariantConstructors(buffer);

    _writeFields(buffer);

    _writeBuildMethod(buffer);

    buffer.writeln('}');

    return buffer.toString();
  }
}
