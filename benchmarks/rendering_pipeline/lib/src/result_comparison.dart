import 'dart:convert';

Map<String, Object?> compareBenchmarkDocuments(
  List<Map<String, Object?>> documents,
) {
  final grouped = <String, List<Map<String, Object?>>>{};
  final scopeByKey = <String, Map<String, Object?>>{};
  for (final document in documents) {
    final metadata = Map<String, Object?>.from(document['metadata']! as Map);
    final results = document['results']! as List;
    for (final rawResult in results) {
      final result = Map<String, Object?>.from(rawResult as Map);
      final scenario = result['scenario'] as String;
      final track = result['track'] as String;
      final action = result['action'] as String? ?? 'unknown';
      final scope = <String, Object?>{
        'kind': metadata['kind'] as String? ?? 'unknown',
        'implementation_label':
            metadata['implementation_label'] as String? ?? 'unknown',
        'mix_sha': metadata['mix_sha'] as String? ?? 'unknown',
        'flutter_revision':
            metadata['flutter_revision'] as String? ?? 'unknown',
        'device_name': metadata['device_name'] as String? ?? 'unknown',
        'physical_width_px': metadata['physical_width_px'],
        'physical_height_px': metadata['physical_height_px'],
        'refresh_rate_hz': metadata['refresh_rate_hz'],
        'scenario': scenario,
        'track': track,
        'action': action,
      };
      final key = jsonEncode(scope);
      scopeByKey[key] = scope;
      grouped.putIfAbsent(key, () => <Map<String, Object?>>[]).add(result);
    }
  }

  final comparisons = <Map<String, Object?>>[];
  final unpaired = <Map<String, Object?>>[];
  final sortedKeys = grouped.keys.toList()..sort();
  for (final key in sortedKeys) {
    final results = grouped[key]!;
    final flutterResults = results
        .where((result) => result['implementation'] == 'flutter')
        .toList();
    final mixResults = results
        .where((result) => result['implementation'] == 'mix')
        .toList();
    if (flutterResults.isEmpty || mixResults.isEmpty) {
      unpaired.add(<String, Object?>{
        'key': key,
        'flutter_run_count': flutterResults.length,
        'mix_run_count': mixResults.length,
      });
      continue;
    }

    final flutterMetrics = _averageMetrics(flutterResults);
    final mixMetrics = _averageMetrics(mixResults);
    final metricNames =
        flutterMetrics.keys.where(mixMetrics.containsKey).toList()..sort();
    final metrics = <String, Object?>{};
    for (final metricName in metricNames) {
      final flutterValue = flutterMetrics[metricName]!;
      final mixValue = mixMetrics[metricName]!;
      metrics[metricName] = <String, Object?>{
        'flutter': flutterValue,
        'mix': mixValue,
        'absolute_delta_mix_minus_flutter': mixValue - flutterValue,
        'mix_over_flutter_ratio': flutterValue == 0
            ? null
            : mixValue / flutterValue,
      };
    }

    comparisons.add(<String, Object?>{
      ...scopeByKey[key]!,
      'flutter_run_count': flutterResults.length,
      'mix_run_count': mixResults.length,
      'metrics': metrics,
    });
  }

  return <String, Object?>{
    'schema_version': 1,
    'document_count': documents.length,
    'comparisons': comparisons,
    'unpaired_results': unpaired,
  };
}

Map<String, double> _averageMetrics(List<Map<String, Object?>> results) {
  final valuesByMetric = <String, List<double>>{};
  for (final result in results) {
    final metrics = result['metrics']! as Map;
    for (final entry in metrics.entries) {
      final value = entry.value;
      if (value is num) {
        valuesByMetric
            .putIfAbsent(entry.key as String, () => <double>[])
            .add(value.toDouble());
      }
    }
  }

  return valuesByMetric.map((String key, List<double> values) {
    final total = values.fold<double>(0, (double sum, double value) {
      return sum + value;
    });
    return MapEntry<String, double>(key, total / values.length);
  });
}
