import 'release.dart';

void _expect<T>(String description, T actual, T expected) {
  if (actual != expected) {
    throw StateError('$description: expected $expected, got $actual');
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

  const release = PackageRelease('mix', '2.5.0');
  ReleaseDecision decide(String? before, Set<String> tags, String changes) =>
      planRelease(
        release,
        previousVersion: before,
        remoteTags: tags,
        changelog: changes,
      );
  _expect(
    'push with a changed version',
    decide('2.4.0', {}, changelog),
    ReleaseDecision.due,
  );
  _expect(
    'push with no bump',
    decide('2.5.0', {}, changelog),
    ReleaseDecision.unchanged,
  );
  _expect(
    'dispatch with missing tag',
    decide(null, {}, changelog),
    ReleaseDecision.due,
  );
  _expect(
    'existing remote tag',
    decide(null, {release.tag}, changelog),
    ReleaseDecision.tagged,
  );
  _expect(
    'another package tag does not block',
    decide(null, {'mix_lint-v2.5.0'}, changelog),
    ReleaseDecision.due,
  );
  _expect(
    'missing heading',
    decide(null, {}, '## 2.5.0-beta.1'),
    ReleaseDecision.missingChangelog,
  );
  _expect(
    'empty heading is enough to tag',
    decide(null, {}, '## 2.5.0'),
    ReleaseDecision.due,
  );
  print('Release script tests passed.');
}
