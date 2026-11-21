import 'package:mix/mix.dart';

import 'translate/tw_translator.dart';
import 'tw_compilation.dart';
import 'tw_config.dart';
import 'tw_types.dart';

/// Compiles Tailwind classes for a Mix styler target.
///
/// Box and Flex stylers retain supported margin variants. Semantic widgets
/// apply external margins outside the interaction area and diagnose unsupported
/// margin variants separately. Text and icon compilation include external-margin
/// diagnostics because those stylers cannot represent margins.
class TwParser {
  final TwConfig config;
  final TwDiagnosticCallback? onDiagnostic;

  @Deprecated('Use onDiagnostic instead.')
  final void Function(String token)? onUnsupported;
  final TwTranslator _translator;

  factory TwParser({
    TwConfig? config,
    TwDiagnosticCallback? onDiagnostic,
    @Deprecated('Use onDiagnostic instead.')
    void Function(String token)? onUnsupported,
  }) {
    final resolvedConfig = config ?? TwConfig.standard();

    return TwParser._(
      config: resolvedConfig,
      translator: TwTranslator(
        config: resolvedConfig,
        onDiagnostic: onDiagnostic,
        legacyOnUnsupported: onUnsupported,
      ),
      onDiagnostic: onDiagnostic,
      onUnsupported: onUnsupported,
    );
  }
  const TwParser._({
    required this.config,
    required this._translator,
    this.onDiagnostic,
    this.onUnsupported,
  });

  TwCompilation<FlexBoxStyler> compileFlex(String classNames) =>
      _translator.compileFlex(classNames);

  FlexBoxStyler parseFlex(String classNames) => compileFlex(classNames).styler;

  TwCompilation<BoxStyler> compileBox(String classNames) =>
      _translator.compileBox(classNames);

  BoxStyler parseBox(String classNames) => compileBox(classNames).styler;

  TwCompilation<TextStyler> compileText(String classNames) =>
      _translator.compileText(classNames);

  TextStyler parseText(String classNames) => compileText(classNames).styler;

  TwCompilation<IconStyler> compileIcon(String classNames) =>
      _translator.compileIcon(classNames);

  IconStyler parseIcon(String classNames) => compileIcon(classNames).styler;
}
