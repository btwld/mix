import 'dart:convert';
import 'dart:io';

const _defaultSnapshotPath = 'tool/tailwind_parser_registry_snapshot.json';
const _themeSnapshotPath = 'tool/tailwind_theme_snapshot.json';
const _registryTargetPath = 'lib/src/parser/data/parser_registry.g.dart';
const _ledgerTargetPath = 'lib/src/parser/data/compatibility_ledger.g.dart';
const _themeTargetPath = 'lib/src/theme/data/default_theme.g.dart';
const _expectedThemeSchemaVersion = 1;
const _expectedTailwindVersion = '4.3.1';

const _expectedRegistryMeta = <String, Object?>{
  'cssEntry': 'fixtures/app.css',
  'tailwindGitSha': '8a14a710102cae195f6811e8578bef9477bc6be9',
  'tailwindGitTag': 'v4.3.1',
  'tailwindInstalledVersion': '4.3.1',
};

// This fingerprint makes the implicit "all other pinned roots are unsupported"
// policy closed over one exact Tailwind inventory. Updating the snapshot cannot
// silently classify new roots as unsupported: the generator fails until this
// fingerprint and the explicit implemented/adapted/ignored decisions are
// reviewed together.
const _expectedInventoryFingerprint = '2f608800c4eb26fc';

// Runtime parser extensions that are intentionally not present in the pinned
// Tailwind registry snapshot. Keep registry generation, compatibility
// accounting, and policy validation on this single source of truth.
const _parserRegistryStaticVariantExtensions = {'light'};

void main(List<String> args) {
  if (args.isNotEmpty && args.first == '--write-snapshot') {
    _writeSnapshot(args);

    return;
  }

  final check = args.isNotEmpty && args.first == '--check';
  final sourceArgs = check ? args.sublist(1) : args;
  if (sourceArgs.length > 1) {
    _printUsage();
    exitCode = 64;

    return;
  }

  final sourcePath = sourceArgs.isEmpty
      ? _defaultSnapshotPath
      : sourceArgs.single;
  final snapshot = _readSnapshot(sourcePath);
  if (snapshot == null) return;
  if (!_validateCompatibilityPolicy(snapshot)) return;
  final themeSnapshot = _readThemeSnapshot();
  if (themeSnapshot == null) return;
  if (!_validateThemeSnapshot(themeSnapshot, snapshot)) return;

  final outputs = {
    _registryTargetPath: _buildRegistryOutput(
      snapshot,
      generatedFrom: sourcePath,
    ),
    _ledgerTargetPath: _buildCompatibilityLedgerOutput(
      snapshot,
      generatedFrom: sourcePath,
    ),
    _themeTargetPath: _buildThemeOutput(
      themeSnapshot,
      generatedFrom: _themeSnapshotPath,
    ),
  };

  for (final entry in outputs.entries) {
    if (check) {
      _checkGeneratedDart(entry.key, entry.value);
    } else {
      _writeGeneratedDart(entry.key, entry.value);
    }
  }
}

_ThemeSnapshot? _readThemeSnapshot() {
  final file = File(_themeSnapshotPath);
  if (!file.existsSync()) {
    stderr.writeln('Tailwind theme snapshot not found: $_themeSnapshotPath');
    exitCode = 64;

    return null;
  }

  final json = (jsonDecode(file.readAsStringSync()) as Map)
      .cast<String, Object?>();

  return _ThemeSnapshot(
    meta: ((json['meta'] ?? const {}) as Map).cast(),
    namespaces: ((json['namespaces'] ?? const {}) as Map).cast(),
  );
}

