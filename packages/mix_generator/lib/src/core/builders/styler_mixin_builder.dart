/// Styler mixin builder for generating _$XStylerMixin.
///
/// Generates abstract getters, setters, merge(), resolve(),
/// debugFillProperties(), props, and call() methods.
library;

import '../models/annotation_config.dart';
import '../models/styler_field_model.dart';

/// Builds the _$XStylerMixin for a Styler class.
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

  String _buildAbstractGetters() {
    if (fields.isEmpty) return '';

    final buffer = StringBuffer();
    for (final field in fields) {
      final typeStr = field.dartType.getDisplayString();
      buffer.writeln('  $typeStr get ${field.declaredName};');
    }
    buffer.writeln();

    return buffer.toString();
  }

  String _buildSetters() {
    if (!config.generateSetters) return '';

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
    if (!config.generateSetters) return '';

    final buffer = StringBuffer();

    // animate method
    buffer.writeln('  /// Sets the animation configuration.');
    buffer.writeln('  $stylerName animate(AnimationConfig value) {');
    buffer.writeln('    return merge($stylerName(animation: value));');
    buffer.writeln('  }');
    buffer.writeln();

    // variants method
    buffer.writeln('  /// Sets the style variants.');
    buffer.writeln(
      '  $stylerName variants(List<VariantStyle<$specName>> value) {',
    );
    buffer.writeln('    return merge($stylerName(variants: value));');
    buffer.writeln('  }');
    buffer.writeln();

    // wrap method
    buffer.writeln('  /// Wraps with a widget modifier.');
    buffer.writeln('  $stylerName wrap(WidgetModifierConfig value) {');
    buffer.writeln('    return merge($stylerName(modifier: value));');
    buffer.writeln('  }');
    buffer.writeln();

    return buffer.toString();
  }

  String _buildMerge() {
    if (!config.generateMerge) return '';

    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.writeln('  $stylerName merge($stylerName? other) {');
    buffer.writeln('    return $stylerName.create(');

    // Field merge assignments
    for (final field in fields) {
      final fieldName = field.declaredName;
      final name = field.name;

      if (field.isRawList) {
        // Raw lists use MixOps.mergeList
        buffer.writeln(
          '      $name: MixOps.mergeList($fieldName, other?.$fieldName),',
        );
      } else {
        // Regular fields use MixOps.merge
        buffer.writeln(
          '      $name: MixOps.merge($fieldName, other?.$fieldName),',
        );
      }
    }

    // Base fields
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
    if (!config.generateResolve) return '';

    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.writeln('  StyleSpec<$specName> resolve(BuildContext context) {');
    buffer.writeln('    final spec = $specName(');

    // Field resolve assignments
    for (final field in fields) {
      final fieldName = field.declaredName;
      final name = field.name;

      if (field.isRawList) {
        // Raw lists pass through directly
        buffer.writeln('      $name: $fieldName,');
      } else {
        // Regular fields use MixOps.resolve
        buffer.writeln('      $name: MixOps.resolve(context, $fieldName),');
      }
    }

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
    if (!config.generateDebugFillProperties) return '';

    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.writeln(
      '  void debugFillProperties(DiagnosticPropertiesBuilder properties) {',
    );
    buffer.writeln('    super.debugFillProperties(properties);');

    if (fields.isNotEmpty) {
      buffer.writeln('    properties');

      for (int i = 0; i < fields.length; i++) {
        final field = fields[i];
        final displayName = field.displayName;
        final fieldName = field.declaredName;
        final separator = i == fields.length - 1 ? ';' : '';
        buffer.writeln(
          "      ..add(DiagnosticsProperty('$displayName', $fieldName))$separator",
        );
      }
    }

    buffer.writeln('  }');

    return buffer.toString();
  }

  String _buildProps() {
    if (!config.generateProps) return '';

    final buffer = StringBuffer();

    buffer.writeln('  @override');
    buffer.write('  List<Object?> get props => [');

    if (fields.isEmpty) {
      buffer.writeln();
      buffer.writeln('    \$animation,');
      buffer.writeln('    \$modifier,');
      buffer.writeln('    \$variants,');
      buffer.writeln('  ];');
    } else {
      buffer.writeln();
      // Domain fields
      for (final field in fields) {
        buffer.writeln('    ${field.declaredName},');
      }
      // Base fields
      buffer.writeln('    \$animation,');
      buffer.writeln('    \$modifier,');
      buffer.writeln('    \$variants,');
      buffer.writeln('  ];');
    }

    return buffer.toString();
  }

  /// The mixin name.
  String get mixinName => '_\$${stylerName}Mixin';

  /// Builds the complete mixin code.
  String build() {
    final buffer = StringBuffer();

    buffer.writeln('mixin $mixinName on Style<$specName>, Diagnosticable {');

    // Generate abstract getters
    buffer.writeln(_buildAbstractGetters());

    // Generate setters
    if (config.generateSetters) {
      buffer.writeln(_buildSetters());
    }

    // Generate base methods (animate, variants, wrap)
    if (config.generateSetters) {
      buffer.writeln(_buildBaseMethods());
    }

    // Generate merge
    if (config.generateMerge) {
      buffer.writeln(_buildMerge());
    }

    // Generate resolve
    if (config.generateResolve) {
      buffer.writeln(_buildResolve());
    }

    // Generate debugFillProperties
    if (config.generateDebugFillProperties) {
      buffer.writeln(_buildDebugFillProperties());
    }

    // Generate props
    if (config.generateProps) {
      buffer.writeln(_buildProps());
    }

    buffer.writeln('}');

    return buffer.toString();
  }
}
