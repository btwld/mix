import { build } from 'esbuild';
import { mkdir, readFile, writeFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const packageRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const distDirectory = path.join(packageRoot, 'dist');

await mkdir(distDirectory, { recursive: true });

await build({
  entryPoints: [path.join(packageRoot, 'src/main.ts')],
  outfile: path.join(distDirectory, 'code.js'),
  bundle: true,
  format: 'iife',
  platform: 'browser',
  target: 'es2017',
  logLevel: 'info',
});

const uiBuild = await build({
  entryPoints: [path.join(packageRoot, 'src/ui/main.ts')],
  bundle: true,
  format: 'iife',
  platform: 'browser',
  target: 'es2017',
  minify: true,
  write: false,
  logLevel: 'silent',
});

const uiJavaScript = uiBuild.outputFiles[0]?.text;
if (uiJavaScript === undefined) {
  throw new Error('esbuild did not produce the UI JavaScript bundle.');
}

const uiTemplate = await readFile(path.join(packageRoot, 'src/ui/index.html'), 'utf8');
const uiHtml = uiTemplate.replace('/*__MIX_FIGMA_UI_SCRIPT__*/', uiJavaScript);

if (uiHtml === uiTemplate) {
  throw new Error('UI template is missing the inline script marker.');
}

await writeFile(path.join(distDirectory, 'ui.html'), uiHtml, 'utf8');
