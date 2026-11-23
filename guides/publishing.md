# Releasing packages

1. Merge a version-bump PR into `main` with an updated package `pubspec.yaml`
   and a matching `## <version>` heading in its `CHANGELOG.md`.
2. **Tag releases** creates each missing `<pkg>-v<version>` tag at the merge
   commit and dispatches **Publish to pub.dev** on that tag. Existing tags are
   never moved or deleted.
3. Approve the `Production` deployment. After the package publishes to pub.dev,
   the workflow creates its GitHub Release.

Before using this flow, tick **Enable publishing from workflow_dispatch events**
under **Admin → Automated publishing** on pub.dev for each package. Without it,
the dispatched publish fails OIDC authentication.

To override the GitHub Release notes, include `.github/release-notes/<tag>.md`
in the bump PR. Otherwise the workflow uses the version's changelog section,
or GitHub's generated notes if that section is blank or just a link. It appends
a link to the published version on pub.dev.

A hand-pushed package tag still triggers publishing and gets a GitHub Release
after publishing succeeds, provided the tagged commit contains the new workflow.
The first-publication exceptions for [mix_protocol](publishing_mix_protocol.md)
and [mix_markdown](publishing_mix_markdown.md) still apply.

If a bump was missed, run **Tag releases** on `main` to check all current
versions for missing tags. If tag creation succeeded but dispatch failed,
run `gh workflow run publish.yml --ref <tag>` without moving the tag.
