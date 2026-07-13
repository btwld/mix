import 'dart:convert';
import 'dart:io';

const _defaultSnapshotPath = 'tool/tailwind_parser_registry_snapshot.json';

void main(List<String> args) {
  if (args.isNotEmpty && args.first == '--write-snapshot') {
    _writeSnapshot(args);
    return;
  }

  if (args.length > 1) {
    _printUsage();
    exitCode = 64;
    return;
  }

  final sourcePath = args.isEmpty ? _defaultSnapshotPath : args.single;
  final snapshot = _readSnapshot(sourcePath);
  if (snapshot == null) return;

  final output = _buildRegistryOutput(snapshot, generatedFrom: sourcePath);
  final target = File('lib/src/parser/data/parser_registry.g.dart')
    ..parent.createSync(recursive: true);
  target.writeAsStringSync(output);
  _formatGeneratedDart(target);
}

void _formatGeneratedDart(File target) {
  final result = Process.runSync(Platform.resolvedExecutable, [
    'format',
    target.path,
  ]);
  if (result.exitCode == 0) return;

  stderr
    ..write(result.stdout)
    ..write(result.stderr);
  exitCode = result.exitCode;
}

void _writeSnapshot(List<String> args) {
  if (args.length != 3) {
    _printUsage();
    exitCode = 64;
    return;
  }

  final outDir = Directory(args[1]);
  if (!outDir.existsSync()) {
    stderr.writeln('Tailwind spec out directory not found: ${outDir.path}');
    exitCode = 64;
    return;
  }

  final snapshot = _snapshotFromOutDir(outDir);
  final target = File(args[2])..parent.createSync(recursive: true);
  const encoder = JsonEncoder.withIndent('  ');
  target.writeAsStringSync('${encoder.convert(snapshot.toJson())}\n');
}

_RegistrySnapshot? _readSnapshot(String path) {
  final type = FileSystemEntity.typeSync(path);
  if (type == FileSystemEntityType.directory) {
    return _snapshotFromOutDir(Directory(path));
  }

  if (type == FileSystemEntityType.file) {
    return _snapshotFromFile(File(path));
  }

  stderr.writeln('Tailwind registry source not found: $path');
  exitCode = 64;
  return null;
}

_RegistrySnapshot _snapshotFromOutDir(Directory outDir) {
  final classList = (_readJson(outDir, 'class-list.json') as Map)
      .cast<String, Object?>();
  final variants = (_readJson(outDir, 'variants.json') as Map)
      .cast<String, Object?>();
  final probes = (_readJson(outDir, 'candidate-probes.json') as Map)
      .cast<String, Object?>();
  final staticScan = _readJson(outDir, 'static-utilities.scan.json');
  final functionalScan = _readJson(outDir, 'functional-utilities.scan.json');

  final staticUtilityRoots = <String>{
    ..._literalRegistrationNames(staticScan),
    ..._probeRoots(probes, kind: 'static'),
    ..._supportedStaticFallbackRoots(),
  };
  final functionalUtilityRoots = <String>{
    ..._literalRegistrationNames(functionalScan).map(_stripNegativeRoot),
    ..._probeRoots(probes, kind: 'functional'),
    ..._supportedFallbackRoots(classList),
  }..removeWhere((root) => root.isEmpty);

  final staticVariantRoots = <String>{};
  final functionalVariantRoots = <String>{};
  final compoundVariantRoots = <String>{};
  for (final variant in (variants['variants'] as List).cast<Object?>()) {
    final map = (variant as Map).cast<String, Object?>();
    final name = map['name']! as String;
    final values = (map['values'] as List?) ?? const [];
    final isArbitrary = map['isArbitrary'] == true;
    if (name == 'group' || name == 'peer' || name == 'not') {
      compoundVariantRoots.add(name);
    } else if (values.isNotEmpty || isArbitrary || name.startsWith('@')) {
      functionalVariantRoots.add(name);
    } else {
      staticVariantRoots.add(name);
    }
  }
  final meta =
      ((probes['meta'] ?? classList['meta'] ?? variants['meta']) as Map)
          .cast<String, Object?>();

  return _RegistrySnapshot(
    meta: _stableMeta(meta),
    staticUtilityRoots: staticUtilityRoots,
    functionalUtilityRoots: functionalUtilityRoots,
    staticVariantRoots: staticVariantRoots,
    functionalVariantRoots: functionalVariantRoots,
    compoundVariantRoots: compoundVariantRoots,
  );
}

