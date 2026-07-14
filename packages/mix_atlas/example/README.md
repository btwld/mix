# Mix Atlas desktop example

This app hosts the responsive `AtlasCatalogViewer` in a native desktop window.
It opens at 1280×800 and prevents resizing below 1040×700, which keeps the
viewer at or above its full desktop-layout breakpoint.

Native runner folders are generated rather than committed. From this directory:

```sh
fvm flutter create --platforms=macos,windows,linux .
fvm flutter run -d macos # or windows / linux
```

Edit `lib/window_config.dart` to change the initial or minimum window size.

## Standalone repository capture reader

`lib/artifact_main.dart` opens a committed Mix Atlas capture directly from a
GitHub repository. It verifies the manifest hashes, strict-decodes
`mix_protocol` themes and built-in leaf styles, and renders only the bounded
component-v1 anatomy vocabulary. Producer packages such as Remix are not app
dependencies and their code is never loaded or executed.

```sh
fvm flutter run -d macos -t lib/artifact_main.dart
fvm flutter build macos --release --no-tree-shake-icons \
  -t lib/artifact_main.dart
```

The release flag is required because protocol icon identities can contain
runtime code points, which makes Flutter's icon-font tree shaker unsafe.
