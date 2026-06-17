import 'package:mix/mix.dart';
import 'package:mix_schema/mix_schema.dart';

import 'translate/tw_target.dart' as target;
import 'translate/tw_translator.dart';
import 'tw_config.dart';
import 'tw_types.dart';

class TwParser {
  factory TwParser({TwConfig? config, TokenWarningCallback? onUnsupported}) {
    final resolvedConfig = config ?? TwConfig.standard();
    return TwParser._(
      config: resolvedConfig,
      translator: TwTranslator(
        config: resolvedConfig,
        onUnsupported: onUnsupported,
      ),
      onUnsupported: onUnsupported,
    );
  }

  TwParser._({
    required this.config,
    required TwTranslator translator,
    this.onUnsupported,
  }) : _translator = translator;

  final TwConfig config;
  final TokenWarningCallback? onUnsupported;
  final TwTranslator _translator;

  List<String> listTokens(String classNames) =>
      _translator.listTokens(classNames);

  Set<String> setTokens(String classNames) => listTokens(classNames).toSet();

  bool wantsFlex(Set<String> tokens) => target.wantsFlex(tokens);

  FlexBoxStyler parseFlex(String classNames) =>
      _translator.translateFlex(classNames);

  JsonMap parseFlexPayload(String classNames) =>
      _translator.payloadFlex(classNames);

  BoxStyler parseBox(String classNames) => _translator.translateBox(classNames);

  JsonMap parseBoxPayload(String classNames) =>
      _translator.payloadBox(classNames);

  TextStyler parseText(String classNames) =>
      _translator.translateText(classNames);

  JsonMap parseTextPayload(String classNames) =>
      _translator.payloadText(classNames);

  CurveAnimationConfig? parseAnimationFromTokens(List<String> tokens) =>
      _translator.parseAnimationFromTokens(tokens);
}
