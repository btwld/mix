import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart' as path;

void main() async {
  final widgets = [
    WidgetConfig(
      widgetName: 'Box',
      widgetPath: 'packages/mix/lib/src/specs/box/box_widget.dart',
      stylerName: 'BoxStyler',
      stylerPath: 'packages/mix/lib/src/specs/box/box_style.dart',
      outputFileName: 'box.mdx',
    ),
    WidgetConfig(
      widgetName: 'FlexBox',
      widgetPath: 'packages/mix/lib/src/specs/flexbox/flexbox_widget.dart',
      stylerName: 'FlexBoxStyler',
      stylerPath: 'packages/mix/lib/src/specs/flexbox/flexbox_style.dart',
      outputFileName: 'flexbox.mdx',
    ),
    WidgetConfig(
      widgetName: 'StyledText',
      widgetPath: 'packages/mix/lib/src/specs/text/text_widget.dart',
      stylerName: 'TextStyler',
      stylerPath: 'packages/mix/lib/src/specs/text/text_style.dart',
      outputFileName: 'text.mdx',
    ),
    WidgetConfig(
      widgetName: 'StyledIcon',
      widgetPath: 'packages/mix/lib/src/specs/icon/icon_widget.dart',
      stylerName: 'IconStyler',
      stylerPath: 'packages/mix/lib/src/specs/icon/icon_style.dart',
      outputFileName: 'icon.mdx',
    ),
    WidgetConfig(
      widgetName: 'StyledImage',
      widgetPath: 'packages/mix/lib/src/specs/image/image_widget.dart',
      stylerName: 'ImageStyler',
      stylerPath: 'packages/mix/lib/src/specs/image/image_style.dart',
      outputFileName: 'image.mdx',
    ),
    WidgetConfig(
      widgetName: 'StackBox',
      widgetPath: 'packages/mix/lib/src/specs/stackbox/stackbox_widget.dart',
      stylerName: 'StackBoxStyler',
      stylerPath: 'packages/mix/lib/src/specs/stackbox/stackbox_style.dart',
      outputFileName: 'stack.mdx',
    ),
  ];

  final outputDir = Directory('website/src/content/documentation/widgets');
  if (!outputDir.existsSync()) {
    outputDir.createSync(recursive: true);
  }

  for (final widget in widgets) {
    print('Generating documentation for ${widget.widgetName}...');
    try {
      final doc = await generateDocumentation(widget);
      final outputPath = path.join(outputDir.path, widget.outputFileName);
      await File(outputPath).writeAsString(doc);
      print('✓ Generated ${widget.outputFileName}');
    } catch (e) {
      print('✗ Error generating ${widget.widgetName}: $e');
    }
  }

  print('\nDocumentation generation complete!');
}

class WidgetConfig {
  final String widgetName;
  final String widgetPath;
  final String stylerName;
  final String stylerPath;
  final String outputFileName;

  WidgetConfig({
    required this.widgetName,
    required this.widgetPath,
    required this.stylerName,
    required this.stylerPath,
    required this.outputFileName,
  });
}

class WidgetInfo {
  final String name;
  final String? documentation;
  final List<ConstructorParam> constructorParams;

  WidgetInfo({
    required this.name,
    this.documentation,
    required this.constructorParams,
  });
}

class ConstructorParam {
  final String name;
  final String type;
  final bool isRequired;
  final String? defaultValue;
  final String? documentation;

  ConstructorParam({
    required this.name,
    required this.type,
    required this.isRequired,
    this.defaultValue,
    this.documentation,
  });
}

class StylerMethod {
  final String name;
  final String returnType;
  final List<MethodParam> parameters;
  final String? documentation;
  final String source; // The class or mixin name this method comes from

  StylerMethod({
    required this.name,
    required this.returnType,
    required this.parameters,
    this.documentation,
    required this.source,
  });
}

class MethodParam {
  final String name;
  final String type;
  final bool isRequired;
  final bool isNamed;
  final String? defaultValue;

