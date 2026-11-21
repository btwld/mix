import {
  escapeHtml,
  extractShowcaseRegion,
  highlightDartSource,
  loadParityData,
  loadShowcaseManifest,
  loadShowcaseSources,
  presentationTailwindSource,
} from './showcase-source.js';

const VALID_WIDTHS = new Set([480, 768, 1024]);

const elements = {
  average: document.querySelector('#showcase-average'),
  copyStatus: document.querySelector('#copy-status'),
  description: document.querySelector('#example-description'),
  eyebrow: document.querySelector('#example-eyebrow'),
  features: document.querySelector('#example-features'),
  flutterPreview: document.querySelector('#flutter-preview'),
  flutterSource: document.querySelector('#flutter-source'),
  flutterStatus: document.querySelector('#flutter-status'),
  mobileSelect: document.querySelector('#mobile-example-select'),
  navigation: document.querySelector('#example-navigation'),
  parityContent: document.querySelector('#parity-content'),
  proof: document.querySelector('#example-proof'),
  sourceUtility: document.querySelector('#source-utility'),
  tailwindPreview: document.querySelector('#tailwind-preview'),
  tailwindSource: document.querySelector('#tailwind-source'),
  title: document.querySelector('#example-title'),
  viewportControl: document.querySelector('#viewport-control'),
};

const model = {
  flutterApp: null,
  flutterError: null,
  flutterViewId: null,
  manifest: null,
  mountedExampleId: null,
  parity: null,
  sources: null,
  state: null,
  viewRevision: 0,
};

if (!document.documentElement.classList.contains('flutter-full-page')) {
  startShowcase().catch(showFatalError);
}

async function startShowcase() {
  const [manifest, sources, parity] = await Promise.all([
    loadShowcaseManifest(),
    loadShowcaseSources(),
    loadParityData(),
  ]);

  model.manifest = manifest;
  model.sources = sources;
  model.parity = parity;
  validateManifest(manifest);
  model.state = readStateFromUrl();

  renderNavigation();
  bindControls();
  render();
  observePreviewSizing();
  connectFlutter();
}

function validateManifest(manifest) {
  if (!Array.isArray(manifest?.examples) || manifest.examples.length === 0) {
    throw new Error('The showcase manifest does not contain any examples.');
  }

  const ids = new Set();
  const slugs = new Set();
  for (const example of manifest.examples) {
    if (!example.id || !example.slug || ids.has(example.id) || slugs.has(example.slug)) {
      throw new Error('Every showcase example needs a unique id and slug.');
    }
    ids.add(example.id);
    slugs.add(example.slug);
    extractShowcaseRegion(model.sources?.tailwind ?? '', example.slug);
    extractShowcaseRegion(model.sources?.flutter ?? '', example.slug);
  }
}

function readStateFromUrl() {
  const query = new URLSearchParams(window.location.search);
  const examples = model.manifest.examples;
  const requestedExample = query.get('example');
  const example =
    examples.find(
      (candidate) =>
        candidate.id === requestedExample || candidate.slug === requestedExample,
    ) ?? examples[0];
  const requestedWidth = Number(query.get('width'));

  return {
    exampleId: example.id,
    width: VALID_WIDTHS.has(requestedWidth) ? requestedWidth : 768,
  };
}

function renderNavigation() {
  elements.navigation.replaceChildren(
    ...model.manifest.examples.map((example) => {
      const button = document.createElement('button');
      button.type = 'button';
      button.className = 'example-nav-button';
      button.dataset.exampleId = example.id;
      button.innerHTML = `
        <span class="example-index">${escapeHtml(example.id)}</span>
        <span class="example-nav-title">${escapeHtml(example.title)}</span>
      `;
      return button;
    }),
  );

  elements.mobileSelect.replaceChildren(
    ...model.manifest.examples.map((example) => {
      const option = document.createElement('option');
      option.value = example.id;
      option.textContent = `${example.id} — ${example.title}`;
      return option;
    }),
  );
}

