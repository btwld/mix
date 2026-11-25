import 'dart:io';

import 'release.dart';

void _expect<T>(String description, T actual, T expected) {
  if (actual != expected) {
    throw StateError('$description: expected $expected, got $actual');
  }
}

String _git(List<String> args) {
  final result = Process.runSync('git', args);
  if (result.exitCode != 0) {
    throw StateError('git ${args.join(' ')} failed: ${result.stderr}');
  }
  return (result.stdout as String).trim();
}

void _writePackage(String package, String version, String changelog) {
  final path = 'packages/$package';
  Directory(path).createSync(recursive: true);
  File('$path/pubspec.yaml').writeAsStringSync('version: $version\n');
  File('$path/CHANGELOG.md').writeAsStringSync(changelog);
}

String _commit(String message) {
  _git(['add', 'packages']);
  _git(['commit', '-m', message]);
  return _git(['rev-parse', 'HEAD']);
}

void _expectStateError(void Function() run, String message) {
  try {
    run();
  } on StateError catch (error) {
    _expect('clear error: $message', error.message.contains(message), true);
    return;
  }
  throw StateError('Expected error: $message');
}

void _testTagAndBump() {
  final originalDirectory = Directory.current;
  final fixture = Directory.systemTemp.createTempSync('release-test-');
  try {
    Directory.current = fixture;
    _git(['init', '--initial-branch=main', 'work']);
    Directory.current = Directory('work');
    _git(['config', 'user.name', 'Release test']);
    _git(['config', 'user.email', 'release-test@example.com']);
    _git(['config', 'commit.gpgsign', 'false']);
    _git(['config', 'tag.gpgSign', 'false']);
    const older = '## 1.0.0\n\nInitial release.\n';
    for (final package in publishablePackages) {
      _writePackage(package, '1.0.0', older);
    }
    _commit('Create packages');
    _writePackage('mix', '2.0.0', '## 2.0.0\n\nNew Mix notes.\n\n$older');
    _writePackage(
      'mix_winds',
      '2.0.0-beta.1',
      '## 2.0.0-beta.1\n\nNew Winds notes.\n\n$older',
    );
    File('packages/mix_lint/pubspec.yaml').writeAsStringSync(
      'description: Dependency-only edits.\nversion: 1.0.0\n',
    );
    final bumps = changedReleases('HEAD').toList();
    _expect(
      'only version bumps are selected',
      bumps.map((release) => release.tag).join(','),
      'mix-v2.0.0,mix_winds-v2.0.0-beta.1',
    );
    for (final release in bumps) {
      final notes = prepareChangelog(release);
      _expect(
        'draft for ${release.tag}',
        notes,
        release.package == 'mix' ? 'New Mix notes.' : 'New Winds notes.',
      );
      _expect(
        'link and historical entry for ${release.tag}',
        File(release.changelogPath).readAsStringSync(),
        '## ${release.version}\n\n${release.changelogLink}\n\n$older',
      );
    }
    final bump = _commit('Bump packages with link-only changelogs');
    _expect(
      'a committed bump does not draft again',
      changedReleases('HEAD').isEmpty,
      true,
    );
    _git(['tag', '-a', 'mix-v2.0.0', '-m', 'Annotated release', bump]);
    _git(['tag', 'mix_winds-v2.0.0-beta.1', bump]);
    _writePackage('mix', '2.1.0', '## 2.1.0\nUnreleased notes.\n');
    final tip = _commit('Advance main');
    _git(['update-ref', 'refs/remotes/origin/main', tip]);
    validateTag('mix-v2.0.0');
    validateTag('mix_winds-v2.0.0-beta.1');
    _expectStateError(
      () => validateTag('mix-v2.1.0'),
      'Cannot resolve tag mix-v2.1.0 to a commit',
    );
    _git(['tag', 'mix-v2.1.0', bump]);
    _expectStateError(
      () => validateTag('mix-v2.1.0'),
      'found 2.0.0 at the tagged commit',
    );

    _git(['tag', '-d', 'mix-v2.1.0']);
    _git(['tag', 'mix-v2.1.0', tip]);
    _expectStateError(
      () => validateTag('mix-v2.1.0'),
      'must contain only this line',
    );

    _git(['switch', '-c', 'unmerged']);
    final release = PackageRelease.fromTag('mix-v2.2.0');
    _writePackage(
      'mix',
      release.version,
      '## ${release.version}\n${release.changelogLink}\n',
    );
    final unmerged = _commit('Unmerged bump');
    _git(['tag', release.tag, unmerged]);
    _git(['checkout', '--detach', tip]);
    _expectStateError(() => validateTag(release.tag), 'not on origin/main');
    _git(['switch', 'unmerged']);
    _git(['update-ref', 'refs/remotes/origin/main', unmerged]);
    _writePackage('mix', '2.3.0', '```markdown\n## 2.3.0\n```\n');
    final missingHeading = _commit('Bump without a real heading');
    _git(['tag', 'mix-v2.3.0', missingHeading]);
    _git(['update-ref', 'refs/remotes/origin/main', missingHeading]);
    _expectStateError(
      () => validateTag('mix-v2.3.0'),
      'CHANGELOG.md is missing ## 2.3.0',
    );

    final next = PackageRelease.fromTag('mix-v2.4.0');
    _writePackage(
      'mix',
      next.version,
      '## ${next.version}\n${release.changelogLink}\n',
    );
    _git(['tag', next.tag, _commit('Bump with another version’s link')]);
    _expectStateError(() => validateTag(next.tag), next.changelogLink);

    final extra = PackageRelease.fromTag('mix-v2.5.0');
    _writePackage(
      'mix',
      extra.version,
      '## ${extra.version}\n${extra.changelogLink}\n\nExtra notes.\n',
    );
    _git(['tag', extra.tag, _commit('Bump with a link and extra notes')]);
    _expectStateError(
      () => validateTag(extra.tag),
      'must contain only this line',
    );
  } finally {
    Directory.current = originalDirectory;
    fixture.deleteSync(recursive: true);
  }
}

