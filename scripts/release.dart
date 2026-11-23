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
      : _sectionBody(
          changelog.substring(range.start, range.end),
        ).replaceAll('\r\n', '\n');
}

String _sectionBody(String section) => section
    .replaceFirst(_leadingBlankLines, '')
    .replaceFirst(_trailingBlankLines, '');

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
  final notes = _sectionBody(original);
  if (notes == release.changelogLink) {
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
    final match = _version.firstMatch(version);
    if (match == null ||
        (!release.prerelease && match.group(4) != null) ||
        _compareVersions(version, release.version) >= 0) {
      continue;
    }
    if (previous == null || _compareVersions(version, previous) > 0) {
      previous = version;
    }
  }
  return previous == null ? null : '$prefix$previous';
}

String? newestStableMixTag(Iterable<String> tags) {
  const prefix = 'mix-v';
  String? newest;
  for (final tag in tags) {
    if (!tag.startsWith(prefix)) continue;
    final version = tag.substring(prefix.length);
    final match = _version.firstMatch(version);
    if (match == null || match.group(4) != null) continue;
    if (newest == null || _compareVersions(version, newest) > 0) {
      newest = version;
    }
  }
  return newest == null ? null : '$prefix$newest';
}

bool isLatestRelease(PackageRelease release, Iterable<String> mixTags) {
  if (release.package != 'mix' || release.prerelease) return false;
  final newest = newestStableMixTag(mixTags);
  return newest == null ||
      _compareVersions(release.version, newest.substring('mix-v'.length)) >= 0;
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
  final resolved = Process.runSync('git', [
    'rev-parse',
    '--verify',
    '--quiet',
    'refs/tags/$tag^{commit}',
  ]);
  if (resolved.exitCode != 0) {
    throw StateError(
      'Cannot resolve tag $tag to a commit. ${resolved.stderr}'.trim(),
    );
  }
  final commit = (resolved.stdout as String).trim();
  final version = versionFromPubspec(
    _fileAtCommit(commit, release.pubspecPath) ?? '',
  );
  if (version != release.version) {
    throw StateError(
      '$tag requires version ${release.version} in ${release.pubspecPath}; '
      'found ${version ?? 'no valid version'} at the tagged commit.',
    );
  }
  final changelog = _fileAtCommit(commit, release.changelogPath) ?? '';
  final notes = changelogSection(changelog, release.version);
  if (notes == null) {
    throw StateError(
      '${release.changelogPath} is missing ## ${release.version} at $tag.',
    );
  }
  if (notes != release.changelogLink) {
    throw StateError(
      '${release.changelogPath} section ## ${release.version} at $tag '
      'must contain only this line: ${release.changelogLink}',
    );
  }
  final result = Process.runSync('git', [
    'merge-base',
    '--is-ancestor',
    commit,
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

void syncRelease(
  PackageRelease release, {
  required String repository,
  required Iterable<String> Function(String package) tagsFor,
  required ProcessResult Function(List<String> args) gh,
}) {
  String checkedOutput(ProcessResult result) {
    if (result.exitCode != 0) {
      throw StateError(
        'GitHub CLI failed: ${(result.stderr as String).trim()}',
      );
    }
    return result.stdout as String;
  }

  String runGh(List<String> args) => checkedOutput(gh(args));

  final existing = gh(['release', 'view', release.tag, '--json', 'isDraft']);
  final missing =
      existing.exitCode != 0 &&
      (existing.stderr as String).trim() == 'release not found';
  final isDraft =
      !missing &&
      (jsonDecode(checkedOutput(existing)) as Map)['isDraft'] == true;
  final tags = missing || (release.package == 'mix' && !release.prerelease)
      ? tagsFor(release.package)
      : const <String>[];
  final latest = isLatestRelease(release, tags);
  final flags = ['--prerelease=${release.prerelease}', '--latest=$latest'];

  if (!missing) {
    stdout.write(
      runGh([
        'release',
        'edit',
        release.tag,
        ...flags,
        if (isDraft) '--draft=false',
      ]),
    );
  } else {
    final previous = previousReleaseTag(release, tags);
    final notes = previous == null
        ? ''
        : runGh([
            'api',
            '--method',
            'POST',
            'repos/$repository/releases/generate-notes',
            '-f',
            'tag_name=${release.tag}',
            '-f',
            'previous_tag_name=$previous',
            '--jq',
            '.body',
          ]).trimRight();
    final directory = Directory.systemTemp.createTempSync('release-notes-');
    try {
      final file = File('${directory.path}/notes.md');
      file.writeAsStringSync(
        '${notes.isEmpty ? '' : '$notes\n\n'}${release.pubLink}\n',
      );
      stdout.write(
        runGh([
          'release',
          'create',
          release.tag,
          '--verify-tag',
          '--title',
          release.title,
          '--notes-file',
          file.path,
          ...flags,
        ]),
      );
    } finally {
      directory.deleteSync(recursive: true);
    }
  }

  if (!latest) {
    final publishedTags = runGh([
      'api',
      '--paginate',
      'repos/$repository/releases?per_page=100',
      '--jq',
      '.[] | select(.draft == false) | .tag_name',
    ]);
    final newest = newestStableMixTag(
      const LineSplitter().convert(publishedTags),
    );
    if (newest != null && newest != release.tag) {
      stdout.write(
        runGh(['release', 'edit', newest, '--prerelease=false', '--latest']),
      );
    }
  }
}

void main(List<String> args) {
  try {
    switch (args) {
      case ['validate-tag', final tag]:
        validateTag(tag);
      case ['sync-release', final tag, final repository]:
        syncRelease(
          PackageRelease.fromTag(tag),
          repository: repository,
          tagsFor: _remoteTags,
          gh: (args) => Process.runSync('gh', args),
        );
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
          'Usage: dart --disable-dart-dev scripts/release.dart validate-tag <tag> | '
          'sync-release <tag> <owner/repo> | prepare-changelog <pkg> | '
          'prepare-changelog --changed-since <ref>',
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
