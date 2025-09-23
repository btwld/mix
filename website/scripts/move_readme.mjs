import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const mixGeneratorSource = path.join(
  __dirname,
  "../../packages/mix_generator/README.md"
);

const mixGeneratorDestination = path.join(
  __dirname,
  "../pages/docs/tools/generator.md"
);

const mixLintSource = path.join(__dirname, "../../packages/mix_lint/README.md");

const mixLintDestination = path.join(__dirname, "../pages/docs/tools/lint.md");

// Iterate over each file
const generatorContents = fs.readFileSync(mixGeneratorSource);
const lintContents = fs.readFileSync(mixLintSource);

fs.writeFileSync(mixGeneratorDestination, generatorContents);
fs.writeFileSync(mixLintDestination, lintContents);