_RegistrySnapshot _snapshotFromFile(File file) {
  final json = (jsonDecode(file.readAsStringSync()) as Map)
      .cast<String, Object?>();

  return _RegistrySnapshot(
    meta: ((json['meta'] ?? const {}) as Map).cast<String, Object?>(),
    staticUtilityRoots: _jsonStringSet(json, 'staticUtilityRoots'),
    functionalUtilityRoots: _jsonStringSet(json, 'functionalUtilityRoots'),
    staticVariantRoots: _jsonStringSet(json, 'staticVariantRoots'),
    functionalVariantRoots: _jsonStringSet(json, 'functionalVariantRoots'),
    compoundVariantRoots: _jsonStringSet(json, 'compoundVariantRoots'),
  );
}

String _buildRegistryOutput(
  _RegistrySnapshot snapshot, {
  required String generatedFrom,
}) {
  final meta = snapshot.meta;
  final staticUtilityRoots = snapshot.staticUtilityRoots;
  final functionalUtilityRoots = snapshot.functionalUtilityRoots;
  final staticVariantRoots = snapshot.staticVariantRoots;
  final functionalVariantRoots = snapshot.functionalVariantRoots;
  final compoundVariantRoots = snapshot.compoundVariantRoots;

  final output = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
    ..writeln('// Generated by tool/gen_registry.dart from $generatedFrom.')
    ..writeln('library;')
    ..writeln()
    ..writeln("import '../parser_registry.dart';")
    ..writeln()
    ..writeln(
      'const generatedTailwindRegistryMeta = <String, Object?>${_dartMap(meta)};',
    )
    ..writeln()
    ..writeln(
      'const generatedStaticUtilityRoots = <String>{${_dartStringSet(staticUtilityRoots)}};',
    )
    ..writeln()
    ..writeln(
      'const generatedFunctionalUtilityRoots = <String>{${_dartStringSet(functionalUtilityRoots)}};',
    )
    ..writeln()
    ..writeln(
      'const generatedStaticVariantRoots = <String>{${_dartStringSet(staticVariantRoots)}};',
    )
    ..writeln()
    ..writeln(
      'const generatedFunctionalVariantRoots = <String>{${_dartStringSet(functionalVariantRoots)}};',
    )
    ..writeln()
    ..writeln(
      'const generatedCompoundVariantRoots = <String>{${_dartStringSet(compoundVariantRoots)}};',
    )
    ..writeln()
    ..writeln('const defaultTailwindParserRegistry = TailwindParserRegistry(')
    ..writeln('  staticUtilityRoots: generatedStaticUtilityRoots,')
    ..writeln('  functionalUtilityRoots: generatedFunctionalUtilityRoots,')
    ..writeln(
      "  staticVariantRoots: {...generatedStaticVariantRoots, 'light'},",
    )
    ..writeln('  functionalVariantRoots: generatedFunctionalVariantRoots,')
    ..writeln('  compoundVariantRoots: generatedCompoundVariantRoots,')
    ..writeln(');');

  return output.toString();
}

void _printUsage() {
  stderr.writeln(
    'Usage: dart run tool/gen_registry.dart [snapshot-or-tailwind-out-dir]\n'
    '       dart run tool/gen_registry.dart --write-snapshot '
    '<tailwind-out-dir> <snapshot-file>',
  );
}

Object? _readJson(Directory dir, String name) {
  final file = File('${dir.path}/$name');
  return jsonDecode(file.readAsStringSync());
}

Set<String> _jsonStringSet(Map<String, Object?> json, String key) {
  return ((json[key] ?? const []) as List).cast<String>().toSet();
}

Map<String, Object?> _stableMeta(Map<String, Object?> meta) {
  final result = Map<String, Object?>.from(meta);
  result.remove('generatedAt');
  return result;
}

