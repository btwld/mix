import 'dart:convert';
import 'dart:io';

const _defaultOutputPath = 'build/web/previews-manifest.json';
const _registryPath = 'lib/preview_registry.dart';
const _packageRegistryPath =
    'packages/mix_docs_preview/lib/preview_registry.dart';

void main(List<String> args) {
  final outputPath = _readOutputPath(args) ?? _defaultOutputPath;
  final registryFile = _resolveRegistryFile().absolute;
  final packageDir = registryFile.parent.parent;
  // Project root: from package dir (e.g. packages/mix_docs_preview) go up to repo root
  final projectRoot = packageDir.parent.parent.path;

  final registrySource = registryFile.readAsStringSync();
  final constantMap = _parseStringConstants(registrySource);
  final entries = _parsePreviewEntries(registrySource, constantMap);

  _validateEntries(entries, projectRoot);

  final manifest = <String, Object?>{
    'version': 1,
    'generatedAt': DateTime.now().toUtc().toIso8601String(),
    'entries': entries,
  };

  final outputFile = File(outputPath);
  outputFile.parent.createSync(recursive: true);
  outputFile.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(manifest)}\n',
  );

  stdout.writeln('Generated previews manifest: ${outputFile.path}');
  stdout.writeln('Entries: ${entries.length}');
}

File _resolveRegistryFile() {
  final local = File(_registryPath);
  if (local.existsSync()) {
    return local;
  }

  final pkg = File(_packageRegistryPath);
  if (pkg.existsSync()) {
    return pkg;
  }

  throw StateError(
    'Preview registry not found. Tried "$_registryPath" and '
    '"$_packageRegistryPath".',
  );
}

String? _readOutputPath(List<String> args) {
  for (var i = 0; i < args.length; i++) {
    if (args[i] == '--output' && i + 1 < args.length) {
      return args[i + 1];
    }

    if (args[i].startsWith('--output=')) {
      return args[i].substring('--output='.length);
    }
  }

  return null;
}

Map<String, String> _parseStringConstants(String source) {
  final result = <String, String>{};
  final constantPattern = RegExp(
    r"static const String\s+([a-zA-Z0-9_]+)\s*=\s*'([^']*)';",
  );

  for (final match in constantPattern.allMatches(source)) {
    result[match.group(1)!] = match.group(2)!;
  }

  return result;
}

List<Map<String, Object?>> _parsePreviewEntries(
  String source,
  Map<String, String> constantMap,
) {
  final entryBlocks = _extractPreviewEntryBlocks(source);
  final entries = <Map<String, Object?>>[];

  for (var index = 0; index < entryBlocks.length; index++) {
    final block = entryBlocks[index];
    final previewId = _extractStringField(block, 'previewId');
    final sourcePath = _extractStringField(block, 'sourcePath');

    if (previewId == null || sourcePath == null) {
      throw StateError(
        'Failed to parse previewId/sourcePath in PreviewEntry #$index. '
        'Use string literals for both fields.',
      );
    }

    final title = _extractStringField(block, 'title');
    final description = _extractStringField(block, 'description');
    final categoryToken = _extractTokenField(block, 'category');
    final category = _resolveCategory(categoryToken, constantMap);
    final snippetRegion = _extractStringField(block, 'snippetRegion');
    final renderable = _extractBoolField(block, 'renderable') ?? true;

    entries.add({
      'previewId': previewId,
      'sourcePath': sourcePath,
      'snippetRegion': snippetRegion,
      'title': title,
      'description': description,
      'category': category,
      'renderable': renderable,
    });
  }

  if (entries.length != entryBlocks.length) {
    throw StateError(
      'Parsed ${entries.length} preview entries but found '
      '${entryBlocks.length} PreviewEntry blocks.',
    );
  }

  return entries;
}

List<String> _extractPreviewEntryBlocks(String source) {
  const prefix = 'PreviewEntry(';
  final listStartPattern = RegExp(
    r'static\s+final\s+List<PreviewEntry>\s+_previews\s*=\s*\[',
  );
  final blocks = <String>[];
  final listStartMatch = listStartPattern.firstMatch(source);

  if (listStartMatch == null) {
    throw StateError('Could not find _previews list in $_registryPath');
  }

  final listStart = listStartMatch.end;
  final listEnd = source.indexOf('];', listStart);
  if (listEnd == -1) {
    throw StateError('Could not find end of _previews list in $_registryPath');
  }

  final listSource = source.substring(listStart, listEnd);

  var start = 0;
  while (true) {
    final entryStart = listSource.indexOf(prefix, start);
    if (entryStart == -1) {
      break;
    }

    var depth = 1;
    var cursor = entryStart + prefix.length;

    while (cursor < listSource.length && depth > 0) {
      final char = listSource[cursor];

      if (char == '(') {
        depth++;
      } else if (char == ')') {
        depth--;
      }

      cursor++;
    }

    if (depth != 0) {
      throw StateError(
        'Unbalanced PreviewEntry parenthesis in $_registryPath around '
        'index $entryStart in _previews list',
      );
    }

    final block = listSource.substring(entryStart + prefix.length, cursor - 1);
    blocks.add(block);
    start = cursor;
  }

  return blocks;
}

String? _extractStringField(String block, String fieldName) {
  final pattern = RegExp("$fieldName\\s*:\\s*'([^']*)'", dotAll: true);
  final match = pattern.firstMatch(block);
  if (match == null) {
    return null;
  }

  return match
      .group(1)
      ?.replaceAll('\n', ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

String? _extractTokenField(String block, String fieldName) {
  final pattern = RegExp('$fieldName\\s*:\\s*([a-zA-Z0-9_]+)');

  return pattern.firstMatch(block)?.group(1);
}

bool? _extractBoolField(String block, String fieldName) {
  final pattern = RegExp('$fieldName\\s*:\\s*(true|false)');
  final value = pattern.firstMatch(block)?.group(1);
  if (value == null) {
    return null;
  }

  return value == 'true';
}

String? _resolveCategory(String? token, Map<String, String> constants) {
  if (token == null) {
    return null;
  }

  if (constants.containsKey(token)) {
    return constants[token];
  }

  return token;
}

void _validateEntries(List<Map<String, Object?>> entries, String projectRoot) {
  if (entries.isEmpty) {
    throw StateError('No preview entries were parsed from $_registryPath');
  }

  final previewIds = <String>{};

  for (final entry in entries) {
    final rawPreviewId = entry['previewId'];
    if (rawPreviewId is! String || rawPreviewId.isEmpty) {
      throw StateError(
        'Manifest entry has invalid previewId: "${rawPreviewId ?? ''}"',
      );
    }

    final rawSourcePath = entry['sourcePath'];
    if (rawSourcePath is! String || rawSourcePath.isEmpty) {
      throw StateError(
        'Manifest entry "$rawPreviewId" has invalid sourcePath: "${rawSourcePath ?? ''}"',
      );
    }

    final previewId = rawPreviewId;
    final sourcePath = rawSourcePath;

    if (!previewIds.add(previewId)) {
      throw StateError(
        'Duplicate previewId in manifest generation: $previewId',
      );
    }

    final normalized = sourcePath.replaceAll('/', Platform.pathSeparator);
    final sourceFile = File('$projectRoot${Platform.pathSeparator}$normalized');
    if (!sourceFile.existsSync()) {
      throw StateError('Missing source file for "$previewId": $sourcePath');
    }
  }
}
