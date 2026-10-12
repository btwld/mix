{{flutter_js}}
{{flutter_build_config}}

const flutterQuery = new URLSearchParams(window.location.search);
const flutterUsesFullPage =
  flutterQuery.get('screenshot') === 'true' ||
  flutterQuery.get('fullPage') === 'true';

let resolveFlutterReady;
let rejectFlutterReady;
window.mixWindsFlutterReady = new Promise((resolve, reject) => {
  resolveFlutterReady = resolve;
  rejectFlutterReady = reject;
});

_flutter.loader.load({
  onEntrypointLoaded: async function onEntrypointLoaded(engineInitializer) {
    try {
      const engine = await engineInitializer.initializeEngine(
        flutterUsesFullPage ? {} : { multiViewEnabled: true },
      );
      const app = await engine.runApp();
      window.mixWindsFlutterApp = app;
      resolveFlutterReady(app);
      window.dispatchEvent(
        new CustomEvent('mix-winds:flutter-ready', {
          detail: { app, multiView: !flutterUsesFullPage },
        }),
      );
    } catch (error) {
      rejectFlutterReady(error);
      window.dispatchEvent(
        new CustomEvent('mix-winds:flutter-error', { detail: { error } }),
      );
      throw error;
    }
  },
});
