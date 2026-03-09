#!/usr/bin/env node

import fs from "node:fs";
import path from "node:path";

const demosDir = resolveDemosDir(process.argv[2]);
const manifestPath = path.join(demosDir, "previews-manifest.json");
const sourcesRoot = path.join(demosDir, "sources");

function fail(message) {
  console.error(`[check-previews-manifest] ${message}`);
  process.exit(1);
}

function normalizeSourcePath(value) {
  if (typeof value !== "string" || !value.trim()) return null;

  const normalized = value.trim().replace(/\\/g, "/").replace(/^\/+/, "");
  if (!normalized || normalized.includes("\0")) return null;

  const segments = normalized.split("/").filter(Boolean);
  if (segments.length === 0) return null;
  if (segments.some((segment) => segment === "." || segment === "..")) {
    return null;
  }

  return segments.join("/");
}

function resolveDemosDir(inputDir) {
  if (inputDir) {
    return path.resolve(inputDir);
  }

  const candidates = [
    path.resolve(path.join(process.cwd(), "public", "previews")),
    path.resolve(
      path.join(process.cwd(), "..", "packages", "mix_docs_preview", "build", "web"),
    ),
  ];

  for (const candidate of candidates) {
    if (fs.existsSync(path.join(candidate, "previews-manifest.json"))) {
      return candidate;
    }
  }

  fail(
    "Manifest not found. Build previews first via packages/mix_docs_preview/scripts/build_web_previews.sh",
  );
}

const payload = JSON.parse(fs.readFileSync(manifestPath, "utf8"));
if (!payload || typeof payload !== "object" || !Array.isArray(payload.entries)) {
  fail("Invalid manifest format: missing entries array");
}

const entries = payload.entries;
if (entries.length === 0) {
  fail("Manifest has no entries");
}

const previewIds = new Set();
const byPreviewId = new Map();

for (const entry of entries) {
  if (!entry || typeof entry !== "object") {
    fail("Manifest contains a non-object entry");
  }

  const previewId = entry.previewId;
  const sourcePath = normalizeSourcePath(entry.sourcePath);

  if (typeof previewId !== "string" || !previewId) {
    fail(`Invalid previewId entry: ${String(previewId)}`);
  }

  if (!sourcePath) {
    fail(`Invalid sourcePath for previewId "${previewId}"`);
  }

  if (previewIds.has(previewId)) {
    fail(`Duplicate previewId found: ${previewId}`);
  }

  const sourceFile = path.join(sourcesRoot, ...sourcePath.split("/"));
  if (!fs.existsSync(sourceFile)) {
    fail(`Missing source file for "${previewId}": ${sourceFile}`);
  }

  previewIds.add(previewId);
  byPreviewId.set(previewId, { sourcePath, sourceFile });
}

const smokePreviewId = "overview/introduction.0";
if (!byPreviewId.has(smokePreviewId)) {
  fail(`Smoke check failed: missing "${smokePreviewId}" previewId`);
}

const smokeEntry = byPreviewId.get(smokePreviewId);
if (!fs.existsSync(smokeEntry.sourceFile)) {
  fail(
    `Smoke check failed: missing source for "${smokePreviewId}" at ${smokeEntry.sourceFile}`,
  );
}

console.log(
  `[check-previews-manifest] OK (${entries.length} entries, smoke previewId "${smokePreviewId}")`,
);
