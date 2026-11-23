# Releasing packages

A release covers preparing the version bump, creating the GitHub Release,
and publishing the package to pub.dev.

1. Run [Prepare release](.github/workflows/prepare-release.yml) and merge the
   resulting release PR into `main`. For each bumped package, include a
   `## <version>` heading followed by this one line in its `CHANGELOG.md`:

   ```markdown
   See the [release notes](https://github.com/btwld/mix/releases/tag/<pkg>-v<version>).
   ```

   Leave older entries unchanged. CI checks only the section for the tagged
   version; older full-note entries can stay as they are. **Prepare release**
   puts the draft in the bump PR body and the full, copyable Markdown in the
   workflow step summary.
   For a manual bump,
   `dart --disable-dart-dev scripts/release.dart prepare-changelog <pkg>`
   rewrites the new entry and prints the original notes for the PR.
2. In GitHub, draft a Release and choose **Create new tag** with the exact
   name `<pkg>-v<version>`, targeting `main`. Use the merged commit with the
   intended package version. Write the final notes in the Release, using the
   bump PR draft as a starting point. The GitHub Release is the source of
   truth for notes. Tick **Set as a pre-release** for versions with a suffix
   such as `-beta.1`; leave **Set as the latest release** unchecked unless
   this is the highest stable `mix` version.
3. Make the GitHub Release public. Its new tag starts
   **Publish to pub.dev**. CI checks that the tag, pubspec, and changelog agree
   and that the tagged commit is on `main`. Then approve the `Production`
   deployment. After publishing succeeds, CI sets the Release's pre-release
   and Latest flags without changing the notes. Retrying an
   older tag does not replace a newer stable `mix` Release as Latest.

Release dependencies first when another package needs their new versions.
Check that new tag formats (such as multi-digit minor
versions) match the `Production` deployment tag policy before release.

A hand-pushed tag still runs **Publish to pub.dev**. If no GitHub Release exists
after publishing succeeds, CI creates one with a pub.dev link and generated
notes when an earlier tag exists for the same package. Stable versions compare
only to earlier stable tags. If a draft exists, CI makes it public with its notes
intact. The first-publication exceptions for
[mix_protocol](guides/publishing_mix_protocol.md) and
[mix_markdown](guides/publishing_mix_markdown.md) still apply.

If publishing to pub.dev fails, the GitHub Release stays
public. Fix the cause and re-run the failed jobs from the original tag-push
run. Never move the tag. If the tagged source itself needs a change, bump the
version again and use a new tag.