function bindControls() {
  elements.navigation.addEventListener('click', (event) => {
    const button = event.target.closest('[data-example-id]');
    if (!button) return;
    updateState({ exampleId: button.dataset.exampleId });
  });

  elements.mobileSelect.addEventListener('change', () => {
    updateState({ exampleId: elements.mobileSelect.value });
  });

  elements.viewportControl.addEventListener('click', (event) => {
    const button = event.target.closest('[data-width]');
    if (!button) return;
    updateState({ width: Number(button.dataset.width) });
  });

  elements.parityContent.addEventListener('click', (event) => {
    const button = event.target.closest('[data-parity-width]');
    if (!button) return;
    updateState({ width: Number(button.dataset.parityWidth) });
  });

  document.querySelectorAll('[data-copy]').forEach((button) => {
    button.addEventListener('click', () => copySource(button.dataset.copy));
  });

  window.addEventListener('popstate', () => {
    model.state = readStateFromUrl();
    render({ replaceUrl: false });
  });

  window.addEventListener('message', (event) => {
    if (event.source !== elements.tailwindPreview.contentWindow) return;
    if (event.data?.type === 'mix-winds:reference-error') {
      elements.flutterStatus.textContent = 'Tailwind reference failed to load';
      elements.flutterStatus.dataset.ready = 'false';
    }
  });
}

function updateState(patch) {
  model.state = { ...model.state, ...patch };
  render();
}

function render({ replaceUrl = true } = {}) {
  const example = selectedExample();
  renderExampleHeader(example);
  renderActiveWidth();
  renderSources(example);
  renderParity(example);
  renderPreviewStructure(example);
  renderAverage();
  if (replaceUrl) writeStateToUrl();
  queuePreviewSizing();
  void renderFlutterView();
}

function renderExampleHeader(example) {
  elements.eyebrow.textContent = example.eyebrow;
  elements.title.textContent = example.title;
  elements.description.textContent = example.description;
  elements.sourceUtility.textContent = example.signatureUtility;
  elements.features.replaceChildren(
    ...example.features.map((feature) => {
      const item = document.createElement('span');
      item.className = 'feature-pill';
      item.textContent = feature;
      return item;
    }),
  );

  const parity = parityFor(example);
  const passed = parity?.acceptance?.passed === true;
  const worst = parity
    ? Math.max(...parity.results.map((result) => result.diffPercent))
    : null;
  elements.proof.textContent = passed
    ? `Verified · worst delta ${formatPercent(worst)}`
    : 'Visual evidence unavailable';

  document.title = `${example.title} — mix_winds showcase`;
  elements.mobileSelect.value = example.id;
  document.querySelectorAll('[data-example-id]').forEach((button) => {
    button.setAttribute(
      'aria-current',
      String(button.dataset.exampleId === example.id),
    );
  });
}

function renderActiveWidth() {
  elements.viewportControl.querySelectorAll('[data-width]').forEach((button) => {
    button.setAttribute(
      'aria-pressed',
      String(Number(button.dataset.width) === model.state.width),
    );
  });
}

function renderSources(example) {
  const tailwind = presentationTailwindSource(
    extractShowcaseRegion(model.sources.tailwind, example.slug),
  );
  const flutter = extractShowcaseRegion(model.sources.flutter, example.slug);

  elements.tailwindSource.dataset.rawSource = tailwind;
  elements.flutterSource.dataset.rawSource = flutter;
  elements.tailwindSource.innerHTML = highlightSignatureUtility(
    tailwind,
    example.signatureUtility,
  );
  elements.flutterSource.innerHTML = highlightDartSource(
    flutter,
    example.signatureUtility,
  );
}

