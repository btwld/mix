/// `mix_protocol` vocabulary for every public `mix_chart` styler.
library;

import 'package:mix_protocol/mix_protocol.dart'
    show MixProtocol, mixProtocolCoreVocabulary;

import 'src/mix_chart_vocabulary.dart';

export 'package:mix_protocol/mix_protocol.dart';
export 'src/mix_chart_vocabulary.dart' show mixChartVocabulary;

/// Ready-to-use protocol containing the core Mix and chart vocabularies.
final MixProtocol mixChartProtocol = MixProtocol.compose([
  mixProtocolCoreVocabulary,
  mixChartVocabulary,
]);