bool _validateThemeSnapshot(_ThemeSnapshot theme, _RegistrySnapshot registry) {
  final errors = <String>[];
  if (theme.meta['schemaVersion'] != _expectedThemeSchemaVersion) {
    errors.add(
      'expected theme schema $_expectedThemeSchemaVersion, '
      "got ${theme.meta['schemaVersion'] ?? 'null'}",
    );
  }
  if (theme.meta['package'] != '@tailwindcss/browser') {
    errors.add(
      'expected theme package @tailwindcss/browser, '
      "got ${theme.meta['package'] ?? 'null'}",
    );
  }
  final themeVersion = theme.meta['tailwindVersion'];
  final parserVersion = registry.meta['tailwindInstalledVersion'];
  if (themeVersion != _expectedTailwindVersion) {
    errors.add(
      'expected theme Tailwind $_expectedTailwindVersion, '
      "got ${themeVersion ?? 'null'}",
    );
  }
  if (parserVersion != themeVersion) {
    errors.add(
      'parser/theme Tailwind versions differ: '
      "${parserVersion ?? 'null'} / ${themeVersion ?? 'null'}",
    );
  }

  const expectedNamespaces = {
    'spacing',
    'radii',
    'borderWidths',
    'breakpoints',
    'fontSizes',
    'fontLineHeights',
    'colors',
    'durations',
    'delays',
    'scales',
    'rotations',
    'blurs',
    'leading',
    'tracking',
  };
  final actualNamespaces = theme.namespaces.keys.toSet();
  if (actualNamespaces.length != expectedNamespaces.length ||
      !actualNamespaces.containsAll(expectedNamespaces)) {
    errors.add(
      'theme namespaces differ: expected $expectedNamespaces, '
      'got $actualNamespaces',
    );
  }

  for (final namespace in expectedNamespaces.difference({'colors'})) {
    final values = theme.namespace(namespace);
    if (values.isEmpty || values.values.any((value) => value is! num)) {
      errors.add('theme namespace $namespace must contain numeric values');
    }
  }
  final colors = theme.namespace('colors');
  if (colors.length != 289 || colors['transparent'] != '#00000000') {
    errors.add(
      'expected 288 Tailwind colors plus transparent, got ${colors.length}',
    );
  }
  if (colors.values.any(
    (value) =>
        value is! String ||
        !RegExp(r'^#[0-9A-F]{6}([0-9A-F]{2})?$').hasMatch(value),
  )) {
    errors.add('theme colors must use uppercase #RRGGBB or #RRGGBBAA');
  }

  if (errors.isEmpty) return true;
  for (final error in errors) {
    stderr.writeln('Invalid Tailwind theme snapshot: $error.');
  }
  exitCode = 1;

  return false;
}

void _writeGeneratedDart(String path, String output) {
  final target = File(path)..parent.createSync(recursive: true);
  target.writeAsStringSync(output);
  _formatGeneratedDart(target);
}

void _checkGeneratedDart(String path, String output) {
  final target = File(path);
  // Keep the temporary source in the package so `dart format` resolves the
  // same package language version for both files.
  final tempDir = target.parent.createTempSync('.mix_winds_registry_check_');
  try {
    final temporary = File(
      '${tempDir.path}/${File(path).uri.pathSegments.last}',
    )..writeAsStringSync(output);
    if (!_formatGeneratedDart(temporary)) return;

    if (!target.existsSync() ||
        target.readAsStringSync() != temporary.readAsStringSync()) {
      stderr.writeln(
        'Generated file is stale: $path\n'
        'Run: dart run tool/gen_registry.dart',
      );
      exitCode = 1;
    }
  } finally {
    tempDir.deleteSync(recursive: true);
  }
}

