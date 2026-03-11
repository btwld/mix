#!/usr/bin/env node

import fs from "node:fs";
import path from "node:path";

const docsRoot = path.resolve(process.cwd(), "src", "content", "documentation");

function fail(message) {
  console.error(`[check-docs-frontmatter] ${message}`);
  process.exit(1);
}

function listMdxFiles(dir) {
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  const files = [];

  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...listMdxFiles(fullPath));
      continue;
    }

    if (entry.isFile() && entry.name.endsWith(".mdx")) {
      files.push(fullPath);
    }
  }

  return files;
}

if (!fs.existsSync(docsRoot)) {
  fail(`Docs directory not found: ${docsRoot}`);
}

const files = listMdxFiles(docsRoot);
const errors = [];

for (const file of files) {
  const content = fs.readFileSync(file, "utf8");
  const lines = content.split(/\r?\n/);
  const relPath = path.relative(process.cwd(), file);

  if (lines[0] !== "---") {
    errors.push(`${relPath}: missing frontmatter block at top of file`);
    continue;
  }

  const frontmatterEnd = lines.indexOf("---", 1);
  if (frontmatterEnd === -1) {
    errors.push(`${relPath}: unclosed frontmatter block`);
    continue;
  }

  const frontmatter = lines.slice(1, frontmatterEnd).join("\n");
  const hasTitle = /^\s*title\s*:/m.test(frontmatter);
  const hasDescription = /^\s*description\s*:/m.test(frontmatter);

  if (!hasTitle) {
    errors.push(`${relPath}: missing frontmatter key "title"`);
  }

  if (!hasDescription) {
    errors.push(`${relPath}: missing frontmatter key "description"`);
  }
}

if (errors.length > 0) {
  console.error("[check-docs-frontmatter] Found frontmatter issues:");
  for (const error of errors) {
    console.error(`  - ${error}`);
  }
  process.exit(1);
}

console.log(`[check-docs-frontmatter] OK (${files.length} files checked)`);
