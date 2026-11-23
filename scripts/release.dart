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
  r'^([0-9]+)\.([0-9]+)\.([0-9]+)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?'
  r'(?:\+[0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*)?$',
);
final _digits = RegExp(r'^[0-9]+$');
final _pubspecVersion = RegExp(r'^version:[ \t]+([^#\r\n]+)', multiLine: true);
final _tag = RegExp(r'^([a-z_]+)-v(.+)$');
final _heading = RegExp(r'^ {0,3}#{1,2}(?:[ \t]+(.*?)|$)[ \t]*$');
final _closingHashes = RegExp(r'[ \t]+#+$');
final _fence = RegExp(r'^ {0,3}(`{3,}|~{3,})(.*)$');
final _changelogLine = RegExp(r'([^\r\n]*)(?:\r\n|[\r\n]|$)');
final _leadingBlankLines = RegExp(r'^(?:[ \t]*(?:\r\n|\r|\n))+');
final _trailingBlankLines = RegExp(r'(?:\r\n|\r|\n)[ \t\r\n]*$');

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

({int start, int end})? _changelogRange(String changelog, String version) {
  int? start;
  String? openFence;
  for (final match in _changelogLine.allMatches(changelog)) {
    final line = match.group(1)!;
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
      continue;
    }
    final heading = openFence == null ? _heading.firstMatch(line) : null;
    if (heading != null) {
      if (start != null) return (start: start, end: match.start);
      final title = heading.group(1)?.replaceFirst(_closingHashes, '');
      if (line.trimLeft().startsWith('##') && title == version) {
        start = match.start + line.length;
      }
    }
  }
  return start == null ? null : (start: start, end: changelog.length);
}

String? changelogSection(String changelog, String version) {
  final range = _changelogRange(changelog, version);
  return range == null
      ? null
      : changelog
            .substring(range.start, range.end)
            .replaceAll('\r\n', '\n')
            .trim();
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
  String get pubspecPath => 'packages/$package/pubspec.yaml';
  String get changelogPath => 'packages/$package/CHANGELOG.md';
  String get changelogLink =>
      'See the [release notes](https://github.com/btwld/mix/releases/tag/$tag).';
  bool get prerelease => _version.firstMatch(version)?.group(4) != null;
  bool get latest => package == 'mix' && !prerelease;
}

({String changelog, String notes}) rewriteChangelog(
  PackageRelease release,
  String changelog,
) {
  final range = _changelogRange(changelog, release.version);
  if (range == null) {
    throw StateError(
      'No ## ${release.version} heading in ${release.changelogPath}.',
    );
  }
  final original = changelog.substring(range.start, range.end);
  final notes = original
      .replaceFirst(_leadingBlankLines, '')
      .replaceFirst(_trailingBlankLines, '');
  if (notes.trim() == release.changelogLink) {
    return (changelog: changelog, notes: '');
  }
  final newline = original.startsWith('\r\n') ? '\r\n' : '\n';
  final separator = range.end < changelog.length ? newline : '';
  return (
    changelog: changelog.replaceRange(
      range.start,
      range.end,
      '$newline$newline${release.changelogLink}$newline$separator',
    ),
    notes: notes,
  );
}

int _compareVersions(String left, String right) {
  final leftMatch = _version.firstMatch(left)!;
  final rightMatch = _version.firstMatch(right)!;
  for (final group in [1, 2, 3]) {
    final order = BigInt.parse(
      leftMatch.group(group)!,
    ).compareTo(BigInt.parse(rightMatch.group(group)!));
    if (order != 0) return order;
  }
  final leftSuffix = leftMatch.group(4)?.split('.');
  final rightSuffix = rightMatch.group(4)?.split('.');
  if (leftSuffix == null) return rightSuffix == null ? 0 : 1;
  if (rightSuffix == null) return -1;
  for (
    var index = 0;
    index < leftSuffix.length && index < rightSuffix.length;
    index++
  ) {
    final leftPart = leftSuffix[index];
    final rightPart = rightSuffix[index];
    final leftNumber = _digits.hasMatch(leftPart);
    final rightNumber = _digits.hasMatch(rightPart);
    final order = leftNumber && rightNumber
        ? BigInt.parse(leftPart).compareTo(BigInt.parse(rightPart))
        : leftNumber != rightNumber
        ? (leftNumber ? -1 : 1)
        : leftPart.compareTo(rightPart);
    if (order != 0) return order;
  }
  return leftSuffix.length.compareTo(rightSuffix.length);
}

