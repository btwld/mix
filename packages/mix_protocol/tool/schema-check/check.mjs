// Validates every `packages/*/schema/manifest.json` suite with Ajv.
//
// Each suite names an exported JSON Schema and a fixtures file. Accept
// documents must validate; reject documents must not. The Dart golden tests
// keep those files current, so this script is the independent Draft 7 check
// and needs no Dart toolchain.

import Ajv from 'ajv';
import { readFileSync, readdirSync, existsSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const scriptDir = dirname(fileURLToPath(import.meta.url));
const repoRoot = findRepoRoot(scriptDir);
const packagesDir = join(repoRoot, 'packages');

const manifests = readdirSync(packagesDir, { withFileTypes: true })
  .filter((entry) => entry.isDirectory())
  .map((entry) => join(packagesDir, entry.name, 'schema', 'manifest.json'))
  .filter((path) => existsSync(path))
  .sort();

if (manifests.length === 0) {
  console.error(`No schema manifests found under ${packagesDir}`);
  process.exit(1);
}

let suites = 0;
let documents = 0;
const failures = [];

for (const manifestPath of manifests) {
  const manifestDir = dirname(manifestPath);
  const manifest = readJson(manifestPath);
  for (const suite of manifest.suites) {
    suites += 1;
    const label = `${relative(manifestDir)}:${suite.name}`;
    const schemaPath = resolve(manifestDir, suite.schema);
    const fixtures = readJson(resolve(manifestDir, suite.fixtures));

    let validate;
    try {
      validate = compile(readJson(schemaPath));
    } catch (error) {
      failures.push(`${label}: schema does not compile: ${error.message}`);
      continue;
    }

    for (const fixture of fixtures.accept) {
      documents += 1;
      if (!validate(fixture.payload)) {
        failures.push(
          `${label}: accept "${fixture.name}" was rejected: ` +
            ajvErrors(validate.errors),
        );
      }
    }
    for (const fixture of fixtures.reject) {
      documents += 1;
      if (validate(fixture.payload)) {
        failures.push(`${label}: reject "${fixture.name}" was accepted`);
      }
    }
  }
}

console.log(
  `Checked ${documents} documents across ${suites} suites in ${manifests.length} manifests.`,
);
if (failures.length > 0) {
  console.error(`\n${failures.length} failure(s):`);
  for (const failure of failures) console.error(`  - ${failure}`);
  process.exit(1);
}

function compile(schema) {
  const ajv = new Ajv({
    strictSchema: true,
    strictNumbers: true,
    strictTypes: true,
    strictTuples: true,
    // The breakpoint selector spells its either/or as
    // `oneOf: [{required: [...]}, ...]`, with the properties declared on the
    // parent schema. Ajv's optional strictRequired lint does not resolve
    // `required` through an applicator branch, so it rejects that spelling
    // even though it is valid.
    strictRequired: false,
    allErrors: false,
  });
  // Mix Protocol annotates the root with these vendor keywords.
  for (const keyword of [
    'x-mix-protocol-contract',
    'x-mix-protocol-version',
    'x-mix-protocol-format-version',
    'x-mix-protocol-vocabularies',
  ]) {
    ajv.addKeyword({ keyword, schemaType: ['string', 'array', 'number'] });
  }
  return ajv.compile(schema);
}

function ajvErrors(errors) {
  return (errors ?? [])
    .map((error) => `${error.instancePath || '/'} ${error.message}`)
    .join('; ');
}

function readJson(path) {
  return JSON.parse(readFileSync(path, 'utf8'));
}

function relative(path) {
  return path.slice(repoRoot.length + 1);
}

function findRepoRoot(start) {
  let current = start;
  while (!existsSync(join(current, 'melos.yaml'))) {
    const parent = dirname(current);
    if (parent === current) throw new Error('melos.yaml not found above ' + start);
    current = parent;
  }
  return current;
}