  MethodParam({
    required this.name,
    required this.type,
    required this.isRequired,
    required this.isNamed,
    this.defaultValue,
  });
}

Future<String> generateDocumentation(WidgetConfig config) async {
  // Parse widget file
  final widgetInfo = await parseWidgetFile(
    config.widgetPath,
    config.widgetName,
  );

  // Parse styler file
  final stylerMethods = await parseStylerFile(
    config.stylerPath,
    config.stylerName,
  );

  // Generate markdown
  final buffer = StringBuffer();

  // Title
  buffer.writeln('# ${widgetInfo.name}');
  buffer.writeln();

  // Documentation
  if (widgetInfo.documentation != null &&
      widgetInfo.documentation!.isNotEmpty) {
    final formattedDoc = _formatDocumentation(widgetInfo.documentation!);
    buffer.writeln(formattedDoc);
    buffer.writeln();
  }

  // Constructor table
  buffer.writeln('## Constructor');
  buffer.writeln();
  buffer.writeln(
    '| Prop  | Type         | Required / Default Value                |',
  );
  buffer.writeln(
    '|-------|--------------|------------------------------------------|',
  );

  for (final param in widgetInfo.constructorParams) {
    final required = param.isRequired
        ? 'Required'
        : (param.defaultValue ?? 'Optional');
    buffer.writeln('| `${param.name}` | `${param.type}` | `$required` |');
  }
  buffer.writeln();

  // Style API Reference - grouped by source
  buffer.writeln('## Style API Reference');
  buffer.writeln();

  // Group methods by their source (mixin or class)
  final methodsBySource = <String, List<StylerMethod>>{};
  for (final method in stylerMethods) {
    if (_shouldSkipMethod(method.name)) continue;

    methodsBySource.putIfAbsent(method.source, () => []).add(method);
  }

  // Sort sources: main class first, then mixins alphabetically
  final sources = methodsBySource.keys.toList();
  sources.sort((a, b) {
    // Main class (the styler itself) comes first
    if (a == config.stylerName) return -1;
    if (b == config.stylerName) return 1;
    // Then sort mixins alphabetically
    return a.compareTo(b);
  });

  // Generate a table for each source
  for (final source in sources) {
    final methods = methodsBySource[source]!;

    // Create a friendly section name
    String sectionName = source;
    if (source == config.stylerName) {
      sectionName = '${widgetInfo.name} Methods';
    } else {
      // Convert mixin names to readable titles
      sectionName = _formatMixinName(source);
    }

    buffer.writeln('### $sectionName');
    buffer.writeln();
    buffer.writeln('| Method | Description |');
    buffer.writeln('|--------|-------------|');

    for (final method in methods) {
      final description = method.documentation?.replaceAll('\n', ' ') ?? '';
      buffer.writeln('| `${method.name}` | $description |');
    }
    buffer.writeln();
  }

  return buffer.toString();
}

String _formatMixinName(String mixinName) {
  // Convert camel case to title case with spaces
  // e.g., "BorderStyleMixin" -> "Border Style"
  final name = mixinName
      .replaceAll('Mixin', '')
      .replaceAll('Style', '')
      .replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(1)}')
      .trim();

  return name;
}

String _formatDocumentation(String doc) {
  // Replace [text] with `text` for inline code, but not inside code blocks
  final buffer = StringBuffer();
  var inCodeBlock = false;
  final lines = doc.split('\n');

  for (final line in lines) {
    // Check if this line starts/ends a code block
    if (line.trim().startsWith('```')) {
      inCodeBlock = !inCodeBlock;
      buffer.writeln(line);
      continue;
    }

    if (inCodeBlock) {
      // Don't modify content inside code blocks
      buffer.writeln(line);
    } else {
      // Replace [text] with `text` for inline code references
      final formattedLine = line.replaceAll('[', '`').replaceAll(']', '`');
      buffer.writeln(formattedLine);
    }
  }

  return buffer.toString().trim();
}

