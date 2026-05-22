import 'package:ack/ack.dart';

/// JSON-side `num` (int or double literal) → Dart-side `double`. Use this
/// for every double-valued field in the schema. JSON does not distinguish
/// int from double, so a wire `{"x": 0}` and `{"x": 0.0}` should both decode.
///
/// `Ack.double()` rejects integer literals strictly, and `Ack.number()` is
/// not yet wired into Ack's JSON Schema export dispatch on the
/// `feat/codec-implementation` branch. The two-branch `AnyOfSchema` works on
/// both axes: it accepts either literal at parse time and exports as a
/// standard `{"anyOf": [number, integer]}` artifact. When Ack ships native
/// int-to-double coercion on `Ack.double()`, this helper can be replaced.
CodecSchema<Object, double> doubleFromNum() =>
    Ack.codec<Object, Object, double>(
      input: Ack.anyOf([Ack.double(), Ack.integer()]),
      output: Ack.instance<double>(),
      decode: (value) => (value as num).toDouble(),
      encode: (value) => value,
    );