void _testReleaseSync() {
  final commands = <String>[];
  const remoteTags = ['mix-v2.9.0', 'mix-v2.10.0', 'mix-v3.0.0-beta.1'];
  var view = ProcessResult(0, 0, '{"isDraft":false}', '');
  var publishedTags =
      'mix-v2.10.0\nmix-v2.9.0\nmix-v3.0.0-beta.1\nmix_lint-v9.0.0\n';
  var writtenNotes = '';

  void sync(String tag) => syncRelease(
    PackageRelease.fromTag(tag),
    repository: 'owner/repo',
    tagsFor: (package) =>
        remoteTags.where((tag) => tag.startsWith('$package-v')),
    gh: (args) {
      final command = args.join(' ');
      commands.add(command);
      if (command.startsWith('release view ')) return view;
      if (args.contains('--paginate'))
        return ProcessResult(0, 0, publishedTags, '');
      if (args.contains('previous_tag_name=mix-v2.9.0')) {
        return ProcessResult(0, 0, 'Generated notes.\n', '');
      }
      if (command.startsWith('release create ')) {
        writtenNotes = File(
          args[args.indexOf('--notes-file') + 1],
        ).readAsStringSync();
      }
      return ProcessResult(0, 0, '', '');
    },
  );

  const restore = 'release edit mix-v2.10.0 --prerelease=false --latest';
  sync('mix_lint-v9.0.0');
  _expect(
    'non-Mix flags first',
    commands[1],
    'release edit mix_lint-v9.0.0 --prerelease=false --latest=false',
  );
  _expect('restore newest stable Mix', commands.last, restore);

  commands.clear();
  view = ProcessResult(0, 0, '{"isDraft":true}', '');
  sync('mix-v2.9.0');
  _expect(
    'make draft public without changing notes',
    commands[1],
    'release edit mix-v2.9.0 --prerelease=false --latest=false --draft=false',
  );
  _expect('older tag does not replace newest', commands.last, restore);

  commands.clear();
  publishedTags = 'mix-v2.9.0\n';
  sync('mix-v2.9.0');
  _expect(
    'do not re-promote old tag when newest tag has no Release',
    commands.any((command) => command.endsWith(' --latest')),
    false,
  );

  commands.clear();
  view = ProcessResult(0, 1, '', 'HTTP 403: denied\n');
  _expectStateError(() => sync('mix-v2.10.0'), 'HTTP 403: denied');
  _expect('failed lookup does not edit or create', commands.length, 1);

  commands.clear();
  view = ProcessResult(0, 1, '', 'release not found\n');
  sync('mix-v2.10.0');
  _expect(
    'generated notes use the previous stable tag',
    commands[1].contains('previous_tag_name=mix-v2.9.0'),
    true,
  );
  _expect(
    'newest stable tag creates a Latest Release',
    commands.last.endsWith('--prerelease=false --latest=true'),
    true,
  );
  _expect(
    'generated notes and pub.dev link',
    writtenNotes,
    'Generated notes.\n\nhttps://pub.dev/packages/mix/versions/2.10.0\n',
  );
}

