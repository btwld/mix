import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import 'tw_config.dart';
import 'tw_parser_v2.dart';

class Div extends StatelessWidget {
  Div({
    super.key,
    required this.classNames,
    this.child,
    this.children = const [],
    this.isFlex,
    TwConfig? config,
    this.onUnsupported,
  }) : config = config ?? TwConfig.standard();

  final String classNames;
  final Widget? child;
  final List<Widget> children;
  final bool? isFlex;
  final TwConfig config;
  final Warn? onUnsupported;

  @override
  Widget build(BuildContext context) {
    final parser = TwParserV2(config: config, onUnsupported: onUnsupported);
    final tokens = parser.setTokens(classNames);
    final shouldUseFlex = isFlex ?? parser.wantsFlex(tokens);

    if (shouldUseFlex) {
      final flexStyle = parser.parseFlex(classNames);
      final flexChildren = children.isNotEmpty
          ? children
          : (child != null ? <Widget>[child!] : const <Widget>[]);
      return FlexBox(style: flexStyle, children: flexChildren);
    }

    final boxStyle = parser.parseBox(classNames);
    final resolvedChild =
        child ?? (children.isNotEmpty ? Row(children: children) : null);
    return Box(style: boxStyle, child: resolvedChild);
  }
}

class Span extends StatelessWidget {
  Span({
    super.key,
    required this.text,
    required this.classNames,
    TwConfig? config,
  }) : config = config ?? TwConfig.standard();

  final String text;
  final String classNames;
  final TwConfig config;

  @override
  Widget build(BuildContext context) {
    final style = TwParserV2(config: config).parseText(classNames);
    return StyledText(text, style: style);
  }
}
