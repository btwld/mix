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
  bool get prerelease => _version.firstMatch(version)?.group(4) != null;
  bool get latest => package == 'mix' && !prerelease;
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

String? _readFile(String path) {
  final file = File(path);
  return file.existsSync() ? file.readAsStringSync() : null;
}

Map<String, String> _remoteTagCommits([String pattern = 'refs/tags/*']) {
  const prefix = 'refs/tags/';
  final commits = <String, String>{};
  final refs = _git(['ls-remote', '--tags', 'origin', pattern]);
  for (final line in const LineSplitter().convert(refs)) {
    final [sha, ref] = line.split('\t');
    final tag = ref.substring(prefix.length);
    if (tag.endsWith('^{}')) {
      commits[tag.substring(0, tag.length - 3)] = sha;
    } else {
      commits.putIfAbsent(tag, () => sha);
    }
  }
  return commits;
}

String? _fileAtCommit(String commit, String path) =>
    _git(['ls-tree', '--name-only', commit, '--', path]).isEmpty
    ? null
    : _git(['show', '$commit:$path']);

String? _versionAtCommit(String commit, String path) =>
    versionFromPubspec(_fileAtCommit(commit, path) ?? '');

String _versionCommit(String path, String version) {
  final history = _git([
    'log',
    '--first-parent',
    '--format=%H',
    'HEAD',
    '--',
    path,
  ]);
  String? bump;
  for (final commit in const LineSplitter().convert(history)) {
    if (_versionAtCommit(commit, path) != version) break;
    bump = commit;
  }
  return bump ??
      (throw StateError('Cannot locate the bump to $version in $path'));
}

String? resolvePushBase(String before) {
  if (before.isEmpty || RegExp(r'^0+$').hasMatch(before)) return null;
  final result = Process.runSync('git', [
    'rev-parse',
    '--verify',
    '--quiet',
    '$before^{commit}',
  ]);
  if (result.exitCode == 0) return (result.stdout as String).trim();
  if (result.exitCode != 1) {
    throw StateError('Cannot check push base $before: ${result.stderr}');
  }
  stderr.writeln(
    'Push base $before is unavailable; checking all current versions.',
  );
  return null;
}

Set<String> dispatchPackages(String input) {
  final packages = input.split(',').map((package) => package.trim()).toSet();
  final unknown = packages.difference(publishablePackages.toSet());
  if (unknown.isNotEmpty) {
    throw FormatException(
      'Provide comma-separated packages from ${publishablePackages.join(', ')}',
      input,
    );
  }
  return packages;
}

enum ReleaseStatus { due, skipped, blocked }

typedef ReleasePlan = ({String tag, ReleaseStatus status, String detail});

Iterable<ReleasePlan> planReleases({
  String? before,
  Iterable<String> packages = publishablePackages,
}) sync* {
  final remoteTags = _remoteTagCommits();
  for (final package in packages) {
    final path = 'packages/$package/pubspec.yaml';
    final version = _versionAtCommit('HEAD', path);
    if (version == null) throw FormatException('No valid version in $path');
    final tag = PackageRelease(package, version).tag;
    if (before != null && _versionAtCommit(before, path) == version) {
      yield (
        tag: tag,
        status: ReleaseStatus.skipped,
        detail: 'version unchanged',
      );
      continue;
    }

    final bump = _versionCommit(path, version);
    final taggedCommit = remoteTags[tag];
    if (taggedCommit != null) {
      yield taggedCommit == bump
          ? (
              tag: tag,
              status: ReleaseStatus.skipped,
              detail: 'tag already exists at $bump',
            )
          : (
              tag: tag,
              status: ReleaseStatus.blocked,
              detail:
                  'tag points to $taggedCommit, expected version bump $bump',
            );
      continue;
    }

    final changelog =
        _fileAtCommit(bump, 'packages/$package/CHANGELOG.md') ?? '';
    if (changelogSection(changelog, version) == null) {
      yield (
        tag: tag,
        status: ReleaseStatus.blocked,
        detail: 'no ## $version CHANGELOG heading at version bump $bump',
      );
      continue;
    }
    yield (tag: tag, status: ReleaseStatus.due, detail: bump);
  }
}

void _printPlan(Iterable<ReleasePlan> plans) {
  for (final plan in plans) {
    stdout.writeln('${plan.tag}\t${plan.status.name}\t${plan.detail}');
  }
}

void _printNotes(String tag) {
  final release = PackageRelease.fromTag(tag);
  final changelog = _readFile('packages/${release.package}/CHANGELOG.md') ?? '';
  final notes = selectNotes(
    _readFile('.github/release-notes/$tag.md'),
    changelogSection(changelog, release.version),
  );
  stdout.writeln(
    jsonEncode({
      'title': release.title,
      'prerelease': release.prerelease,
      'latest': release.latest,
      'pubLink': release.pubLink,
      'notes': notes,
      'previousTag': notes == null
          ? previousReleaseTag(
              release,
              _remoteTagCommits('refs/tags/${release.package}-v*').keys,
            )
          : null,
    }),
  );
}

void main(List<String> args) {
  switch (args) {
    case ['plan', final before]:
      _printPlan(planReleases(before: resolvePushBase(before)));
    case ['plan-for', final packages]:
      _printPlan(planReleases(packages: dispatchPackages(packages)));
    case ['validate-tag', final tag]:
      PackageRelease.fromTag(tag);
    case ['notes', final tag]:
      _printNotes(tag);
    default:
      stderr.writeln(
        'Usage: dart scripts/release.dart plan <before-sha> | '
        'plan-for <package[,package...]> | validate-tag <tag> | notes <tag>',
      );
      exitCode = 64;
  }
}
