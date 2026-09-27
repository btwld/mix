# Publishing mix_protocol

The first `mix_protocol` version is `1.0.0-alpha.0`. Pub.dev requires a new
package's first version to be published manually; GitHub Actions OIDC publishing
can be configured only after the package exists.

1. Merge the release-preparation PR. From a clean checkout of that merge commit,
   ensure `packages/mix_protocol/pubspec_overrides.yaml` is absent so the package
   resolves the hosted `mix` dependency.
2. Run `fvm flutter pub get`, `fvm flutter test`, and
   `fvm dart pub publish --dry-run` from `packages/mix_protocol`.
3. An authorized pub.dev maintainer runs `fvm dart pub publish` from that same
   directory to publish `1.0.0-alpha.0`.
4. Add the package to the Mix verified publisher and configure automated
   publishing for `btwld/mix`, `.github/workflows/publish.yml`, and the
   `mix_protocol-v{{version}}` tag pattern. Future version tags use the
   workflow's OIDC job.
5. Create and push `mix_protocol-v1.0.0-alpha.0` at the published commit for
   traceability. Its publish job intentionally skips this manually published
   version.

After `mix_protocol` is available on pub.dev, change `mix_winds`' development
dependency from a local path to the hosted pre-release, then publish a new
`mix_winds` alpha version. Do not move the existing `mix_winds-v0.1.0-alpha.0`
tag, which points to an older commit.

See [Dart's automated publishing guide](https://dart.dev/tools/pub/automated-publishing)
for the first-publication requirement and pub.dev configuration steps.
