import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import 'tw_config.dart';
import 'tw_parser_v2.dart';

class Div extends StatelessWidget {
  const Div({
    super.key,
    required this.classNames,
    this.child,
    this.children = const [],
    this.isFlex,
    this.onUnsupported,
    this.config,
  });

  final String classNames;
  final Widget? child;
  final List<Widget> children;
  final bool? isFlex;
  final TwConfig? config;
  final Warn? onUnsupported;

  @override
  Widget build(BuildContext context) {
    final cfg = config ?? TwConfig.standard();
    final parser = TwParserV2(config: cfg, onUnsupported: onUnsupported);
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
    Widget? resolvedChild =
        child ?? (children.isNotEmpty ? Column(children: children) : null);
    if (resolvedChild != null) {
      resolvedChild = _constrainIfNeeded(resolvedChild, tokens);
    }
    return Box(style: boxStyle, child: resolvedChild);
  }
}

class Span extends StatelessWidget {
  const Span({
    super.key,
    required this.text,
    required this.classNames,
    this.config,
  });

  final String text;
  final String classNames;
  final TwConfig? config;

  @override
  Widget build(BuildContext context) {
    final cfg = config ?? TwConfig.standard();
    final style = TwParserV2(config: cfg).parseText(classNames);
    return StyledText(text, style: style);
  }
}

Widget _constrainIfNeeded(Widget child, Set<String> tokens) {
  final wantsFullWidth = _hasBaseToken(tokens, 'w-full');
  final wantsFullHeight = _hasBaseToken(tokens, 'h-full');

  if (!wantsFullWidth && !wantsFullHeight) {
    return child;
  }

  return LayoutBuilder(
    builder: (context, constraints) {
      var current = child;

      if (wantsFullWidth &&
          constraints.hasBoundedWidth &&
          constraints.maxWidth.isFinite) {
        current = SizedBox(width: constraints.maxWidth, child: current);
      }

      if (wantsFullHeight &&
          constraints.hasBoundedHeight &&
          constraints.maxHeight.isFinite) {
        current = SizedBox(height: constraints.maxHeight, child: current);
      }

      return current;
    },
  );
}

bool _hasBaseToken(Set<String> tokens, String target) {
  for (final token in tokens) {
    final base = token.substring(token.lastIndexOf(':') + 1);
    if (base == target) {
      return true;
    }
  }
  return false;
}
