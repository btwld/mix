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