bool _formatGeneratedDart(File target) {
  final result = Process.runSync(Platform.resolvedExecutable, [
    'format',
    target.path,
  ]);
  if (result.exitCode == 0) return true;

  stderr
    ..write(result.stdout)
    ..write(result.stderr);
  exitCode = result.exitCode;

  return false;
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
  if (type == .directory) {
    return _snapshotFromOutDir(Directory(path));
  }

  if (type == .file) {
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
  final variantEntries = (variants['variants'] as List).cast<Object?>();
  for (final variant in variantEntries) {
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
    meta: ((json['meta'] ?? const {}) as Map).cast(),
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
      '  staticVariantRoots: {...generatedStaticVariantRoots, '
      '${_dartInlineStringElements(_parserRegistryStaticVariantExtensions)}},',
    )
    ..writeln('  functionalVariantRoots: generatedFunctionalVariantRoots,')
    ..writeln('  compoundVariantRoots: generatedCompoundVariantRoots,')
    ..writeln(');');

  return output.toString();
}

String _buildThemeOutput(
  _ThemeSnapshot snapshot, {
  required String generatedFrom,
}) {
  final output = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
    ..writeln('// Generated by tool/gen_registry.dart from $generatedFrom.')
    ..writeln('library;')
    ..writeln()
    ..writeln("import 'package:flutter/material.dart';")
    ..writeln()
    ..write(
      _dartNumericMapDeclaration(
        'twDefaultSpacing',
        snapshot.namespace('spacing'),
        valueType: 'double',
      ),
    )
    ..write(
      _dartNumericMapDeclaration(
        'twDefaultRadii',
        snapshot.namespace('radii'),
        valueType: 'double',
      ),
    )
    ..write(
      _dartNumericMapDeclaration(
        'twDefaultBorderWidths',
        snapshot.namespace('borderWidths'),
        valueType: 'double',
      ),
    )
    ..write(
      _dartNumericMapDeclaration(
        'twDefaultBreakpoints',
        snapshot.namespace('breakpoints'),
        valueType: 'double',
      ),
    )
    ..write(
      _dartNumericMapDeclaration(
        'twDefaultFontSizes',
        snapshot.namespace('fontSizes'),
        valueType: 'double',
      ),
    )
    ..write(
      _dartNumericMapDeclaration(
        'twDefaultLineHeights',
        snapshot.namespace('fontLineHeights'),
        valueType: 'double',
      ),
    )
    ..write(_dartColorMapDeclaration(snapshot.namespace('colors')))
    ..write(
      _dartNumericMapDeclaration(
        'twDefaultDurations',
        snapshot.namespace('durations'),
        valueType: 'int',
      ),
    )
    ..write(
      _dartNumericMapDeclaration(
        'twDefaultDelays',
        snapshot.namespace('delays'),
        valueType: 'int',
      ),
    )
    ..write(
      _dartNumericMapDeclaration(
        'twDefaultScales',
        snapshot.namespace('scales'),
        valueType: 'double',
      ),
    )
    ..write(
      _dartNumericMapDeclaration(
        'twDefaultRotations',
        snapshot.namespace('rotations'),
        valueType: 'double',
      ),
    )
    ..write(
      _dartNumericMapDeclaration(
        'twDefaultBlurs',
        snapshot.namespace('blurs'),
        valueType: 'double',
      ),
    )
    ..write(
      _dartNumericMapDeclaration(
        'twDefaultLeading',
        snapshot.namespace('leading'),
        valueType: 'double',
      ),
    )
    ..write(
      _dartNumericMapDeclaration(
        'twDefaultTracking',
        snapshot.namespace('tracking'),
        valueType: 'double',
      ),
    );

  return output.toString();
}

String _dartNumericMapDeclaration(
  String name,
  Map<String, Object?> values, {
  required String valueType,
}) {
  final output = StringBuffer()..writeln('const $name = <String, $valueType>{');
  for (final entry in values.entries) {
    final value = entry.value;
    if (value is! num || (valueType == 'int' && value is! int)) {
      throw FormatException('Invalid $valueType value for $name.${entry.key}');
    }
    output.writeln("  '${_escape(entry.key)}': $value,");
  }

  return (output
        ..writeln('};')
        ..writeln())
      .toString();
}

String _dartColorMapDeclaration(Map<String, Object?> values) {
  final output = StringBuffer()
    ..writeln('const twDefaultColors = <String, Color>{');
  for (final entry in values.entries) {
    output.writeln(
      "  '${_escape(entry.key)}': ${_dartColor(entry.value as String)},",
    );
  }

  return (output
        ..writeln('};')
        ..writeln())
      .toString();
}

String _dartColor(String hex) {
  final channels = hex.substring(1);
  final argb = channels.length == 6
      ? 'FF$channels'
      : '${channels.substring(6)}${channels.substring(0, 6)}';

  return 'Color(0x$argb)';
}

String _buildCompatibilityLedgerOutput(
  _RegistrySnapshot snapshot, {
  required String generatedFrom,
}) {
  final utilityEntries = <_CompatibilityEntry>[
    for (final root in snapshot.staticUtilityRoots)
      _compatibilityEntry(.staticUtility, root),
    for (final root in snapshot.functionalUtilityRoots)
      _compatibilityEntry(.functionalUtility, root),
  ]..sort(_compareCompatibilityEntries);
  final variantEntries = <_CompatibilityEntry>[
    for (final root in {
      ...snapshot.staticVariantRoots,
      ..._parserRegistryStaticVariantExtensions,
    })
      _compatibilityEntry(.staticVariant, root),
    for (final root in snapshot.functionalVariantRoots)
      _compatibilityEntry(.functionalVariant, root),
    for (final root in snapshot.compoundVariantRoots)
      _compatibilityEntry(.compoundVariant, root),
  ]..sort(_compareCompatibilityEntries);

  final output = StringBuffer()
    ..writeln('// GENERATED CODE - DO NOT MODIFY BY HAND.')
    ..writeln('// Generated by tool/gen_registry.dart from $generatedFrom.')
    ..writeln('library;')
    ..writeln()
    ..writeln('enum TailwindCompatibilityStatus {')
    ..writeln('  implemented,')
    ..writeln('  adapted,')
    ..writeln('  unsupported,')
    ..writeln('  ignoredByDesign;')
    ..writeln()
    ..writeln('  String get label => switch (this) {')
    ..writeln("    implemented => 'implemented',")
    ..writeln("    adapted => 'adapted',")
    ..writeln("    unsupported => 'unsupported',")
    ..writeln("    ignoredByDesign => 'ignored-by-design',")
    ..writeln('  };');
  output
    ..writeln('}')
    ..writeln()
    ..writeln('enum TailwindRegistryRootKind {')
    ..writeln('  staticUtility,')
    ..writeln('  functionalUtility,')
    ..writeln('  staticVariant,')
    ..writeln('  functionalVariant,')
    ..writeln('  compoundVariant,');
  output
    ..writeln('}')
    ..writeln()
    ..writeln('final class TailwindCompatibilityEntry {')
    ..writeln('  const TailwindCompatibilityEntry(')
    ..writeln('    this.root,')
    ..writeln('    this.kind,')
    ..writeln('    this.status, {')
    ..writeln('    this.reason,')
    ..writeln('  });')
    ..writeln()
    ..writeln('  final String root;')
    ..writeln('  final TailwindRegistryRootKind kind;')
    ..writeln('  final TailwindCompatibilityStatus status;')
    ..writeln('  final String? reason;');
  output
    ..writeln('}')
    ..writeln()
    ..writeln(
      'const generatedTailwindCompatibilityMeta = '
      '<String, Object?>${_dartMap(snapshot.meta)};',
    )
    ..writeln()
    ..writeln(
      "const generatedTailwindCompatibilityInventoryFingerprint = '"
      "${_inventoryFingerprint(snapshot)}';",
    )
    ..writeln()
    ..writeln(
      'const generatedTailwindUtilityCompatibilityLedger = '
      '<TailwindCompatibilityEntry>[',
    )
    ..write(_dartCompatibilityEntries(utilityEntries));
  output
    ..writeln('];')
    ..writeln()
    ..writeln(
      'const generatedTailwindVariantCompatibilityLedger = '
      '<TailwindCompatibilityEntry>[',
    )
    ..write(_dartCompatibilityEntries(variantEntries));
  output.writeln('];');

  return output.toString();
}

int _compareCompatibilityEntries(
  _CompatibilityEntry left,
  _CompatibilityEntry right,
) {
  final kind = left.kind.index.compareTo(right.kind.index);

  return kind != 0 ? kind : left.root.compareTo(right.root);
}

String _dartCompatibilityEntries(List<_CompatibilityEntry> entries) {
  return entries.map((entry) {
    final reason = entry.reason == null
        ? ''
        : ", reason: '${_escape(entry.reason!)}'";

    return "  TailwindCompatibilityEntry('${_escape(entry.root)}', "
        '.${entry.kind.name}, .${entry.status.name}$reason),\n';
  }).join();
}

_CompatibilityEntry _compatibilityEntry(_RegistryRootKind kind, String root) {
  final implemented = switch (kind) {
    .staticUtility => _implementedStaticUtilityRoots,
    .functionalUtility => _implementedFunctionalUtilityRoots,
    .staticVariant => _implementedStaticVariantRoots,
    .functionalVariant || .compoundVariant => const <String>{},
  };
  if (implemented.contains(root)) {
    return _CompatibilityEntry(root: root, kind: kind, status: .implemented);
  }

  final adapted = switch (kind) {
    .staticUtility => _adaptedStaticUtilityReasons,
    .functionalUtility => _adaptedFunctionalUtilityReasons,
    .staticVariant => _adaptedStaticVariantReasons,
    .functionalVariant => const <String, String>{},
    .compoundVariant => _adaptedCompoundVariantReasons,
  };
  final adaptationReason = adapted[root];
  if (adaptationReason != null) {
    return _CompatibilityEntry(
      root: root,
      kind: kind,
      status: .adapted,
      reason: adaptationReason,
    );
  }

  final ignored = switch (kind) {
    .functionalVariant => _ignoredFunctionalVariantReasons,
    .compoundVariant => _ignoredCompoundVariantReasons,
    .staticUtility ||
    .functionalUtility ||
    .staticVariant => const <String, String>{},
  };
  final ignoredReason = ignored[root];
  if (ignoredReason != null) {
    return _CompatibilityEntry(
      root: root,
      kind: kind,
      status: .ignoredByDesign,
      reason: ignoredReason,
    );
  }

  return _CompatibilityEntry(root: root, kind: kind, status: .unsupported);
}

bool _validateCompatibilityPolicy(_RegistrySnapshot snapshot) {
  var valid = true;

  if (jsonEncode(_sortedMap(snapshot.meta)) !=
      jsonEncode(_sortedMap(_expectedRegistryMeta))) {
    stderr.writeln(
      'Tailwind registry metadata drifted. Expected '
      '${jsonEncode(_expectedRegistryMeta)}, got ${jsonEncode(snapshot.meta)}.',
    );
    valid = false;
  }

  final utilityCount =
      snapshot.staticUtilityRoots.length +
      snapshot.functionalUtilityRoots.length;
  final variantCount =
      snapshot.staticVariantRoots.length +
      snapshot.functionalVariantRoots.length +
      snapshot.compoundVariantRoots.length;
  if (utilityCount != 599 || variantCount != 90) {
    stderr.writeln(
      'Tailwind registry count drifted: expected 599 utility and 90 variant '
      'registrations, got $utilityCount and $variantCount.',
    );
    valid = false;
  }

  final fingerprint = _inventoryFingerprint(snapshot);
  if (fingerprint != _expectedInventoryFingerprint) {
    stderr.writeln(
      'Tailwind registry inventory drifted: expected '
      '$_expectedInventoryFingerprint, got $fingerprint. Review every new or '
      'changed root before updating the compatibility policy.',
    );
    valid = false;
  }

  final inventory = <String>{
    for (final root in snapshot.staticUtilityRoots)
      _policyKey(.staticUtility, root),
    for (final root in snapshot.functionalUtilityRoots)
      _policyKey(.functionalUtility, root),
    for (final root in snapshot.staticVariantRoots)
      _policyKey(.staticVariant, root),
    for (final root in _parserRegistryStaticVariantExtensions)
      _policyKey(.staticVariant, root),
    for (final root in snapshot.functionalVariantRoots)
      _policyKey(.functionalVariant, root),
    for (final root in snapshot.compoundVariantRoots)
      _policyKey(.compoundVariant, root),
  };
  final decisions = <String>{};
  for (final decision in _explicitCompatibilityDecisions()) {
    final key = _policyKey(decision.kind, decision.root);
    if (!inventory.contains(key)) {
      stderr.writeln('Compatibility policy references an unknown root: $key.');
      valid = false;
    }
    if (!decisions.add(key)) {
      stderr.writeln('Compatibility policy classifies a root twice: $key.');
      valid = false;
    }
  }

  if (!valid) exitCode = 1;

  return valid;
}

Iterable<_PolicyDecision> _explicitCompatibilityDecisions() sync* {
  for (final root in _implementedStaticUtilityRoots) {
    yield _PolicyDecision(.staticUtility, root);
  }
  for (final root in _adaptedStaticUtilityReasons.keys) {
    yield _PolicyDecision(.staticUtility, root);
  }
  for (final root in _implementedFunctionalUtilityRoots) {
    yield _PolicyDecision(.functionalUtility, root);
  }
  for (final root in _adaptedFunctionalUtilityReasons.keys) {
    yield _PolicyDecision(.functionalUtility, root);
  }
  for (final root in _implementedStaticVariantRoots) {
    yield _PolicyDecision(.staticVariant, root);
  }
  for (final root in _adaptedStaticVariantReasons.keys) {
    yield _PolicyDecision(.staticVariant, root);
  }
  for (final root in _adaptedCompoundVariantReasons.keys) {
    yield _PolicyDecision(.compoundVariant, root);
  }
  for (final root in _ignoredFunctionalVariantReasons.keys) {
    yield _PolicyDecision(.functionalVariant, root);
  }
  for (final root in _ignoredCompoundVariantReasons.keys) {
    yield _PolicyDecision(.compoundVariant, root);
  }
}

String _policyKey(_RegistryRootKind kind, String root) => '${kind.name}:$root';

String _inventoryFingerprint(_RegistrySnapshot snapshot) {
  final effectiveInventory = snapshot.toJson()
    ..['parserRegistryStaticVariantExtensions'] = _sortedList(
      _parserRegistryStaticVariantExtensions,
    );
  final bytes = utf8.encode(jsonEncode(effectiveInventory));
  var hash = 0xcbf29ce484222325;
  for (final byte in bytes) {
    hash ^= byte;
    hash = (hash * 0x100000001b3) & 0xffffffffffffffff;
  }

  return hash.toRadixString(16).padLeft(16, '0');
}

const _implementedStaticUtilityRoots = {
  'basis-auto',
  'capitalize',
  'flex',
  'flex-col',
  'flex-row',
  'inline-flex',
  'items-baseline',
  'items-center',
  'items-end',
  'items-start',
  'items-stretch',
  'justify-around',
  'justify-between',
  'justify-center',
  'justify-end',
  'justify-evenly',
  'justify-start',
  'lowercase',
  'overflow-clip',
  'overflow-hidden',
  'overflow-visible',
  'self-center',
  'self-end',
  'self-start',
  'text-center',
  'text-end',
  'text-justify',
  'text-left',
  'text-right',
  'text-start',
  'uppercase',
};

const _adaptedStaticUtilityReasons = {
  'flex-auto':
      'Flutter flex parent-data adaptation; see FLUTTER_ADAPTATIONS.md '
      '(Key Behavioral Differences).',
  'flex-initial':
      'Flutter flex parent-data adaptation; see FLUTTER_ADAPTATIONS.md '
      '(Key Behavioral Differences).',
  'flex-none':
      'Flutter flex parent-data adaptation; see FLUTTER_ADAPTATIONS.md '
      '(Key Behavioral Differences).',
  'h-auto':
      'Clears Flutter height constraints to represent CSS auto sizing; see '
      'FLUTTER_ADAPTATIONS.md (Compatibility Ledger Status Notes).',
  'h-screen':
      'Resolved from live Flutter constraints; see FLUTTER_ADAPTATIONS.md '
      '(Parser and Variant Adaptations).',
  'min-h-screen':
      'Resolved from live Flutter constraints; see FLUTTER_ADAPTATIONS.md '
      '(Parser and Variant Adaptations).',
  'min-w-screen':
      'Resolved from live Flutter constraints; see FLUTTER_ADAPTATIONS.md '
      '(Parser and Variant Adaptations).',
  'truncate':
      'Flutter text requires explicit flex constraints; see '
      'FLUTTER_ADAPTATIONS.md (Text Truncation in Flex Containers).',
  'w-auto':
      'Clears Flutter width constraints to represent CSS auto sizing; see '
      'FLUTTER_ADAPTATIONS.md (Compatibility Ledger Status Notes).',
  'w-screen':
      'Resolved from live Flutter constraints; see FLUTTER_ADAPTATIONS.md '
      '(Parser and Variant Adaptations).',
};

const _implementedFunctionalUtilityRoots = {
  'blur',
  'border',
  'border-b',
  'border-l',
  'border-r',
  'border-t',
  'border-x',
  'border-y',
  'delay',
  'duration',
  'ease',
  'font',
  'gap',
  'gap-x',
  'gap-y',
  'leading',
  'opacity',
  'p',
  'pb',
  'pl',
  'pr',
  'pt',
  'px',
  'py',
  'rotate',
  'rounded',
  'rounded-b',
  'rounded-bl',
  'rounded-br',
  'rounded-l',
  'rounded-r',
  'rounded-t',
  'rounded-tl',
  'rounded-tr',
  'scale',
  'shadow',
  'text-shadow',
  'tracking',
  'transition',
};

const _adaptedFunctionalUtilityReasons = {
  'basis':
      'Only Flutter-representable basis values are supported; see '
      'FLUTTER_ADAPTATIONS.md (Flex Basis Fractions).',
  'bg':
      'Color alpha and arbitrary values use Flutter representations; see '
      'FLUTTER_ADAPTATIONS.md (Parser and Variant Adaptations).',
  'bg-gradient':
      'Accumulated into a Flutter LinearGradientMix; see '
      'FLUTTER_ADAPTATIONS.md (Parser and Variant Adaptations).',
  'bg-linear':
      'Accumulated into a Flutter LinearGradientMix; see '
      'FLUTTER_ADAPTATIONS.md (Parser and Variant Adaptations).',
  'flex':
      'Flutter flex parent-data adaptation; see FLUTTER_ADAPTATIONS.md '
      '(flex-1 Behavior).',
  'from':
      'Accumulated into a Flutter LinearGradientMix; see '
      'FLUTTER_ADAPTATIONS.md (Parser and Variant Adaptations).',
  'grow':
      'Flutter flex parent-data adaptation; see FLUTTER_ADAPTATIONS.md '
      '(Key Behavioral Differences).',
  'h':
      'Percent and live-constraint sizing are adapted; see '
      'FLUTTER_ADAPTATIONS.md (Percent-Based Sizing).',
  'm':
      'Margin is applied outside the semantic box; see '
      'FLUTTER_ADAPTATIONS.md (Parser and Variant Adaptations).',
  'max-h':
      'Percent and live-constraint sizing are adapted; see '
      'FLUTTER_ADAPTATIONS.md (Percent-Based Sizing).',
  'max-w':
      'Percent and live-constraint sizing are adapted; see '
      'FLUTTER_ADAPTATIONS.md (Percent-Based Sizing).',
  'mb':
      'Margin is applied outside the semantic box; see '
      'FLUTTER_ADAPTATIONS.md (Text Block Margin Variants).',
  'min-h':
      'Percent and live-constraint sizing are adapted; see '
      'FLUTTER_ADAPTATIONS.md (Percent-Based Sizing).',
  'min-w':
      'Percent and live-constraint sizing are adapted; see '
      'FLUTTER_ADAPTATIONS.md (Percent-Based Sizing).',
  'ml':
      'Margin is applied outside the semantic box; see '
      'FLUTTER_ADAPTATIONS.md (Text Block Margin Variants).',
  'mr':
      'Margin is applied outside the semantic box; see '
      'FLUTTER_ADAPTATIONS.md (Text Block Margin Variants).',
  'mt':
      'Margin is applied outside the semantic box; see '
      'FLUTTER_ADAPTATIONS.md (Text Block Margin Variants).',
  'mx':
      'Margin is applied outside the semantic box; see '
      'FLUTTER_ADAPTATIONS.md (Text Block Margin Variants).',
  'my':
      'Margin is applied outside the semantic box; see '
      'FLUTTER_ADAPTATIONS.md (Text Block Margin Variants).',
  'shrink':
      'Flutter flex parent-data adaptation; see FLUTTER_ADAPTATIONS.md '
      '(Key Behavioral Differences).',
  'text':
      'Typography defaults and arbitrary colors use Flutter representations; '
      'see FLUTTER_ADAPTATIONS.md (Default Typography Parity).',
  'to':
      'Accumulated into a Flutter LinearGradientMix; see '
      'FLUTTER_ADAPTATIONS.md (Parser and Variant Adaptations).',
  'translate-x':
      'Percent translation is not representable as a Mix transform; see '
      'FLUTTER_ADAPTATIONS.md (Translate with Fractions/Percent).',
  'translate-y':
      'Percent translation is not representable as a Mix transform; see '
      'FLUTTER_ADAPTATIONS.md (Translate with Fractions/Percent).',
  'via':
      'Accumulated into a Flutter LinearGradientMix; see '
      'FLUTTER_ADAPTATIONS.md (Parser and Variant Adaptations).',
  'w':
      'Percent and live-constraint sizing are adapted; see '
      'FLUTTER_ADAPTATIONS.md (Percent-Based Sizing).',
};

const _implementedStaticVariantRoots = {
  '2xl',
  'disabled',
  'enabled',
  'focus',
  'hover',
  'lg',
  'md',
  'sm',
  'xl',
};

const _adaptedStaticVariantReasons = {
  'active':
      'Mapped to Mix pressed state; see FLUTTER_ADAPTATIONS.md '
      '(Compatibility Ledger Status Notes).',
  'dark':
      'Mapped to Flutter platform brightness; see FLUTTER_ADAPTATIONS.md '
      '(Compatibility Ledger Status Notes).',
  'focus-visible':
      "Mapped to Mix's focus-visible state using Flutter's app-wide input "
      'modality; encoded through the Mix Protocol v1 context_focus_visible selector; '
      'see FLUTTER_ADAPTATIONS.md (Compatibility Ledger Status Notes).',
  'light':
      'Mapped to Flutter platform brightness; see FLUTTER_ADAPTATIONS.md '
      '(Compatibility Ledger Status Notes).',
};

const _adaptedCompoundVariantReasons = {
  'not':
      'Only not-hover is mapped to a Mix runtime state; other not-* variants '
      'remain unsupported; see FLUTTER_ADAPTATIONS.md '
      '(Compatibility Ledger Status Notes).',
};

const _ignoredFunctionalVariantReasons = {
  '@':
      'Container-query variants have no styler-payload equivalent; see '
      'FLUTTER_ADAPTATIONS.md (Parser and Variant Adaptations).',
  '@max':
      'Container-query variants have no styler-payload equivalent; see '
      'FLUTTER_ADAPTATIONS.md (Parser and Variant Adaptations).',
  '@min':
      'Container-query variants have no styler-payload equivalent; see '
      'FLUTTER_ADAPTATIONS.md (Parser and Variant Adaptations).',
};

const _ignoredCompoundVariantReasons = {
  'group':
      'Selector-relative group state has no widget-API equivalent; see '
      'FLUTTER_ADAPTATIONS.md (Parser and Variant Adaptations).',
  'peer':
      'Selector-relative peer state has no widget-API equivalent; see '
      'FLUTTER_ADAPTATIONS.md (Parser and Variant Adaptations).',
};

void _printUsage() {
  stderr.writeln(
    'Usage: dart run tool/gen_registry.dart [snapshot-or-tailwind-out-dir]\n'
    '       dart run tool/gen_registry.dart --check '
    '[snapshot-or-tailwind-out-dir]\n'
    '       dart run tool/gen_registry.dart --write-snapshot '
    '<tailwind-out-dir> <snapshot-file>',
  );
}

Object _readJson(Directory dir, String name) {
  final file = File('${dir.path}/$name');

  return jsonDecode(file.readAsStringSync())!;
}

Set<String> _jsonStringSet(Map<String, Object?> json, String key) {
  return ((json[key] ?? const []) as List).cast<String>().toSet();
}

Map<String, Object?> _stableMeta(Map<String, Object?> meta) {
  final result = Map<String, Object?>.of(meta);
  result.remove('generatedAt');

  return result;
}

Iterable<String> _literalRegistrationNames(Object json) sync* {
  for (final raw in json as List) {
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
  final probeEntries = (probes['probes'] as List).cast<Object?>();
  for (final raw in probeEntries) {
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

String _dartInlineStringElements(Set<String> values) {
  final sorted = values.toList()..sort();

  return sorted.map((value) => "'${_escape(value)}'").join(', ');
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
  final Map<String, Object?> meta;

  final Set<String> staticUtilityRoots;
  final Set<String> functionalUtilityRoots;
  final Set<String> staticVariantRoots;
  final Set<String> functionalVariantRoots;
  final Set<String> compoundVariantRoots;
  const _RegistrySnapshot({
    required this.meta,
    required this.staticUtilityRoots,
    required this.functionalUtilityRoots,
    required this.staticVariantRoots,
    required this.functionalVariantRoots,
    required this.compoundVariantRoots,
  });

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

final class _ThemeSnapshot {
  final Map<String, Object?> meta;

  final Map<String, Object?> namespaces;
  const _ThemeSnapshot({required this.meta, required this.namespaces});

  Map<String, Object?> namespace(String name) {
    return ((namespaces[name] ?? const {}) as Map).cast();
  }
}

Map<String, Object?> _sortedMap(Map<String, Object?> map) {
  return Map.fromEntries(
    map.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
  );
}

List<String> _sortedList(Set<String> values) => values.toList()..sort();

enum _RegistryRootKind {
  staticUtility,
  functionalUtility,
  staticVariant,
  functionalVariant,
  compoundVariant,
}

enum _CompatibilityStatus { implemented, adapted, unsupported, ignoredByDesign }

final class _CompatibilityEntry {
  final String root;

  final _RegistryRootKind kind;
  final _CompatibilityStatus status;
  final String? reason;
  const _CompatibilityEntry({
    required this.root,
    required this.kind,
    required this.status,
    this.reason,
  });
}

final class _PolicyDecision {
  final _RegistryRootKind kind;

  final String root;
  const _PolicyDecision(this.kind, this.root);
}
