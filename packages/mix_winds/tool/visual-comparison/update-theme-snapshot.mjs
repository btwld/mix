import { createHash } from 'node:crypto';
import { readFile, writeFile } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { chromium } from 'playwright';

const EXPECTED_TAILWIND_VERSION = '4.3.1';
const SNAPSHOT_SCHEMA_VERSION = 1;

const scriptDirectory = path.dirname(fileURLToPath(import.meta.url));
const packageDirectory = path.join(
  scriptDirectory,
  'node_modules',
  '@tailwindcss',
  'browser',
);
const bundlePath = path.join(packageDirectory, 'dist', 'index.global.js');
const packagePath = path.join(packageDirectory, 'package.json');
const outputPath = path.resolve(
  scriptDirectory,
  '..',
  'tailwind_theme_snapshot.json',
);

const spacingKeys = [
  '0',
  'px',
  '0.5',
  '1',
  '1.5',
  '2',
  '2.5',
  '3',
  '3.5',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12',
  '14',
  '16',
  '20',
  '24',
  '28',
  '32',
  '36',
  '40',
  '44',
  '48',
  '52',
  '56',
  '60',
  '64',
  '72',
  '80',
  '96',
];
const radiusKeys = ['none', '', 'xs', 'sm', 'md', 'lg', 'xl', '2xl', '3xl', '4xl', 'full'];
const borderWidthKeys = ['0', '', '2', '4', '8'];
const fontSizeKeys = ['xs', 'sm', 'base', 'lg', 'xl', '2xl', '3xl', '4xl', '5xl', '6xl', '7xl', '8xl', '9xl'];
const durationKeys = ['0', '75', '100', '150', '200', '300', '500', '700', '1000'];
const scaleKeys = ['0', '50', '75', '90', '95', '100', '105', '110', '125', '150'];
const rotationKeys = ['0', '1', '2', '3', '6', '12', '45', '90', '180'];
const blurKeys = ['none', '', 'xs', 'sm', 'md', 'lg', 'xl', '2xl', '3xl'];

function utility(root, key) {
  return key === '' ? root : `${root}-${key}`;
}

function extractThemeInventory(bundle) {
  const match = bundle.match(/var Fo=`([\s\S]*?)`;var Mo=/);
  if (match === null) {
    throw new Error('Unable to locate the embedded Tailwind theme inventory.');
  }

  const declarations = new Map();
  const declarationPattern = /^\s*(--[\w-]+):\s*([^;]+);/gm;
  for (const declaration of match[1].matchAll(declarationPattern)) {
    declarations.set(declaration[1], declaration[2].trim());
  }

  return { css: match[1], declarations };
}

function variablesInNamespace(declarations, prefix) {
  const result = {};
  for (const [name, value] of declarations) {
    if (name.startsWith(prefix)) {
      result[name.slice(prefix.length)] = value;
    }
  }
  return result;
}

function addProbes(probes, namespace, keys, root, property, kind = 'number') {
  for (const key of keys) {
    probes.push({
      id: `probe-${probes.length}`,
      namespace,
      key,
      className: utility(root, key),
      property,
      kind,
    });
  }
}

const packageJson = JSON.parse(await readFile(packagePath, 'utf8'));
if (packageJson.version !== EXPECTED_TAILWIND_VERSION) {
  throw new Error(
    `Expected @tailwindcss/browser ${EXPECTED_TAILWIND_VERSION}, ` +
      `found ${packageJson.version}. Run npm ci with the checked-in lockfile.`,
  );
}

const bundle = await readFile(bundlePath, 'utf8');
const theme = extractThemeInventory(bundle);
const rawColors = variablesInNamespace(theme.declarations, '--color-');
if (Object.keys(rawColors).length !== 288) {
  throw new Error(
    `Expected 288 stock Tailwind colors, found ${Object.keys(rawColors).length}.`,
  );
}

const probes = [];
addProbes(probes, 'spacing', spacingKeys, 'w', 'width');
addProbes(probes, 'radii', radiusKeys, 'rounded', 'borderTopLeftRadius');
addProbes(probes, 'borderWidths', borderWidthKeys, 'border', 'borderTopWidth');
addProbes(probes, 'fontMetrics', fontSizeKeys, 'text', 'fontSize', 'fontMetrics');
addProbes(probes, 'durations', durationKeys, 'duration', 'transitionDuration', 'duration');
addProbes(probes, 'delays', durationKeys, 'delay', 'transitionDelay', 'duration');
addProbes(probes, 'scales', scaleKeys, 'scale', 'scale', 'scale');
addProbes(probes, 'rotations', rotationKeys, 'rotate', 'rotate', 'angle');
addProbes(probes, 'blurs', blurKeys, 'blur', 'filter', 'blur');

const probeMarkup = probes
  .map(({ id, className }) => `<div id="${id}" class="${className}">x</div>`)
  .join('');