bool _shouldSkipMethod(String methodName) {
  const skipMethods = [
    'merge',
    'resolve',
    'copyWith',
    'debugFillProperties',
    'call',
    'chain',
    'create',
    'only',
    'props', // Getter for equality, not a style method
    'noSuchMethod',
    'toString',
    'hashCode',
  ];

  return skipMethods.contains(methodName) ||
      methodName.startsWith('_') ||
      methodName.startsWith('\$');
}

Future<WidgetInfo> parseWidgetFile(String filePath, String className) async {
  final file = File(filePath);
  final content = await file.readAsString();

  final parseResult = parseString(
    content: content,
    featureSet: FeatureSet.latestLanguageVersion(),
    throwIfDiagnostics: false,
  );

  final visitor = WidgetVisitor(className);
  parseResult.unit.accept(visitor);

  return WidgetInfo(
    name: className,
    documentation: visitor.documentation,
    constructorParams: visitor.constructorParams,
  );
}

Future<List<StylerMethod>> parseStylerFile(
  String filePath,
  String className,
) async {
  final file = File(filePath);
  final content = await file.readAsString();

  final parseResult = parseString(
    content: content,
    featureSet: FeatureSet.latestLanguageVersion(),
    throwIfDiagnostics: false,
  );

  final visitor = StylerVisitor(className);
  parseResult.unit.accept(visitor);

  // Parse mixin files
  final mixinImports = _extractMixinImports(
    parseResult.unit,
    visitor.mixinNames,
  );
  final fileDir = path.dirname(filePath);

  for (final mixinImport in mixinImports) {
    final mixinPath = path.normalize(path.join(fileDir, mixinImport));
    if (File(mixinPath).existsSync()) {
      final mixinContent = await File(mixinPath).readAsString();
      final mixinParseResult = parseString(
        content: mixinContent,
        featureSet: FeatureSet.latestLanguageVersion(),
        throwIfDiagnostics: false,
      );
      mixinParseResult.unit.accept(visitor);
    }
  }

  return visitor.methods;
}

List<String> _extractMixinImports(
  CompilationUnit unit,
  List<String> mixinNames,
) {
  final imports = <String>[];
  final mixinFileMap = {
    'WidgetModifierStyleMixin':
        '../../style/mixins/widget_modifier_style_mixin.dart',
    'VariantStyleMixin': '../../style/mixins/variant_style_mixin.dart',
    'WidgetStateVariantMixin':
        '../../style/mixins/widget_state_variant_mixin.dart',
    'BorderStyleMixin': '../../style/mixins/border_style_mixin.dart',
    'BorderRadiusStyleMixin':
        '../../style/mixins/border_radius_style_mixin.dart',
    'ShadowStyleMixin': '../../style/mixins/shadow_style_mixin.dart',
    'DecorationStyleMixin': '../../style/mixins/decoration_style_mixin.dart',
    'SpacingStyleMixin': '../../style/mixins/spacing_style_mixin.dart',
    'TransformStyleMixin': '../../style/mixins/transform_style_mixin.dart',
    'ConstraintStyleMixin': '../../style/mixins/constraint_style_mixin.dart',
    'AnimationStyleMixin': '../../style/mixins/animation_style_mixin.dart',
    'FlexStyleMixin': '../../style/mixins/flex_style_mixin.dart',
    'TextStyleMixin': '../../style/mixins/text_style_mixin.dart',
  };

  for (final mixinName in mixinNames) {
    final cleanName = mixinName.replaceAll(RegExp(r'<.*>'), '').trim();
    if (mixinFileMap.containsKey(cleanName)) {
      imports.add(mixinFileMap[cleanName]!);
    }
  }

  return imports;
}

class WidgetVisitor extends RecursiveAstVisitor<void> {
  final String targetClassName;
  String? documentation;
  List<ConstructorParam> constructorParams = [];
  Map<String, String> fieldTypes = {}; // Maps field name to its type