function renderParity(example) {
  const parity = parityFor(example);
  if (!parity) {
    elements.parityContent.innerHTML = `
      <div class="parity-empty">
        <h3>Evidence is generated at build time.</h3>
        <p>Run the advanced visual-comparison suite, then prepare the showcase to publish its source-backed screenshots and metrics.</p>
      </div>
    `;
    return;
  }

  const result = parity.results.find((candidate) => candidate.width === model.state.width);
  if (!result) {
    elements.parityContent.innerHTML = '<div class="parity-empty"><h3>This viewport has no capture.</h3></div>';
    return;
  }

  const threshold = parity.acceptance.maximumByWidth[String(result.width)];
  const files = result.files;
  elements.parityContent.innerHTML = `
    <div class="parity-intro">
      <div>
        <p class="eyebrow">Measured evidence · ${result.width}px viewport</p>
        <h3>${result.diffPercent <= threshold ? 'Parity contract passed' : 'Parity contract failed'}</h3>
      </div>
      <div class="parity-intro-controls">
        <div class="parity-widths" role="group" aria-label="Parity viewport">
          ${[480, 768, 1024]
            .map(
              (width) =>
                `<button type="button" data-parity-width="${width}" aria-pressed="${width === result.width}">${width}</button>`,
            )
            .join('')}
        </div>
        <span class="parity-pass">${formatPercent(result.diffPercent)} / ${formatPercent(threshold)} max</span>
      </div>
    </div>
    <div class="parity-grid">
      ${parityFigure(files.tailwind, 'Tailwind reference', `${result.dimensions.tailwind.width} × ${result.dimensions.tailwind.height}`)}
      ${parityFigure(files.flutter, 'Native Flutter', `${result.dimensions.flutter.width} × ${result.dimensions.flutter.height}`)}
    </div>
    <div class="metric-grid">
      ${metric('Tolerant delta', formatPercent(result.diffPercent), 'Acceptance metric')}
      ${metric('Strict delta', formatPercent(result.strictDiffPercent), 'Diagnostic')}
      ${metric('Exact pixel delta', formatPercent(result.exactDiffPercent), 'Diagnostic')}
    </div>
    <div class="parity-artifacts">
      <a href="${escapeHtml(files.pixelmatchDiff)}" target="_blank" rel="noreferrer">Open tolerant diff</a>
      <a href="${escapeHtml(files.strictPixelmatchDiff)}" target="_blank" rel="noreferrer">Open strict diff</a>
      <a href="${escapeHtml(files.blink)}" target="_blank" rel="noreferrer">Open blink comparison</a>
    </div>
    <p class="parity-note">The enforced score is the tolerant pixel delta (≤ ${formatPercent(threshold)} at every canonical viewport). Strict and exact comparisons remain visible as diagnostics because font rasterization, anti-aliasing, and gradient sampling differ between browser and Flutter renderers.</p>
  `;
}

function renderPreviewStructure(example) {
  const frameUrl = new URL('tailwind-frame.html', document.baseURI);
  frameUrl.searchParams.set('example', example.id);
  if (elements.tailwindPreview.src !== frameUrl.href) {
    elements.tailwindPreview.src = frameUrl.href;
  }
}

async function connectFlutter() {
  try {
    model.flutterApp = await waitForFlutterApp();
    updateFlutterStatus();
    await renderFlutterView();
  } catch (error) {
    model.flutterError = error;
    elements.flutterStatus.textContent = 'Flutter engine could not start';
    elements.flutterStatus.dataset.ready = 'false';
    console.error(error);
  }
}

function waitForFlutterApp() {
  if (window.mixWindsFlutterApp) {
    return Promise.resolve(window.mixWindsFlutterApp);
  }
  if (window.mixWindsFlutterReady) return window.mixWindsFlutterReady;

  return new Promise((resolve, reject) => {
    window.addEventListener(
      'mix-winds:flutter-ready',
      (event) => resolve(event.detail.app),
      { once: true },
    );
    window.addEventListener(
      'mix-winds:flutter-error',
      (event) => reject(event.detail.error),
      { once: true },
    );
  });
}

async function renderFlutterView() {
  const revision = ++model.viewRevision;
  if (!model.flutterApp) {
    updateFlutterStatus();
    return;
  }

  if (
    model.flutterViewId !== null &&
    model.mountedExampleId === model.state.exampleId
  ) {
    updateFlutterStatus();
    return;
  }

  removeFlutterView();
  await nextFrame();
  if (revision !== model.viewRevision) return;

  model.flutterViewId = model.flutterApp.addView({
    hostElement: elements.flutterPreview,
    initialData: { exampleId: model.state.exampleId },
  });
  model.mountedExampleId = model.state.exampleId;
  updateFlutterStatus();
}

function removeFlutterView() {
  if (model.flutterApp && model.flutterViewId !== null) {
    try {
      model.flutterApp.removeView(model.flutterViewId);
    } catch (error) {
      console.warn(`Could not remove Flutter view ${model.flutterViewId}.`, error);
    }
  }
  model.flutterViewId = null;
  model.mountedExampleId = null;
  elements.flutterPreview.replaceChildren();
}

