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

void _testPlanning() {
  final originalDirectory = Directory.current;
  final fixture = Directory.systemTemp.createTempSync('release-test-');
  try {
    Directory.current = fixture;
    _git(['init', '--bare', 'remote.git']);
    _git(['init', '--initial-branch=main', 'work']);
    Directory.current = Directory('work');
    _git(['config', 'user.name', 'Release test']);
    _git(['config', 'user.email', 'release-test@example.com']);
    _git(['config', 'commit.gpgsign', 'false']);
    _git(['remote', 'add', 'origin', '../remote.git']);
    for (final package in publishablePackages) {
      _writePackage(package, '1.0.0', '## 1.0.0\nInitial release.\n');
    }
    final before = _commit('Create packages');
    _git(['switch', '-c', 'bump']);
    _writePackage('mix', '2.0.0', '## 2.0.0\n');
    _writePackage('mix_annotations', '2.0.0', '## 1.0.0\n');
    _writePackage('mix_generator', '2.0.0', '## 2.0.0\n');
    _writePackage('mix_winds', '2.0.0', '## 2.0.0\n');
    final branchBump = _commit('Bump packages');
    _git(['switch', 'main']);
    _git(['merge', '--no-ff', 'bump', '-m', 'Merge bumps']);
    final bump = _git(['rev-parse', 'HEAD']);
    _expect('fixture uses the main merge commit', bump == branchBump, false);

    File(
      'packages/mix/pubspec.yaml',
    ).writeAsStringSync('description: Unreleased changes.\nversion: 2.0.0\n');
    File(
      'packages/mix_annotations/CHANGELOG.md',
    ).writeAsStringSync('## 2.0.0\nHeading added after the bump.\n');
    final head = _commit('Later changes without a version bump');
    _git(['tag', 'mix_generator-v2.0.0', head]);
    _git(['tag', '-a', 'mix_winds-v2.0.0', bump, '-m', 'Matching tag']);
    _git(['push', '--tags', 'origin', 'main']);
    _git(['tag', '-d', 'mix_generator-v2.0.0', 'mix_winds-v2.0.0']);

    final selected = planReleases(packages: dispatchPackages(' mix ')).single;
    _expect(
      'dispatch scopes to the requested package',
      selected.tag,
      'mix-v2.0.0',
    );
    _expect(
      'an empty matching heading is enough',
      selected.status,
      ReleaseStatus.due,
    );
    _expect(
      'dispatch targets the version bump, not HEAD',
      selected.detail,
      bump,
    );
    _expect(
      'dispatch accepts multiple packages',
      dispatchPackages('mix,mix_lint').length,
      2,
    );
    for (final input in ['', 'mix,unknown']) {
      try {
        dispatchPackages(input);
        throw StateError('Expected invalid dispatch package input: $input');
      } on FormatException {
        continue;
      }
    }

    final push = {
      for (final plan in planReleases(before: resolvePushBase(before)))
        plan.tag: plan,
    };
    _expect(
      'push targets the main version bump',
      push['mix-v2.0.0']?.detail,
      bump,
    );
    _expect(
      'unchanged version is skipped on push',
      push['mix_lint-v1.0.0']?.status,
      ReleaseStatus.skipped,
    );
    _expect(
      'heading added too late blocks release',
      push['mix_annotations-v2.0.0']?.status,
      ReleaseStatus.blocked,
    );
    _expect(
      'missing heading reports the bump',
      push['mix_annotations-v2.0.0']?.detail,
      'no ## 2.0.0 CHANGELOG heading at version bump $bump',
    );
    _expect(
      'remote tag at another commit blocks release',
      push['mix_generator-v2.0.0']?.status,
      ReleaseStatus.blocked,
    );
    _expect(
      'tag conflict reports both commits',
      push['mix_generator-v2.0.0']?.detail,
      'tag points to $head, expected version bump $bump',
    );
    _expect(
      'matching remote annotated tag is skipped',
      push['mix_winds-v2.0.0']?.status,
      ReleaseStatus.skipped,
    );
    _expect(
      'matching annotated tag is peeled',
      push['mix_winds-v2.0.0']?.detail,
      'tag already exists at $bump',
    );
    _expect(
      'an unchanged push does not block existing versions',
      planReleases(
        before: bump,
      ).every((plan) => plan.status == ReleaseStatus.skipped),
      true,
    );

    final missingBefore = resolvePushBase('f' * 40);
    _expect('unavailable push base falls back', missingBefore, null);
    final fallback = planReleases(before: missingBefore).toList();
    _expect(
      'fallback checks every package',
      fallback.length,
      publishablePackages.length,
    );
    final lint = fallback.singleWhere((plan) => plan.tag == 'mix_lint-v1.0.0');
    _expect(
      'fallback finds a missing tag for an unchanged package',
      lint.status,
      ReleaseStatus.due,
    );
    _expect('fallback still tags the version bump', lint.detail, before);
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

  const link = '[GitHub Release](https://example.com/release)';
  _expect('Markdown link only', isLinkOnly('\n $link\n'), true);
  _expect('bare link only', isLinkOnly('https://example.com/release'), true);
  _expect(
    'one list link only',
    isLinkOnly('- <https://example.com/release>'),
    true,
  );
  _expect('link with additional notes', isLinkOnly('$link\n- A fix'), false);
  _expect('prose between links', isLinkOnly('$link and $link'), false);
  _expect(
    'override wins',
    selectNotes(' Custom notes ', section),
    'Custom notes',
  );
  _expect('changelog is next', selectNotes(null, section), section);
  _expect('link-only uses generated notes', selectNotes(null, link), null);
  _expect('empty uses generated notes', selectNotes(null, ' \n'), null);
  _expect('missing uses generated notes', selectNotes(null, null), null);

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
  _testPlanning();
  print('Release script tests passed.');
}
