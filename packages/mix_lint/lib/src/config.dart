import 'dart:convert';

import 'package:analyzer/file_system/file_system.dart';
import 'package:yaml/yaml.dart';

/// The key of this plugin's section in `analysis_options.yaml`.
const _sectionName = 'mix_lint';

/// Reads rule options from the `mix_lint:` section of the analysis options
/// file that applies to a Dart library.
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
  static final _cache = <(ResourceProvider, String), _CachedSection>{};

  /// The options map for [ruleName], or `null` when it isn't configured.
  ///
  /// [file] is the defining unit of the library being analyzed.
  static Map<String, Object?>? forRule(File file, String ruleName) {
    final optionsFile = _optionsFileFor(file);
    if (optionsFile == null) return null;
    final rule = _load(optionsFile)[ruleName];

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

  /// The `mix_lint:` section of [file] merged over the files it includes.
  static Map<String, Object?> _load(File file) {
    final key = (file.provider, file.path);
    final cached = _cache[key];
    if (cached != null && cached.isCurrent) return cached.section;

    final reader = _SectionReader(file);
    final section = reader.read(file, {});
    _cache[key] = _CachedSection(section, reader.stamps);

    return section;
  }
}

/// Reads the `mix_lint:` section of an options file and the files it
/// includes, and records the stamp of every file it looks up.
final class _SectionReader {
  /// The options file that applies to the library.
  final File root;

  /// Each file looked up, found or not, with its stamp before it was read,
  /// or `null` if it was missing.
  final stamps = <(File, int?)>[];

  /// The `lib/` URI of each package in the package config nearest to [root].
  ///
  /// Like the analyzer, this resolves every `package:` include with one
  /// package config, including the includes of included files.
  late final Map<String, Uri> _packages = _readPackageConfig();

  _SectionReader(this.root);

  /// The section of [file] merged over the sections of the files it
  /// includes. [chain] holds the files being read, to stop at include cycles.
  Map<String, Object?> read(File file, Set<String> chain) {
    if (!chain.add(file.path)) return {};
    try {
      final yaml = _parse(file);
      if (yaml is! YamlMap) return {};

      var section = <String, Object?>{};
      final includes = switch (yaml['include']) {
        final String include => [include],
        final YamlList list => list.whereType<String>(),
        _ => const <String>[],
      };
      for (final include in includes) {
        final included = _resolveInclude(file, include);
        if (included != null) section = _merge(section, read(included, chain));
      }

      return switch (_plain(yaml[_sectionName])) {
        final Map<String, Object?> own => _merge(section, own),
        _ => section,
      };
    } finally {
      chain.remove(file.path);
    }
  }

  /// The parsed YAML of [file], or `null` when it can't be read or parsed.
  Object? _parse(File file) {
    // Stamp before reading, so a save during the read invalidates the cache.
    stamps.add((file, _stampOf(file)));
    try {
      return loadYaml(file.readAsStringSync());
    } on FileSystemException {
      return null;
    } on YamlException {
      return null;
    }
  }

  /// Resolves [include] as a URI relative to [from], as the analyzer does.
  File? _resolveInclude(File from, String include) {
    final uri = Uri.tryParse(include);
    if (uri == null) return null;
    final provider = from.provider;
    final pathContext = provider.pathContext;
    final resolved = uri.isScheme('package')
        ? _resolvePackageUri(uri)
        : pathContext.toUri(from.path).resolveUri(uri);
    if (resolved == null || !resolved.isScheme('file')) return null;

    return provider.getFile(
      pathContext.normalize(pathContext.fromUri(resolved)),
    );
  }

  /// Resolves `package:<name>/<path>` with the package config.
  Uri? _resolvePackageUri(Uri uri) {
    final segments = uri.pathSegments;
    if (segments.length < 2 || segments.last.isEmpty) return null;

    return _packages[segments.first]?.resolveUri(
      Uri(pathSegments: segments.skip(1)),
    );
  }

  Map<String, Uri> _readPackageConfig() {
    for (Folder? folder = root.parent; folder != null;) {
      final config = folder
          .getFolder('.dart_tool')
          .getFile('package_config.json');
      final stamp = _stampOf(config);
      // Missing configs are recorded too, so a later `pub get` is noticed.
      stamps.add((config, stamp));
      if (stamp != null) return _parsePackageConfig(config);
      folder = folder.isRoot ? null : folder.parent;
    }

    return const {};
  }

  static Map<String, Uri> _parsePackageConfig(File config) {
    final Object? json;
    try {
      json = jsonDecode(config.readAsStringSync());
    } on FileSystemException {
      return const {};
    } on FormatException {
      return const {};
    }
    final packages = json is Map ? json['packages'] : null;
    if (packages is! List) return const {};

    // `rootUri` is relative to the config file, and `packageUri` to `rootUri`.
    final base = config.provider.pathContext.toUri(config.path);
    final libUris = <String, Uri>{};
    for (final package in packages) {
      if (package case {
        'name': final String name,
        'rootUri': final String rootUri,
      }) {
        final packageUri = package['packageUri'];
        final root = Uri.tryParse(_asDirectory(rootUri));
        final lib = Uri.tryParse(
          packageUri is String ? _asDirectory(packageUri) : '',
        );
        if (root != null && lib != null) {
          libUris[name] = base.resolveUri(root).resolveUri(lib);
        }
      }
    }

    return libUris;
  }
}

final class _CachedSection {
  final Map<String, Object?> section;

  /// Each file looked up, with its stamp, or `null` if it was missing.
  final List<(File, int?)> stamps;

  const _CachedSection(this.section, this.stamps);

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

String _asDirectory(String uri) =>
    uri.isEmpty || uri.endsWith('/') ? uri : '$uri/';

/// Merges [override] onto [base]: nested maps merge, other values replace.
///
/// Empty values, such as a key with only commented-out children, are
/// skipped, as the analyzer treats empty sections as absent.
Map<String, Object?> _merge(
  Map<String, Object?> base,
  Map<String, Object?> override,
) => {
  ...base,
  for (final MapEntry(:key, :value) in override.entries)
    if (value != null)
      key: switch ((base[key], value)) {
        (final Map<String, Object?> a, final Map<String, Object?> b) => _merge(
          a,
          b,
        ),
        _ => value,
      },
};

/// Converts parsed YAML into plain maps and lists with string keys.
Object? _plain(Object? node) => switch (node) {
  final YamlMap map => {
    for (final MapEntry(:key, :value) in map.entries) '$key': _plain(value),
  },
  final YamlList list => [for (final item in list) _plain(item)],
  _ => node,
};
