import 'dart:convert';

import 'package:analyzer/file_system/file_system.dart';
import 'package:yaml/yaml.dart';

/// The key of this plugin's section in `analysis_options.yaml`.
const configSectionName = 'mix_lint';

/// Reads rule options from the `mix_lint:` section of the analysis options
/// file that applies to a Dart file.
///
/// The analyzer passes plugin rules only whether they are enabled and their
/// severity, so rules that take options read this top-level section, which
/// the analyzer ignores. `include:` entries are followed, with relative paths
/// and `package:` URIs, so a workspace can configure every member from its
/// root options file.
///
/// ```yaml
/// mix_lint:
///   long_styler_chain:
///     max_calls: 20
/// ```
abstract final class RuleOptions {
  // Keyed by file system and path: stamps are only comparable within one
  // file system.
  static final _cache = <(ResourceProvider, String), _CachedOptions>{};

  /// The options map for [ruleName], or `null` when it isn't configured.
  static Map<String, Object?>? forRule(File file, String ruleName) {
    final options = _optionsFileFor(file);
    if (options == null) return null;
    final section = _load(options)[configSectionName];
    if (section is! Map<String, Object?>) return null;
    final rule = section[ruleName];

    return rule is Map<String, Object?> ? rule : null;
  }

  static File? _optionsFileFor(File file) {
    for (Folder? folder = file.parent; folder != null;) {
      final options = folder.getFile('analysis_options.yaml');
      if (options.exists) return options;
      folder = folder.isRoot ? null : folder.parent;
    }

    return null;
  }

  static Map<String, Object?> _load(File file) {
    final key = (file.provider, file.path);
    final cached = _cache[key];
    if (cached != null && cached.isCurrent) return cached.options;

    final sources = <File>[];
    final options = _read(file, sources, {});
    _cache[key] = _CachedOptions(options, [
      for (final source in sources) (source, _stampOf(source)),
    ]);

    return options;
  }

  /// Parses [file] merged over the files it includes.
  ///
  /// Every file looked up, found or not, is recorded in [sources], so the
  /// cache also notices an included file that is created later. [chain]
  /// holds the files being read, to stop at include cycles.
  static Map<String, Object?> _read(
    File file,
    List<File> sources,
    Set<String> chain,
  ) {
    if (!chain.add(file.path)) return {};
    sources.add(file);
    try {
      final yaml = _parse(file);
      if (yaml == null) return {};

      var merged = <String, Object?>{};
      final includes = switch (yaml['include']) {
        final String include => [include],
        final List<Object?> list => list.whereType<String>(),
        _ => const <String>[],
      };
      for (final include in includes) {
        final included = _resolveInclude(file, include, sources);
        if (included != null) {
          merged = _merge(merged, _read(included, sources, chain));
        }
      }

      return _merge(merged, yaml);
    } finally {
      chain.remove(file.path);
    }
  }

  /// The top-level map of [file], or `null` when it is missing or invalid.
  static Map<String, Object?>? _parse(File file) {
    try {
      final yaml = _plain(loadYaml(file.readAsStringSync()));

      return yaml is Map<String, Object?> ? yaml : null;
    } on FileSystemException {
      return null;
    } on YamlException {
      return null;
    }
  }

  static File? _resolveInclude(File from, String include, List<File> sources) {
    final provider = from.provider;
    final pathContext = provider.pathContext;
    if (!include.startsWith('package:')) {
      return provider.getFile(
        pathContext.normalize(pathContext.join(from.parent.path, include)),
      );
    }

    // `package:<name>/<path>`.
    final segments = Uri.tryParse(include)?.pathSegments ?? const [];
    if (segments.length < 2) return null;
    final libUri = _packageLibUri(from.parent, segments.first, sources);
    if (libUri == null || !libUri.isScheme('file')) return null;

    return provider.getFile(
      pathContext.fromUri(libUri.resolve(segments.skip(1).join('/'))),
    );
  }

  /// The `lib/` directory of [packageName] according to the nearest
  /// `.dart_tool/package_config.json` above [folder], which is recorded in
  /// [sources].
  static Uri? _packageLibUri(
    Folder folder,
    String packageName,
    List<File> sources,
  ) {
    final pathContext = folder.provider.pathContext;
    for (Folder? current = folder; current != null;) {
      final configFile = current
          .getFolder('.dart_tool')
          .getFile('package_config.json');
      if (configFile.exists) {
        sources.add(configFile);
        final Object? json;
        try {
          json = jsonDecode(configFile.readAsStringSync());
        } on FileSystemException {
          return null;
        } on FormatException {
          return null;
        }
        final packages = json is Map ? json['packages'] : null;
        if (packages is! List) return null;
        for (final package in packages) {
          if (package case {
            'name': final String name,
            'rootUri': final String rootUri,
          } when name == packageName) {
            final base = pathContext.toUri('${configFile.parent.path}/');
            final root = base.resolve(_asDirectory(rootUri));

            return switch (package['packageUri']) {
              final String packageUri => root.resolve(_asDirectory(packageUri)),
              _ => root,
            };
          }
        }

        return null;
      }
      current = current.isRoot ? null : current.parent;
    }

    return null;
  }

  static String _asDirectory(String uri) =>
      uri.isEmpty || uri.endsWith('/') ? uri : '$uri/';

  /// Merges [override] onto [base]: nested maps merge, other values replace.
  static Map<String, Object?> _merge(
    Map<String, Object?> base,
    Map<String, Object?> override,
  ) => {
    ...base,
    for (final MapEntry(:key, :value) in override.entries)
      key: switch ((base[key], value)) {
        (final Map<String, Object?> a, final Map<String, Object?> b) => _merge(
          a,
          b,
        ),
        _ => value,
      },
  };

  /// Converts parsed YAML into plain maps and lists with string keys.
  static Object? _plain(Object? node) => switch (node) {
    final YamlMap map => {
      for (final MapEntry(:key, :value) in map.entries) '$key': _plain(value),
    },
    final YamlList list => [for (final item in list) _plain(item)],
    _ => node,
  };
}

final class _CachedOptions {
  final Map<String, Object?> options;

  /// Each file read or looked up, with its stamp, or `null` if it was missing.
  final List<(File, int?)> stamps;

  const _CachedOptions(this.options, this.stamps);

  bool get isCurrent => stamps.every((stamp) => _stampOf(stamp.$1) == stamp.$2);
}

/// The modification stamp of [file], or `null` when it does not exist.
int? _stampOf(File file) {
  try {
    return file.modificationStamp;
  } on FileSystemException {
    return null;
  }
}