void main() {
  _expect('plain version', versionFromPubspec('version: 1.2.3\n'), '1.2.3');
  _expect(
    'quoted pre-release version with a comment',
    versionFromPubspec('version: "1.2.3-beta.4+7" # version\r\n'),
    '1.2.3-beta.4+7',
  );
  _expect('nested version', versionFromPubspec('  version: 1.2.3'), null);
  _expect('invalid version', versionFromPubspec('version: 1.2'), null);

  final stable = PackageRelease.fromTag('mix-v2.5.0+meta-data');
  final beta = PackageRelease.fromTag('mix-v2.5.0-beta.1+build.0');
  final other = PackageRelease.fromTag('mix_winds-v1.0.0');
  _expect('tag version', beta.version, '2.5.0-beta.1+build.0');
  _expect('pre-release flag', beta.prerelease, true);
  _expect('build metadata is not a pre-release', stable.prerelease, false);
  _expect(
    'stable Mix can be latest',
    isLatestRelease(stable, [
      'mix-v2.5.0',
      'mix-v2.6.0-beta.1',
      'mix_winds-v9.0.0',
    ]),
    true,
  );
  _expect(
    'newer stable tag blocks latest even without a Release',
    isLatestRelease(stable, ['mix-v2.10.0']),
    false,
  );
  _expect('pre-release Mix is not latest', isLatestRelease(beta, []), false);
  _expect('non-Mix stable is not latest', isLatestRelease(other, []), false);
  _expect('release title', other.title, 'mix_winds 1.0.0');
  _expect(
    'pub.dev link',
    other.pubLink,
    'https://pub.dev/packages/mix_winds/versions/1.0.0',
  );
  for (final tag in ['mix-vtwo', 'mix_chart_protocol-v1.0.0', 'arbitrary']) {
    try {
      PackageRelease.fromTag(tag);
      throw StateError('Expected tag to be rejected: $tag');
    } on FormatException {
      continue;
    }
  }

  const changelog =
      '# Changelog\r\n## 2.5.0-beta.1\r\nBeta notes\r\n'
      '## 2.5.0 ##\r\n\r\n### Fixes\r\n\r\n- Fix a bug.\r\n'
      '## 2.4.0\r\nOlder notes.\r\n## 2.3.0\r\n';
  final section = changelogSection(changelog, '2.5.0');
  _expect(
    'exact section, preserving subheading',
    section,
    '### Fixes\n\n- Fix a bug.',
  );
  _expect('empty matching section', changelogSection(changelog, '2.3.0'), '');
  _expect('no matching section', changelogSection(changelog, '2.5.1'), null);

  const fencedChangelog = '''
```markdown
## 9.9.9
```
## 2.5.0
~~~~markdown
## Example
~~~
## Still fenced
~~~~
More notes.
## 2.4.0
Older notes.
''';
  _expect(
    'fenced version is not a heading',
    changelogSection(fencedChangelog, '9.9.9'),
    null,
  );
  _expect(
    'fenced headings do not truncate notes',
    changelogSection(fencedChangelog, '2.5.0'),
    '~~~~markdown\n## Example\n~~~\n## Still fenced\n~~~~\nMore notes.',
  );

  const release = PackageRelease('mix', '2.5.0');
  const link =
      'See the [release notes](https://github.com/btwld/mix/releases/tag/mix-v2.5.0).';
  final rewritten = rewriteChangelog(release, changelog);
  _expect(
    'draft keeps original body',
    rewritten.notes,
    '### Fixes\r\n\r\n- Fix a bug.',
  );
  _expect(
    'only the selected changelog section changes',
    rewritten.changelog,
    '# Changelog\r\n## 2.5.0-beta.1\r\nBeta notes\r\n'
        '## 2.5.0 ##\r\n\r\n$link\r\n\r\n'
        '## 2.4.0\r\nOlder notes.\r\n## 2.3.0\r\n',
  );
  _expect(
    'no draft is repeated on rerun',
    rewriteChangelog(release, rewritten.changelog),
    (changelog: rewritten.changelog, notes: ''),
  );
  _expect(
    'first-line Markdown indentation is preserved',
    rewriteChangelog(release, '## 2.5.0\n\n    Indented code.\n').notes,
    '    Indented code.',
  );
  _expectStateError(
    () => rewriteChangelog(release, '## 2.4.0\n'),
    'No ## 2.5.0 heading',
  );

  _expect(
    'stable tag compares against earlier stable versions of the same package',
    previousReleaseTag(PackageRelease.fromTag('mix-v2.10.0'), [
      'mix-v2.9.0',
      'mix_annotations-v2.9.9',
      'mix-v2.10.0-beta.10',
      'mix-v2.10.0-beta.2',
      'mix-v2.10.0-alpha',
      'mix-v2.10.0-bad..tag',
      'mix-v2.10.0+build.1',
      'mix-v2.11.0',
    ]),
    'mix-v2.9.0',
  );
  _expect(
    'pre-release still compares to newer pre-releases by SemVer',
    previousReleaseTag(PackageRelease.fromTag('mix-v2.10.0-rc.1'), [
      'mix-v2.9.0',
      'mix-v2.10.0-beta.10',
      'mix-v2.10.0-beta.2',
      'mix-v2.10.0',
    ]),
    'mix-v2.10.0-beta.10',
  );
  _expect(
    'stable tag does not compare to a pre-release when there is no stable tag',
    previousReleaseTag(PackageRelease.fromTag('mix-v2.10.0'), [
      'mix-v2.10.0-beta.1',
    ]),
    null,
  );
  _expect(
    'previous tag handles numeric core version ordering',
    previousReleaseTag(PackageRelease.fromTag('mix-v3.0.0'), [
      'mix-v2.10.0',
      'mix-v2.9.1',
      'mix-v3.1.0',
    ]),
    'mix-v2.10.0',
  );
  _expect(
    'no earlier same-package tag means no comparison',
    previousReleaseTag(PackageRelease.fromTag('mix_winds-v1.0.0-alpha'), [
      'mix-v0.5.0',
      'mix_winds-v1.0.0-alpha',
      'mix_winds-v1.0.0',
    ]),
    null,
  );
  _testTagAndBump();
  _testReleaseSync();
  print('Release script tests passed.');
}