Iterable<String> _literalRegistrationNames(Object? json) sync* {
  for (final raw in (json as List?) ?? const []) {
    final map = (raw as Map).cast<String, Object?>();
    final name =
        (((map['metaVariables'] as Map?)?['single'] as Map?)?['NAME']
            as Map?)?['text'];
    if (name is! String || name.length < 2) continue;
    final quote = name[0];
    if ((quote == "'" || quote == '"' || quote == '`') &&
        name.endsWith(quote) &&
        !name.contains(r'$')) {
      yield name.substring(1, name.length - 1);
    }
  }
}

Iterable<String> _probeRoots(
  Map<String, Object?> probes, {
  required String kind,
}) sync* {
  for (final raw in (probes['probes'] as List).cast<Object?>()) {
    final map = (raw as Map).cast<String, Object?>();
    if (map['valid'] != true || map['utilityKind'] != kind) continue;
    final root = map['utilityRoot'];
    if (root is String) yield _stripNegativeRoot(root);
  }
}

Iterable<String> _supportedFallbackRoots(Map<String, Object?> classList) {
  final classNames = (classList['classList'] as List)
      .cast<List>()
      .map((row) => _stripNegativeRoot(row.first! as String))
      .toSet();

  const supported = {
    'p',
    'px',
    'py',
    'pt',
    'pr',
    'pb',
    'pl',
    'm',
    'mx',
    'my',
    'mt',
    'mr',
    'mb',
    'ml',
    'w',
    'h',
    'min-w',
    'min-h',
    'max-w',
    'max-h',
    'rounded',
    'rounded-t',
    'rounded-b',
    'rounded-l',
    'rounded-r',
    'rounded-tl',
    'rounded-tr',
    'rounded-bl',
    'rounded-br',
    'border',
    'border-t',
    'border-r',
    'border-b',
    'border-l',
    'border-x',
    'border-y',
    'bg-gradient',
    'from',
    'via',
    'to',
    'translate-x',
    'translate-y',
  };

  const keepEvenWhenMissingFromClassList = {'bg-gradient', 'from', 'via', 'to'};

  return supported.where((root) {
    if (keepEvenWhenMissingFromClassList.contains(root)) return true;
    final prefix = '$root-';
    return classNames.any((name) => name.startsWith(prefix));
  });
}

Iterable<String> _supportedStaticFallbackRoots() {
  return const {'overflow-hidden', 'overflow-visible', 'overflow-clip'};
}

String _stripNegativeRoot(String value) =>
    value.startsWith('-') ? value.substring(1) : value;

String _dartStringSet(Set<String> values) {
  final sorted = values.toList()..sort();
  if (sorted.isEmpty) return '';
  return '\n  ${sorted.map((value) => "'${_escape(value)}'").join(',\n  ')},\n';
}

String _dartMap(Map<String, Object?> values) {
  final entries = values.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  return '{\n  ${entries.map((entry) => "'${_escape(entry.key)}': ${_dartValue(entry.value)}").join(',\n  ')},\n}';
}

String _dartValue(Object? value) {
  return switch (value) {
    null => 'null',
    String() => "'${_escape(value)}'",
    num() || bool() => '$value',
    _ => "'${_escape('$value')}'",
  };
}

String _escape(String value) =>
    value.replaceAll(r'\', r'\\').replaceAll("'", r"\'");

final class _RegistrySnapshot {
  const _RegistrySnapshot({
    required this.meta,
    required this.staticUtilityRoots,
    required this.functionalUtilityRoots,
    required this.staticVariantRoots,
    required this.functionalVariantRoots,
    required this.compoundVariantRoots,
  });

  final Map<String, Object?> meta;
  final Set<String> staticUtilityRoots;
  final Set<String> functionalUtilityRoots;
  final Set<String> staticVariantRoots;
  final Set<String> functionalVariantRoots;
  final Set<String> compoundVariantRoots;

  Map<String, Object?> toJson() {
    return {
      'meta': _sortedMap(meta),
      'staticUtilityRoots': _sortedList(staticUtilityRoots),
      'functionalUtilityRoots': _sortedList(functionalUtilityRoots),
      'staticVariantRoots': _sortedList(staticVariantRoots),
      'functionalVariantRoots': _sortedList(functionalVariantRoots),
      'compoundVariantRoots': _sortedList(compoundVariantRoots),
    };
  }
}

Map<String, Object?> _sortedMap(Map<String, Object?> map) {
  return Map.fromEntries(
    map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
  );
}

List<String> _sortedList(Set<String> values) => values.toList()..sort();
