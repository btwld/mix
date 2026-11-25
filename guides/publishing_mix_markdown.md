# First release of mix_markdown

The first release, `0.1.0-beta.1`, requires manual publishing to pub.dev, as
with [`mix_protocol`](publishing_mix_protocol.md). Automated publishing can
only be configured once the package exists on pub.dev.

1. Merge the release PR. From a clean checkout of the merge commit, ensure
   `packages/mix_markdown/pubspec_overrides.yaml` is absent so the package
   resolves hosted Mix dependencies.
2. In `packages/mix_markdown`, run `fvm flutter pub get`, `fvm flutter test`,
   and `fvm dart pub publish --dry-run`. An authorized maintainer then runs
   `fvm dart pub publish` from the same directory.
3. Add the package to the `leoafarias.com` verified publisher. In the package's
   pub.dev Admin tab, enable GitHub Actions publishing for `btwld/mix` with tag
   pattern `mix_markdown-v{{version}}`.
4. Create and push `mix_markdown-v0.1.0-beta.1` at the published commit for
   traceability. `.github/workflows/publish.yml` skips this tag.

For later versions, follow the [standard release process](../RELEASING.md).
