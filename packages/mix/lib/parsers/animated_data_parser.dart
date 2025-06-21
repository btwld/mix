import '../src/attributes/animated/animated_data.dart';
import 'parsers.dart';

/// Parser for [AnimatedData] objects
class AnimatedDataParser extends Parser<AnimatedData> {
  const AnimatedDataParser();

  @override
  Object? encode(AnimatedData? value) {
    if (value == null) return null;

    return {
      'duration': MixParsers.encode(value.duration),
      'curve': MixParsers.encode(value.curve),
      // Note: onEnd callback cannot be serialized
    };
  }

  @override
  AnimatedData? decode(Object? json) {
    if (json == null) return null;
    if (json is! Map<String, Object?>) {
      throw FormatException(
        'Expected Map<String, Object?>, got ${json.runtimeType}',
      );
    }

    return AnimatedData(
      duration:
          json['duration'] != null ? MixParsers.decode(json['duration']) : null,
      curve: json['curve'] != null ? MixParsers.decode(json['curve']) : null,
      // onEnd callback cannot be deserialized - will be null
    );
  }
}