String? previousReleaseTag(PackageRelease release, Iterable<String> tags) {
  final prefix = '${release.package}-v';
  String? previous;
  for (final tag in tags) {
    if (!tag.startsWith(prefix)) continue;
    final version = tag.substring(prefix.length);
    if (!_version.hasMatch(version) ||
        _compareVersions(version, release.version) >= 0) {
      continue;
    }
    if (previous == null || _compareVersions(version, previous) > 0) {
      previous = version;
    }
  }
  return previous == null ? null : '$prefix$previous';
}

String _git(List<String> args) {
  final result = Process.runSync('git', args);
  if (result.exitCode != 0) {
    throw StateError('git ${args.join(' ')} failed: ${result.stderr}');
  }
  return result.stdout as String;
}

Iterable<String> _remoteTags(String package) {
  const prefix = 'refs/tags/';
  final refs = _git([
    'ls-remote',
    '--tags',
    '--refs',
    'origin',
    '$prefix$package-v*',
  ]);
  return const LineSplitter()
      .convert(refs)
      .map((line) => line.split('\t').last.substring(prefix.length));
}

String? _fileAtCommit(String commit, String path) =>
    _git(['ls-tree', '--name-only', commit, '--', path]).isEmpty
    ? null
    : _git(['show', '$commit:$path']);

void validateTag(String tag) {
  final release = PackageRelease.fromTag(tag);
  final version = versionFromPubspec(
    _fileAtCommit('HEAD', release.pubspecPath) ?? '',
  );
  if (version != release.version) {
    throw StateError(
      '$tag requires version ${release.version} in ${release.pubspecPath}; '
      'found ${version ?? 'no valid version'} at the tagged commit.',
    );
  }
  final changelog = _fileAtCommit('HEAD', release.changelogPath) ?? '';
  if (_changelogRange(changelog, release.version) == null) {
    throw StateError(
      '${release.changelogPath} is missing ## ${release.version} at $tag.',
    );
  }
  final result = Process.runSync('git', [
    'merge-base',
    '--is-ancestor',
    'HEAD',
    'refs/remotes/origin/main',
  ]);
  if (result.exitCode == 1)
    throw StateError('The tagged commit for $tag is not on origin/main.');
  if (result.exitCode != 0)
    throw StateError(
      'Cannot check that $tag is on origin/main: ${result.stderr}',
    );
}

PackageRelease _workingRelease(String package) {
  if (!publishablePackages.contains(package)) {
    throw FormatException('Unknown publishable package', package);
  }
  final path = 'packages/$package/pubspec.yaml';
  final version = versionFromPubspec(File(path).readAsStringSync());
  if (version == null) throw StateError('No valid version in $path.');
  return PackageRelease(package, version);
}

String prepareChangelog(PackageRelease release) {
  final file = File(release.changelogPath);
  final original = file.readAsStringSync();
  final update = rewriteChangelog(release, original);
  if (original != update.changelog) file.writeAsStringSync(update.changelog);
  return update.notes;
}

Iterable<PackageRelease> changedReleases(String before) sync* {
  final base = _git(['rev-parse', '--verify', '$before^{commit}']).trim();
  for (final package in publishablePackages) {
    final release = _workingRelease(package);
    final previous = versionFromPubspec(
      _fileAtCommit(base, release.pubspecPath) ?? '',
    );
    if (previous != release.version) yield release;
  }
}

void _printReleaseInfo(String tag) {
  final release = PackageRelease.fromTag(tag);
  stdout.writeln(
    jsonEncode({
      'title': release.title,
      'prerelease': release.prerelease,
      'latest': release.latest,
      'pubLink': release.pubLink,
    }),
  );
}

void main(List<String> args) {
  try {
    switch (args) {
      case ['validate-tag', final tag]:
        validateTag(tag);
      case ['release-info', final tag]:
        _printReleaseInfo(tag);
      case ['previous-tag', final tag]:
        final release = PackageRelease.fromTag(tag);
        final previous = previousReleaseTag(
          release,
          _remoteTags(release.package),
        );
        if (previous != null) stdout.writeln(previous);
      case ['prepare-changelog', final package]:
        stdout.writeln(prepareChangelog(_workingRelease(package)));
      case ['prepare-changelog', '--changed-since', final before]:
        for (final release in changedReleases(before)) {
          final notes = prepareChangelog(release);
          stdout.writeln(
            '### ${release.tag}\n\n${notes.isEmpty ? '_Add release notes._' : notes}\n',
          );
        }
      default:
        stderr.writeln(
          'Usage: dart scripts/release.dart validate-tag <tag> | release-info <tag> | '
          'previous-tag <tag> | prepare-changelog <pkg> | prepare-changelog --changed-since <ref>',
        );
        exitCode = 64;
    }
  } on FormatException catch (error) {
    stderr.writeln(error);
    exitCode = 1;
  } on StateError catch (error) {
    stderr.writeln(error.message);
    exitCode = 1;
  }
}
