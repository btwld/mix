import 'dart:convert';
import 'dart:io';

import '../../mix_protocol/tool/styler_surface.dart' as inventory;

void main() {
  final sourceRoot = _packageSourceRoot('mix_chart');
  final surface = inventory.collectStylerSurface(sourceRoot: sourceRoot);
  final vocabularySource = File(
    'lib/src/mix_chart_vocabulary.dart',
  ).readAsStringSync();
  final vocabularyTypes = RegExp(
    r'MixProtocolStylerBranch<([^>]+)>',
  ).allMatches(vocabularySource).map((match) => match.group(1)!).toSet();
  final missingBranches = surface.stylerNames.difference(vocabularyTypes);
  final staleBranches = vocabularyTypes.difference(surface.stylerNames);
  final generatedFields = inventory
      .collectGeneratedStylerSurface(sourceRoot: sourceRoot)
      .fieldsByStyler;
  final fieldDrift = <String>{};
  for (final styler in {...surface.stylerNames, ...generatedFields.keys}) {
    if (!_sameSet(surface.fieldsByStyler[styler], generatedFields[styler])) {
      fieldDrift.add(styler);
    }
  }

  if (missingBranches.isEmpty && staleBranches.isEmpty && fieldDrift.isEmpty) {
    stdout.writeln(
      'mix_chart vocabulary and generated inventory ok: '
      '${surface.stylerNames.length} stylers',
    );

    return;
  }

  stderr.writeln('mix_chart vocabulary inventory drift detected');
  if (missingBranches.isNotEmpty) {
    stderr.writeln('Missing branches: ${missingBranches.toList()..sort()}');
  }
  if (staleBranches.isNotEmpty) {
    stderr.writeln('Stale branches: ${staleBranches.toList()..sort()}');
  }
  if (fieldDrift.isNotEmpty) {
    stderr.writeln('Field drift: ${fieldDrift.toList()..sort()}');
  }
  exitCode = 1;
}

Directory _packageSourceRoot(String packageName) {
  final configFile = File('.dart_tool/package_config.json');
  final config =
      jsonDecode(configFile.readAsStringSync()) as Map<String, Object?>;
  final packages = config['packages']! as List<Object?>;
  final package = packages.cast<Map<String, Object?>>().singleWhere(
    (entry) => entry['name'] == packageName,
  );
  final root = Directory.fromUri(
    configFile.parent.uri.resolve(package['rootUri']! as String),
  );

  return Directory.fromUri(root.uri.resolve('lib/src/'));
}

bool _sameSet(Set<String>? left, Set<String>? right) {
  return left != null &&
      right != null &&
      left.length == right.length &&
      left.containsAll(right);
}