function updateFlutterStatus() {
  if (model.flutterError) return;
  if (!model.flutterApp) {
    elements.flutterStatus.textContent = 'Starting Flutter engine…';
    elements.flutterStatus.dataset.ready = 'false';
    return;
  }
  const count = model.flutterViewId === null ? 0 : 1;
  elements.flutterStatus.textContent = `Flutter engine ready · ${count} ${count === 1 ? 'view' : 'views'} mounted`;
  elements.flutterStatus.dataset.ready = 'true';
}

function observePreviewSizing() {
  const observer = new ResizeObserver(queuePreviewSizing);
  observer.observe(document.querySelector('#panel-preview'));
}

function queuePreviewSizing() {
  requestAnimationFrame(sizePreviews);
}

function sizePreviews() {
  if (!model.state) return;
  const example = selectedExample();
  const height = example.previewHeights[String(model.state.width)];
  document.querySelectorAll('#single-preview .scaled-preview').forEach((container) => {
    sizePreview(container, model.state.width, height);
  });
}

function sizePreview(container, width, height) {
  const inner = container.querySelector('.scaled-preview-inner');
  if (!inner || container.clientWidth === 0) return;
  const scale = Math.min(1, container.clientWidth / width);
  inner.style.width = `${width}px`;
  inner.style.height = `${height}px`;
  inner.style.transform = `scale(${scale})`;
  container.style.height = `${Math.ceil(height * scale)}px`;
}

async function copySource(kind) {
  const source = kind === 'tailwind' ? elements.tailwindSource : elements.flutterSource;
  try {
    await navigator.clipboard.writeText(source.dataset.rawSource ?? source.textContent);
    showCopyStatus(kind === 'tailwind' ? 'HTML copied' : 'Dart copied');
  } catch {
    showCopyStatus('Clipboard access was unavailable');
  }
}

let copyTimer;
function showCopyStatus(message) {
  clearTimeout(copyTimer);
  elements.copyStatus.textContent = message;
  elements.copyStatus.dataset.visible = 'true';
  copyTimer = setTimeout(() => {
    elements.copyStatus.dataset.visible = 'false';
  }, 1800);
}

function renderAverage() {
  const values = model.parity?.examples?.flatMap((example) =>
    example.results.map((result) => result.diffPercent),
  );
  elements.average.textContent = values?.length
    ? formatPercent(values.reduce((total, value) => total + value, 0) / values.length)
    : '—';
}

function writeStateToUrl() {
  const url = new URL(window.location.href);
  url.searchParams.set('example', selectedExample().slug);
  url.searchParams.set('width', String(model.state.width));
  url.searchParams.delete('layout');
  url.searchParams.delete('view');
  history.replaceState(null, '', url);
}

function selectedExample() {
  return (
    model.manifest.examples.find(
      (example) => example.id === model.state.exampleId,
    ) ?? model.manifest.examples[0]
  );
}

function parityFor(example) {
  return model.parity?.examples?.find((candidate) => candidate.slug === example.slug) ?? null;
}

function highlightSignatureUtility(source, utility) {
  const escapedSource = escapeHtml(source);
  const escapedUtility = escapeHtml(utility);
  return escapedSource.includes(escapedUtility)
    ? escapedSource.replace(
        escapedUtility,
        `<mark class="utility-match">${escapedUtility}</mark>`,
      )
    : escapedSource;
}

function parityFigure(source, label, dimensions) {
  return `
    <figure class="parity-frame">
      <figcaption><span>${escapeHtml(label)}</span><span>${escapeHtml(dimensions)}</span></figcaption>
      <img src="${escapeHtml(source)}" alt="${escapeHtml(label)} capture at ${model.state.width} pixels" loading="lazy">
    </figure>
  `;
}

function metric(label, value, detail) {
  return `<div><small>${escapeHtml(label)}</small><strong>${escapeHtml(value)}</strong><span>${escapeHtml(detail)}</span></div>`;
}

function formatPercent(value) {
  return Number.isFinite(value) ? `${Number(value).toFixed(2)}%` : '—';
}

function nextFrame() {
  return new Promise((resolve) => requestAnimationFrame(resolve));
}

function showFatalError(error) {
  console.error(error);
  const workspace = document.querySelector('#showcase-workspace');
  if (!workspace) return;
  workspace.innerHTML = `
    <div class="fatal-error">
      <p class="eyebrow">Showcase initialization error</p>
      <h2>The source-backed showcase could not start.</h2>
      <p>${escapeHtml(error?.message ?? String(error))}</p>
    </div>
  `;
}
