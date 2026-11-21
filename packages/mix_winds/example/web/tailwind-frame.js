import {
  extractShowcaseRegion,
  loadShowcaseManifest,
  presentationTailwindSource,
} from './showcase-source.js';

const root = document.querySelector('#reference-root');

try {
  const manifest = await loadShowcaseManifest();
  const requestedId = new URLSearchParams(window.location.search).get('example');
  const example =
    manifest.examples.find((candidate) => candidate.id === requestedId) ??
    manifest.examples[0];
  const response = await fetch(
    new URL('assets/real_tailwind/advanced-examples.html', document.baseURI),
  );
  if (!response.ok) throw new Error(`Source returned ${response.status}.`);

  const source = await response.text();
  root.innerHTML = presentationTailwindSource(
    extractShowcaseRegion(source, example.slug),
  );

  const compiler = document.createElement('script');
  compiler.src = new URL(
    'generated/tailwindcss-browser.js',
    document.baseURI,
  ).href;
  compiler.addEventListener('load', () => {
    document.documentElement.dataset.ready = 'true';
    window.parent.postMessage(
      { type: 'mix-winds:reference-ready', exampleId: example.id },
      '*',
    );
  });
  compiler.addEventListener('error', () => {
    const message = 'The local Tailwind browser compiler is unavailable.';
    root.innerHTML = `<p class="reference-error">${message}</p>`;
    window.parent.postMessage(
      { type: 'mix-winds:reference-error', message },
      '*',
    );
  });
  document.head.append(compiler);
} catch (error) {
  root.innerHTML = `<p class="reference-error">${String(error.message ?? error)}</p>`;
  window.parent.postMessage(
    { type: 'mix-winds:reference-error', message: String(error) },
    '*',
  );
}
