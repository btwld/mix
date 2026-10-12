# mix_chart_protocol

`mix_chart_protocol` is the optional integration between the publishable
`mix_chart` runtime and `mix_protocol`. It depends on both packages so
`mix_chart` does not have to make serialization part of every chart app.

Use the ready-to-use protocol for the common core-plus-chart composition:

```dart
import 'package:mix_chart_protocol/mix_chart_protocol.dart';

final encoded = mixChartProtocol.encodeStyle(chartStyle);
```

Applications, servers, and tooling opt into this sidecar only when they cross a
JSON boundary. `mix_chart` itself must not depend on it: Dart packages have no
optional dependencies, and most chart rendering does not need the protocol.

Use the exported vocabulary directly only when combining charts with another
package vocabulary:

```dart
import 'package:mix_chart_protocol/mix_chart_protocol.dart';

final protocol = MixProtocol.compose([
  mixProtocolCoreVocabulary,
  mixChartVocabulary,
  anotherVocabulary,
]);
```

The sidecar re-exports the protocol API used by `mixChartProtocol`, so this
integration needs only one protocol import.

The vocabulary uses the `mix_chart.v1.*` namespace and contains all 15 chart
stylers, including shared nested stylers. Core stylers such as `TextStyler`
inside chart labels recurse through the same composed union. Variants,
modifiers, animation, property terms, tokens, and lenient decoding use the
ordinary `mix_protocol` grammar.

This sidecar is unpublished while `mix_protocol` is unpublished. Keeping it
separate preserves `mix_chart`'s existing publish contract and avoids exposing
the private Ack implementation.