const browser = await chromium.launch({ headless: true });
let captured;
try {
  const page = await browser.newPage();
  const pageErrors = [];
  page.on('pageerror', (error) => pageErrors.push(String(error)));
  await page.setContent(
    `<style type="text/tailwindcss">@import "tailwindcss";</style>${probeMarkup}`,
  );
  await page.addScriptTag({ path: bundlePath });
  await page.waitForFunction(
    () => document.querySelector('style:not([type])')?.textContent.includes('tailwindcss v4.3.1'),
    { timeout: 10_000 },
  );

  captured = await page.evaluate(
    ({ probes: browserProbes, rawColors: browserColors, rawBreakpoints, rawLeading, rawTracking }) => {
      const round = (value) => Math.round(value * 1e12) / 1e12;
      const numeric = (value, description) => {
        const parsed = Number.parseFloat(value);
        if (!Number.isFinite(parsed)) {
          throw new Error(`Unable to resolve ${description}: ${value}`);
        }
        return round(parsed);
      };
      const durationMilliseconds = (value, description) => {
        if (value.endsWith('ms')) return numeric(value, description);
        if (value.endsWith('s')) return round(numeric(value, description) * 1000);
        throw new Error(`Unable to resolve ${description}: ${value}`);
      };
      const lengthPixels = (value, description) => {
        const element = document.createElement('div');
        element.style.position = 'absolute';
        element.style.width = value;
        document.body.append(element);
        const resolved = numeric(getComputedStyle(element).width, description);
        element.remove();
        return resolved;
      };

      const namespaces = {
        spacing: {},
        radii: {},
        borderWidths: {},
        breakpoints: {},
        fontSizes: {},
        fontLineHeights: {},
        colors: {},
        durations: {},
        delays: {},
        scales: {},
        rotations: {},
        blurs: {},
        leading: { none: 1 },
        tracking: {},
      };

      for (const probe of browserProbes) {
        const element = document.getElementById(probe.id);
        const style = getComputedStyle(element);
        const value = style[probe.property];
        switch (probe.kind) {
          case 'fontMetrics': {
            const fontSize = numeric(style.fontSize, `${probe.className} font size`);
            const lineHeight = numeric(style.lineHeight, `${probe.className} line height`);
            namespaces.fontSizes[probe.key] = fontSize;
            namespaces.fontLineHeights[probe.key] = round(lineHeight / fontSize);
            break;
          }
          case 'duration':
            namespaces[probe.namespace][probe.key] = durationMilliseconds(
              value,
              probe.className,
            );
            break;
          case 'scale':
            namespaces.scales[probe.key] = numeric(value.split(' ')[0], probe.className);
            break;
          case 'angle':
            namespaces.rotations[probe.key] = numeric(value, probe.className);
            break;
          case 'blur': {
            const match = value.match(/^blur\(([-\d.]+)px\)$/);
            namespaces.blurs[probe.key] = value === 'none'
              ? 0
              : numeric(match?.[1] ?? value, probe.className);
            break;
          }
          default:
            namespaces[probe.namespace][probe.key] = numeric(value, probe.className);
        }
      }

      for (const [key, value] of Object.entries(rawBreakpoints)) {
        namespaces.breakpoints[key] = lengthPixels(value, `breakpoint ${key}`);
      }
      for (const [key, value] of Object.entries(rawLeading)) {
        namespaces.leading[key] = numeric(value, `leading ${key}`);
      }
      for (const [key, value] of Object.entries(rawTracking)) {
        if (!value.endsWith('em')) {
          throw new Error(`Expected em tracking for ${key}, found ${value}.`);
        }
        namespaces.tracking[key] = numeric(value, `tracking ${key}`);
      }

      const colorEntries = Object.entries(browserColors);
      const canvas = document.createElement('canvas');
      canvas.width = colorEntries.length;
      canvas.height = 1;
      const context = canvas.getContext('2d');
      for (const [index, [, value]] of colorEntries.entries()) {
        context.fillStyle = value;
        context.fillRect(index, 0, 1, 1);
      }
      const pixels = context.getImageData(0, 0, canvas.width, 1).data;
      const hex = (value) => value.toString(16).padStart(2, '0').toUpperCase();
      for (const [index, [key]] of colorEntries.entries()) {
        const offset = index * 4;
        const red = pixels[offset];
        const green = pixels[offset + 1];
        const blue = pixels[offset + 2];
        const alpha = pixels[offset + 3];
        namespaces.colors[key] = `#${hex(red)}${hex(green)}${hex(blue)}` +
          (alpha === 255 ? '' : hex(alpha));
      }
      namespaces.colors.transparent = '#00000000';

      return namespaces;
    },
    {
      probes,
      rawColors,
      rawBreakpoints: variablesInNamespace(theme.declarations, '--breakpoint-'),
      rawLeading: variablesInNamespace(theme.declarations, '--leading-'),
      rawTracking: variablesInNamespace(theme.declarations, '--tracking-'),
    },
  );

  if (pageErrors.length > 0) {
    throw new Error(`Tailwind browser errors:\n${pageErrors.join('\n')}`);
  }
} finally {
  await browser.close();
}

const snapshot = {
  meta: {
    schemaVersion: SNAPSHOT_SCHEMA_VERSION,
    package: '@tailwindcss/browser',
    tailwindVersion: packageJson.version,
    themeInventorySha256: createHash('sha256').update(theme.css).digest('hex'),
    chromiumVersion: browser.version(),
    colorEncoding: '8-bit sRGB RGBA via Chromium canvas',
    rootFontSizePx: 16,
  },
  namespaces: captured,
};

await writeFile(outputPath, `${JSON.stringify(snapshot, null, 2)}\n`);
process.stdout.write(`Wrote ${path.relative(process.cwd(), outputPath)}\n`);
