import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_protocol/mix_protocol.dart';

/// Wraps [child] in a scope containing all decoded protocol theme tokens.
Widget mixScopeFromProtocolTheme({
  required MixProtocolTheme theme,
  required Widget child,
  Key? key,
}) => MixScope(key: key, tokens: theme.tokens, child: child);
