# Releasing packages

1. Merge a version-bump PR into `main`. For each bumped package, include a
   `## <version>` heading followed by this one line in its `CHANGELOG.md`:

   ```markdown
   See the [release notes](https://github.com/btwld/mix/releases/tag/<pkg>-v<version>).
   ```

   Leave older entries unchanged. **Changelog** drafts the release notes from
   the new entries and puts them in the bump PR body and workflow summary.
   For a manual bump,
   `dart --disable-dart-dev scripts/release.dart prepare-changelog <pkg>`
   rewrites the new entry and prints the original notes for the PR.
2. In GitHub, draft a Release and choose **Create new tag** with the exact
   name `<pkg>-v<version>`, targeting `main`. Use the merged commit with the
   intended package version. Write the final notes in the Release, using the
   bump PR draft as a starting point. The GitHub Release is the source of
   truth for notes. Tick **Set as a pre-release** for versions with a suffix
   such as `-beta.1`; only a stable `mix` release should be marked Latest.
3. Publish the GitHub Release. This creates the tag, and the tag push starts
   **Publish to pub.dev**. CI checks that the tag, pubspec, and changelog agree
   and that the tagged commit is on `main`. Then approve the `Production`
   deployment. After publishing succeeds, CI sets the Release's pre-release
   and Latest flags without changing the notes.

Publish dependency bumps first if another package needs the new version.
Finish stable `mix` releases in version order, since each is marked Latest
after publishing. Check that new tag formats (such as multi-digit minor
versions) match the `Production` deployment tag policy before release.

A hand-pushed tag still publishes the package. If no GitHub Release exists
after publishing succeeds, CI creates one with a pub.dev link and generated
notes when an earlier tag exists for the same package. The first-publication
exceptions for [mix_protocol](publishing_mix_protocol.md) and
[mix_markdown](publishing_mix_markdown.md) still apply.

If publishing fails after the GitHub Release is public, the Release stays
public. Fix the cause and re-run the failed jobs from the original tag-push
run. Never move the tag. If the tagged source itself needs a change, bump the
version again and use a new tag.
