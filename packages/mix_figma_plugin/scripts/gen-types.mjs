import { compile } from 'json-schema-to-typescript';
import { readFile, writeFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const packageRoot = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const schemaDirectory = path.resolve(packageRoot, '../mix_protocol/schema');
const generatedDirectory = path.join(packageRoot, 'src/generated');

const schemas = [
  {
    input: 'theme.schema.json',
    output: 'theme.schema.d.ts',
    rootName: 'MixProtocolThemeDocument',
  },
  {
    input: 'style.schema.json',
    output: 'style.schema.d.ts',
    rootName: 'MixProtocolStyleDocument',
    includeDefinitions: true,
  },
];

for (const definition of schemas) {
  const sourcePath = path.join(schemaDirectory, definition.input);
  const schema = JSON.parse(await readFile(sourcePath, 'utf8'));
  const declaration = await compile(schema, definition.rootName, {
    bannerComment: [
      '/**',
      ` * Generated from packages/mix_protocol/schema/${definition.input}.`,
      ' * Do not edit by hand; run `npm run gen:types`.',
      ' */',
    ].join('\n'),
    cwd: schemaDirectory,
    enableConstEnums: false,
    format: true,
    unreachableDefinitions: definition.includeDefinitions ?? false,
    unknownAny: false,
  });

  await writeFile(path.join(generatedDirectory, definition.output), declaration, 'utf8');
}
