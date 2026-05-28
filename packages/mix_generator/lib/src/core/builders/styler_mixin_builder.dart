/// Builder for generated `_$XStylerMixin` code.
///
/// Emits abstract getters, setters, base methods, `merge`, `resolve`,
/// `debugFillProperties`, and `props` members.
library;

import '../models/annotation_config.dart';
import '../helpers/field_emitter.dart';
import '../models/styler_field_model.dart';

/// Builds the `_$XStylerMixin` for a Styler class.
class StylerMixinBuilder {
  final String stylerName;
  final String specName;
  final List<StylerFieldModel> fields;
  final MixableStylerAnnotationConfig config;

  const StylerMixinBuilder({
    required this.stylerName,
    required this.specName,
    required this.fields,
    required this.config,
  });

  FieldEmitter<StylerFieldModel> _fieldEmitter() => .new(fields);

  String _buildAbstractGetters() {
    return _fieldEmitter().abstractGetters(
      typeCode: (field) => field.fieldTypeCode,
      getterName: (field) => field.declaredName,
    );
  }

  String _buildSetters() {
    final buffer = StringBuffer();

    for (final field in fields) {
      if (!field.generateSetter || field.setterName == null) continue;

      final setterName = field.setterName!;
      final paramType = field.effectivePublicParamType;

      buffer.writeln('  /// Sets the ${field.name}.');
      buffer.writeln('  $stylerName $setterName($paramType value) {');
      buffer.writeln('    return merge($stylerName($setterName: value));');
      buffer.writeln('  }');
      buffer.writeln();
    }

    return buffer.toString();
  }

  String _buildBaseMethods() {
    final buffer = StringBuffer();

    buffer.writeln('  /// Sets the animation configuration.');
    buffer.writeln('  $stylerName animate(AnimationConfig value) {');
    buffer.writeln('    return merge($stylerName(animation: value));');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  /// Sets the style variants.');
    buffer.writeln(
      '  $stylerName variants(List<VariantStyle<$specName>> value) {',
    );
    buffer.writeln('    return merge($stylerName(variants: value));');
    buffer.writeln('  }');
    buffer.writeln();

    buffer.writeln('  /// Wraps with a widget modifier.');
    buffer.writeln('  $stylerName wrap(WidgetModifierConfig value) {');
    buffer.writeln('    return merge($stylerName(modifier: value));');
    buffer.writeln('  }');
    buffer.writeln();

    return buffer.toString();
  }

  String _buildMerge() {
    final buffer = StringBuffer();

    buffer.writeln('  /// Merges with another [$stylerName].');
    buffer.writeln('  @override');
    buffer.writeln('  $stylerName merge($stylerName? other) {');
    buffer.writeln('    return $stylerName.create(');

    _fieldEmitter().linesInto(buffer, (field) {
      final fieldName = field.declaredName;
      final name = field.name;
      if (field.isRawList) {
        // Raw list fields need list-aware merging.
        return '      $name: MixOps.mergeList($fieldName, other?.$fieldName),';
      }

      return '      $name: MixOps.merge($fieldName, other?.$fieldName),';
    });

    // Base fields come from `Style<T>` rather than per-styler fields.
    buffer.writeln(
      '      variants: MixOps.mergeVariants(\$variants, other?.\$variants),',
    );
    buffer.writeln(
      '      modifier: MixOps.mergeModifier(\$modifier, other?.\$modifier),',
    );
    buffer.writeln(
      '      animation: MixOps.mergeAnimation(\$animation, other?.\$animation),',
    );

    buffer.writeln('    );');
    buffer.writeln('  }');

    return buffer.toString();
  }

  String _buildResolve() {
    final buffer = StringBuffer();

    buffer.writeln('  /// Resolves to [StyleSpec<$specName>] using [context].');
    buffer.writeln('  @override');
    buffer.writeln('  StyleSpec<$specName> resolve(BuildContext context) {');
    buffer.writeln('    final spec = $specName(');

    _fieldEmitter().linesInto(buffer, (field) {
      final fieldName = field.declaredName;
      final name = field.name;
      if (field.isRawList) {
        // Raw list fields are already concrete values.
        return '      $name: $fieldName,';
      }

      return '      $name: MixOps.resolve(context, $fieldName),';
    });

    buffer.writeln('    );');
    buffer.writeln();
    buffer.writeln('    return StyleSpec(');
    buffer.writeln('      spec: spec,');
    buffer.writeln('      animation: \$animation,');
    buffer.writeln('      widgetModifiers: \$modifier?.resolve(context),');
    buffer.writeln('    );');
    buffer.writeln('  }');

    return buffer.toString();
  }

  String _buildDebugFillProperties() {
    return _fieldEmitter().debugFillProperties(
      callSuper: true,
      propertyCode: (field) {
        return "DiagnosticsProperty('${field.displayName}', ${field.declaredName})";
      },
    );
  }

  String _buildProps() {
    return _fieldEmitter().multilineProps(
      propCode: (field) => field.declaredName,
      trailingProps: const [r'$animation', r'$modifier', r'$variants'],
    );
  }

  /// The mixin name.
  String get mixinName => '_\$${stylerName}Mixin';

  /// Builds the complete mixin code.
  String build() {
    final buffer = StringBuffer();

    buffer.writeln('mixin $mixinName on Style<$specName>, Diagnosticable {');

    buffer.writeln(_buildAbstractGetters());

    if (config.generateSetters) {
      buffer.writeln(_buildSetters());
    }

    if (config.generateSetters) {
      buffer.writeln(_buildBaseMethods());
    }

    if (config.generateMerge) {
      buffer.writeln(_buildMerge());
    }

    if (config.generateResolve) {
      buffer.writeln(_buildResolve());
    }

    if (config.generateDebugFillProperties) {
      buffer.writeln(_buildDebugFillProperties());
    }

    if (config.generateProps) {
      buffer.writeln(_buildProps());
    }

    buffer.writeln('}');

    return buffer.toString();
  }
}
