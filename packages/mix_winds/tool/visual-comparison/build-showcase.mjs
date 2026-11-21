#!/usr/bin/env node
import { spawnSync } from 'node:child_process';
import path from 'node:path';
import process from 'node:process';
import { fileURLToPath } from 'node:url';

import { prepareShowcase } from './prepare-showcase.mjs';

const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const exampleRoot = path.resolve(scriptDir, '../../example');

const prepared = prepareShowcase();
console.log(
  `Prepared ${prepared.exampleCount} showcase examples; building Flutter web release…`,
);

const result = spawnSync(
  'fvm',
  ['flutter', 'build', 'web', '--release', ...process.argv.slice(2)],
  { cwd: exampleRoot, stdio: 'inherit' },
);

if (result.error) throw result.error;
if (result.status !== 0) process.exitCode = result.status ?? 1;
else console.log(`Showcase build: ${path.join(exampleRoot, 'build', 'web')}`);
