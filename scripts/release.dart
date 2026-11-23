import 'dart:convert';
import 'dart:io';

const publishablePackages = [
  'mix',
  'mix_annotations',
  'mix_generator',
  'mix_lint',
  'mix_protocol',
  'mix_winds',
  'mix_chart',
  'mix_markdown',
];

final _version = RegExp(
  r'^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?'
  r'(?:\+[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?$',
);
final _pubspecVersion = RegExp(r'^version:[ \t]+([^#\r\n]+)', multiLine: true);
final _tag = RegExp(r'^([a-z_]+)-v(.+)$');
final _heading = RegExp(r'^ {0,3}#{1,2}(?:[ \t]+(.*?)|$)[ \t]*$');
final _closingHashes = RegExp(r'[ \t]+#+$');
final _fence = RegExp(r'^ {0,3}(`{3,}|~{3,})(.*)$');
final _onlyLink = RegExp(
  r'^(?:[-+*][ \t]+)?(?:\[[^\]\r\n]+\]\((?:[^()\s]|\([^()\s]*\))+\)'
  r'|<https?://[^>\s]+>|https?://\S+)$',
);

String? versionFromPubspec(String pubspec) {
  var version = _pubspecVersion.firstMatch(pubspec)?.group(1)?.trim();
  if (version == null) return null;
  if (version.length >= 2 &&
      ((version.startsWith('"') && version.endsWith('"')) ||
          (version.startsWith("'") && version.endsWith("'")))) {
    version = version.substring(1, version.length - 1);
  }
  return _version.hasMatch(version) ? version : null;
}

String? changelogSection(String changelog, String version) {
  List<String>? section;
  String? openFence;
  for (final line in const LineSplitter().convert(changelog)) {
    final fence = _fence.firstMatch(line);
    if (fence != null) {
      final marker = fence.group(1)!;
      final suffix = fence.group(2)!;
      if (openFence == null) {
        if (!marker.startsWith('`') || !suffix.contains('`'))
          openFence = marker;
      } else if (marker.startsWith(openFence) && suffix.trim().isEmpty) {
        openFence = null;
      }
      section?.add(line);
      continue;
    }
    final heading = openFence == null ? _heading.firstMatch(line) : null;
    if (heading != null) {
      if (section != null) break;
      final title = heading.group(1)?.replaceFirst(_closingHashes, '');
      if (line.trimLeft().startsWith('##') && title == version) section = [];
    } else {
      section?.add(line);
    }
  }
  return section?.join('\n').trim();
}

bool isLinkOnly(String section) => _onlyLink.hasMatch(section.trim());

String? selectNotes(String? override, String? section) {
  if (override != null) return override.trim();
  if (section == null || section.trim().isEmpty || isLinkOnly(section)) {
    return null;
  }
  return section.trim();
}

class PackageRelease {
  final String package;
  final String version;

  const PackageRelease(this.package, this.version);

  factory PackageRelease.fromTag(String tag) {
    final match = _tag.firstMatch(tag);
    if (match == null ||
        !publishablePackages.contains(match.group(1)) ||
        !_version.hasMatch(match.group(2)!)) {
      throw FormatException('Invalid package release tag', tag);
    }
    return PackageRelease(match.group(1)!, match.group(2)!);
  }

  String get tag => '$package-v$version';
  String get title => '$package $version';
  String get pubLink => 'https://pub.dev/packages/$package/versions/$version';
  bool get prerelease => _version.firstMatch(version)?.group(1) != null;
  bool get latest => package == 'mix' && !prerelease;
}

enum ReleaseDecision {
  due('due'),
  unchanged('version unchanged'),
  tagged('tag already exists'),
  missingChangelog('no matching CHANGELOG heading');

  final String label;
  const ReleaseDecision(this.label);
}

ReleaseDecision planRelease(
  PackageRelease release, {
  required String? previousVersion,
  required Set<String> remoteTags,
  required String changelog,
}) {
  if (remoteTags.contains(release.tag)) return ReleaseDecision.tagged;
  if (previousVersion == release.version) return ReleaseDecision.unchanged;
  if (changelogSection(changelog, release.version) == null) {
    return ReleaseDecision.missingChangelog;
  }
  return ReleaseDecision.due;
}

String _git(List<String> args) {
  final result = Process.runSync('git', args);
  if (result.exitCode != 0) {
    throw StateError('git ${args.join(' ')} failed: ${result.stderr}');
  }
  return result.stdout as String;
}

String? _readFile(String path) {
  final file = File(path);
  return file.existsSync() ? file.readAsStringSync() : null;
}

void _printPlan(String beforeSha) {
  final before = beforeSha.isEmpty || RegExp(r'^0+$').hasMatch(beforeSha)
      ? null
      : beforeSha;
  if (before != null) _git(['rev-parse', '--verify', '$before^{commit}']);

  const tagPrefix = 'refs/tags/';
  final remoteTags = const LineSplitter()
      .convert(_git(['ls-remote', '--tags', '--refs', 'origin']))
      .map((line) => line.split('\t').last.substring(tagPrefix.length))
      .toSet();

  for (final package in publishablePackages) {
    final path = 'packages/$package/pubspec.yaml';
    final version = versionFromPubspec(File(path).readAsStringSync());
    if (version == null) throw FormatException('No valid version in $path');
    final previous =
        before != null && _git(['ls-tree', before, '--', path]).isNotEmpty
        ? versionFromPubspec(_git(['show', '$before:$path']))
        : null;
    final release = PackageRelease(package, version);
    final decision = planRelease(
      release,
      previousVersion: previous,
      remoteTags: remoteTags,
      changelog: _readFile('packages/$package/CHANGELOG.md') ?? '',
    );
    stdout.writeln('${release.tag}\t${decision.label}');
  }
}

void _printNotes(String tag) {
  final release = PackageRelease.fromTag(tag);
  final changelog = _readFile('packages/${release.package}/CHANGELOG.md') ?? '';
  stdout.writeln(
    jsonEncode({
      'title': release.title,
      'prerelease': release.prerelease,
      'latest': release.latest,
      'pubLink': release.pubLink,
      'notes': selectNotes(
        _readFile('.github/release-notes/$tag.md'),
        changelogSection(changelog, release.version),
      ),
    }),
  );
}

void main(List<String> args) {
  switch (args) {
    case ['plan', final before]:
      _printPlan(before);
    case ['notes', final tag]:
      _printNotes(tag);
    default:
      stderr.writeln(
        'Usage: dart scripts/release.dart plan <before-sha>|notes <tag>',
      );
      exitCode = 64;
  }
}