  WidgetVisitor(this.targetClassName);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (node.name.lexeme == targetClassName) {
      // Extract class documentation
      final docComment = node.documentationComment;
      if (docComment != null) {
        documentation = _extractDocumentation(docComment);
      }

      // First, extract field types
      for (final member in node.members) {
        if (member is FieldDeclaration) {
          for (final variable in member.fields.variables) {
            final fieldName = variable.name.lexeme;
            final fieldType = member.fields.type?.toSource() ?? 'dynamic';
            fieldTypes[fieldName] = fieldType;
          }
        }
      }

      // Then find constructor
      for (final member in node.members) {
        if (member is ConstructorDeclaration) {
          _extractConstructorParams(member);
          break;
        }
      }
    }
    super.visitClassDeclaration(node);
  }

  void _extractConstructorParams(ConstructorDeclaration constructor) {
    for (final param in constructor.parameters.parameters) {
      if (param is DefaultFormalParameter) {
        final normalParam = param.parameter;
        String paramName = '';
        String paramType = 'dynamic';

        if (normalParam is SimpleFormalParameter) {
          paramName = normalParam.name?.lexeme ?? '';
          paramType = normalParam.type?.toSource() ?? 'dynamic';
        } else if (normalParam is SuperFormalParameter) {
          paramName = normalParam.name.lexeme;
          paramType = _resolveSuperParamType(
            paramName,
            normalParam.type?.toSource(),
          );
        } else if (normalParam is FieldFormalParameter) {
          paramName = normalParam.name.lexeme;
          paramType =
              normalParam.type?.toSource() ??
              fieldTypes[paramName] ??
              'dynamic';
        }

        // Skip 'key' parameter
        if (paramName == 'key') continue;

        final defaultValue = param.defaultValue?.toSource();
        final isRequired = param.isRequired;

        constructorParams.add(
          ConstructorParam(
            name: paramName,
            type: paramType,
            isRequired: isRequired,
            defaultValue: defaultValue,
          ),
        );
      } else if (param is SimpleFormalParameter) {
        final paramName = param.name?.lexeme ?? '';
        final paramType = param.type?.toSource() ?? 'dynamic';

        // Skip 'key' parameter
        if (paramName == 'key') continue;

        constructorParams.add(
          ConstructorParam(name: paramName, type: paramType, isRequired: true),
        );
      } else if (param is SuperFormalParameter) {
        final paramName = param.name.lexeme;
        final paramType = _resolveSuperParamType(
          paramName,
          param.type?.toSource(),
        );

        // Skip super parameters that we don't want to document
        if (paramName == 'key') continue;

        constructorParams.add(
          ConstructorParam(
            name: paramName,
            type: paramType,
            isRequired: param.isRequired,
          ),
        );
      } else if (param is FieldFormalParameter) {
        final paramName = param.name.lexeme;
        final paramType =
            param.type?.toSource() ?? fieldTypes[paramName] ?? 'dynamic';

        // Skip 'key' parameter
        if (paramName == 'key') continue;

        constructorParams.add(
          ConstructorParam(
            name: paramName,
            type: paramType,
            isRequired: param.isRequired,
          ),
        );
      }
    }
  }

  String _resolveSuperParamType(String paramName, String? declaredType) {
    if (declaredType != null) return declaredType;

    // Known super parameter types from StyleWidget
    switch (paramName) {
      case 'style':
        return 'Style';
      case 'styleSpec':
        return 'StyleSpec?';
      case 'key':
        return 'Key?';
      default:
        return 'dynamic';
    }
  }

  String _extractDocumentation(Comment comment) {
    final docs = comment.tokens
        .map((token) => token.lexeme)
        .join('\n')
        .replaceAll(RegExp(r'^///\s?', multiLine: true), '/SKIP/')
        .replaceAll(RegExp(r'^/SKIP//SKIP/\s?', multiLine: true), '\n')
        .replaceAll(RegExp(r'^/SKIP/\s?', multiLine: true), '')
        .trim();

    return docs;
  }
}

