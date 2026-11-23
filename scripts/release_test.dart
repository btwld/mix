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
    _writePackage('mix', '2.1.0', '## 2.1.0\nUnreleased notes.\n');
    final tip = _commit('Advance main');
    _git(['update-ref', 'refs/remotes/origin/main', tip]);
    _git(['checkout', '--detach', bump]);
    validateTag('mix-v2.0.0');
    validateTag('mix_winds-v2.0.0-beta.1');
    _expectStateError(
      () => validateTag('mix-v2.1.0'),
      'found 2.0.0 at the tagged commit',
    );

    _git(['switch', '-c', 'unmerged']);
    _writePackage('mix', '2.2.0', '## 2.2.0\nUnmerged notes.\n');
    final unmerged = _commit('Unmerged bump');
    _expectStateError(() => validateTag('mix-v2.2.0'), 'not on origin/main');
    _git(['update-ref', 'refs/remotes/origin/main', unmerged]);
    _writePackage('mix', '2.3.0', '```markdown\n## 2.3.0\n```\n');
    final missingHeading = _commit('Bump without a real heading');
    _git(['update-ref', 'refs/remotes/origin/main', missingHeading]);
    _expectStateError(
      () => validateTag('mix-v2.3.0'),
      'CHANGELOG.md is missing ## 2.3.0',
    );
  } finally {
    Directory.current = originalDirectory;
    fixture.deleteSync(recursive: true);
  }
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
  _expect('stable Mix is latest', stable.latest, true);
  _expect('pre-release Mix is not latest', beta.latest, false);
  _expect('non-Mix stable is not latest', other.latest, false);
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
    'previous tag is an earlier same-package version, sorted by SemVer',
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
    'mix-v2.10.0-beta.10',
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
  print('Release script tests passed.');
}
