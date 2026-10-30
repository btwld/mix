# mix_chart_protocol

Optional JSON integration between `mix_chart` and `mix_protocol`. Dart has no
optional package dependencies, so rendering apps avoid codecs by omitting this
sidecar. See the [dependency decision](../../ARCHITECTURE.md#chart-renderer-and-optional-serialization).

```dart
import 'package:mix_chart_protocol/mix_chart_protocol.dart';

final encoded = mixChartProtocol.encodeStyle(chartStyle);
```

`mixChartProtocol` is the ready-made core-plus-chart composition. Only compose
explicitly when adding another vocabulary:

```dart
final protocol = MixProtocol.compose([
  mixProtocolCoreVocabulary,
  mixChartVocabulary,
  anotherVocabulary,
]);
```

The sidecar re-exports the protocol API. Its `mix_chart.v1.*` vocabulary covers
all 15 chart stylers, including nested stylers. Core styles in chart labels use
the same composed union; variants, modifiers, animation, tokens and lenient
decoding follow the ordinary [wire contract](../mix_protocol/WIRE_CONTRACT.md).

The manifest currently sets `publish_to: none`; `mix_protocol` has a hosted
prerelease. Check sidecar availability independently of the runtime package's
release. Keeping this boundary separate also hides the private Ack engine.