class StylerVisitor extends RecursiveAstVisitor<void> {
  final String targetClassName;
  List<StylerMethod> methods = [];
  List<String> mixinNames = [];
  final Set<String> _addedMethods =
      {}; // Track added method names to avoid duplicates
  String _currentSource = ''; // Track current class or mixin being visited

  StylerVisitor(this.targetClassName);

  @override
  void visitClassDeclaration(ClassDeclaration node) {
    if (node.name.lexeme == targetClassName) {
      // Set current source to the target class name
      _currentSource = targetClassName;

      // Extract mixin names
      if (node.withClause != null) {
        for (final mixin in node.withClause!.mixinTypes) {
          final mixinName = mixin.toString().replaceAll(RegExp(r'<.*>'), '');
          mixinNames.add(mixinName);
        }
      }

      // Extract public methods
      for (final member in node.members) {
        if (member is MethodDeclaration) {
          if (!member.isStatic &&
              !member.isGetter && // Skip getters
              !member.name.lexeme.startsWith('_') &&
              !member.name.lexeme.startsWith('\$') &&
              member.returnType != null) {
            _extractMethod(member);
          }
        }
      }
    }
    super.visitClassDeclaration(node);
  }

  @override
  void visitMixinDeclaration(MixinDeclaration node) {
    if (mixinNames.contains(node.name.lexeme)) {
      // Set current source to the mixin name
      _currentSource = node.name.lexeme;

      // Extract public methods from mixin
      for (final member in node.members) {
        if (member is MethodDeclaration) {
          if (!member.isStatic &&
              !member.isGetter &&
              !member.name.lexeme.startsWith('_') &&
              !member.name.lexeme.startsWith('\$') &&
              member.returnType != null) {
            _extractMethod(member);
          }
        }
      }
    }
    super.visitMixinDeclaration(node);
  }

  void _extractMethod(MethodDeclaration method) {
    final methodName = method.name.lexeme;

    // Skip if already added (avoid duplicates from overridden methods)
    if (_addedMethods.contains(methodName)) {
      return;
    }

    final returnType = method.returnType?.toSource() ?? 'void';

    // Extract documentation
    String? documentation;
    final docComment = method.documentationComment;
    if (docComment != null) {
      documentation = _extractDocumentation(docComment);
    }

    // Extract parameters
    final parameters = <MethodParam>[];
    if (method.parameters != null) {
      for (final param in method.parameters!.parameters) {
        if (param is DefaultFormalParameter) {
          final normalParam = param.parameter;
          String paramName = '';
          String paramType = 'dynamic';

          if (normalParam is SimpleFormalParameter) {
            paramName = normalParam.name?.lexeme ?? '';
            paramType = normalParam.type?.toSource() ?? 'dynamic';
          }

          final defaultValue = param.defaultValue?.toSource();
          final isRequired = param.isRequired;
          final isNamed = param.isNamed;

          parameters.add(
            MethodParam(
              name: paramName,
              type: paramType,
              isRequired: isRequired,
              isNamed: isNamed,
              defaultValue: defaultValue,
            ),
          );
        } else if (param is SimpleFormalParameter) {
          final paramName = param.name?.lexeme ?? '';
          final paramType = param.type?.toSource() ?? 'dynamic';

          parameters.add(
            MethodParam(
              name: paramName,
              type: paramType,
              isRequired: true,
              isNamed: false,
            ),
          );
        }
      }
    }

    methods.add(
      StylerMethod(
        name: methodName,
        returnType: returnType,
        parameters: parameters,
        documentation: documentation,
        source: _currentSource,
      ),
    );

    _addedMethods.add(methodName);
  }

  String _extractDocumentation(Comment comment) {
    final docs = comment.tokens
        .map((token) => token.lexeme)
        .join('\n')
        .replaceAll(RegExp(r'^///\s?', multiLine: true), '')
        .replaceAll(RegExp(r'^/\*\*\s?', multiLine: true), '')
        .replaceAll(RegExp(r'\s?\*/$', multiLine: true), '')
        .replaceAll(RegExp(r'^\s?\*\s?', multiLine: true), '')
        .trim();

    return docs;
  }
}
