export interface PreviewManifestEntry {
  previewId: string;
  sourcePath: string;
  snippetRegion?: string | null;
  title?: string;
  description?: string;
  category?: string;
  renderable?: boolean;
}

interface PreviewManifest {
  version: number;
  generatedAt: string;
  entries: PreviewManifestEntry[];
}

const MANIFEST_FILE = "previews-manifest.json";
const manifestCache = new Map<string, Promise<PreviewManifest>>();

function buildManifestUrl(basePath: string): string {
  const normalizedBasePath = basePath.replace(/\/$/, "");
  // Cache strategy:
  // - Canonical manifest URL: {basePath}/previews-manifest.json
  // - Optional build id query suffix to prevent stale CDN/browser caches
  // - fetch(..., { cache: "no-store" }) to always refresh on hard deploy edges
  const buildId =
    process.env.NEXT_PUBLIC_VERCEL_GIT_COMMIT_SHA ??
    process.env.NEXT_PUBLIC_BUILD_ID ??
    "";
  const suffix = buildId ? `?v=${encodeURIComponent(buildId)}` : "";
  return `${normalizedBasePath}/${MANIFEST_FILE}${suffix}`;
}

export async function loadPreviewManifest(
  basePath: string = "/previews"
): Promise<PreviewManifest> {
  const cacheKey = basePath.replace(/\/$/, "");

  if (!manifestCache.has(cacheKey)) {
    const manifestPromise = fetchPreviewManifest(basePath).catch((error) => {
      manifestCache.delete(cacheKey);
      throw error;
    });
    manifestCache.set(cacheKey, manifestPromise);
  }

  return manifestCache.get(cacheKey)!;
}

export async function findPreviewManifestEntry(
  previewId: string,
  basePath: string = "/previews"
): Promise<PreviewManifestEntry | null> {
  const manifest = await loadPreviewManifest(basePath);
  return manifest.entries.find((entry) => entry.previewId === previewId) ?? null;
}

async function fetchPreviewManifest(basePath: string): Promise<PreviewManifest> {
  const response = await fetch(buildManifestUrl(basePath), { cache: "no-store" });

  if (!response.ok) {
    throw new Error(`Failed to load previews manifest (${response.status})`);
  }

  const payload = await response.json();
  return validateManifest(payload);
}

function validateManifest(payload: unknown): PreviewManifest {
  if (!payload || typeof payload !== "object") {
    throw new Error("Invalid previews manifest payload");
  }

  const candidate = payload as Record<string, unknown>;
  if (!Array.isArray(candidate.entries)) {
    throw new Error("Invalid previews manifest: missing entries");
  }

  const seenPreviewIds = new Set<string>();

  const entries = candidate.entries.map((entry) => {
    if (!entry || typeof entry !== "object") {
      throw new Error("Invalid previews manifest entry");
    }

    const record = entry as Record<string, unknown>;
    const previewId = record.previewId;
    const sourcePath = record.sourcePath;

    if (typeof previewId !== "string" || !previewId) {
      throw new Error("Invalid previews manifest entry: previewId");
    }

    if (typeof sourcePath !== "string" || !sourcePath) {
      throw new Error(`Invalid previews manifest entry for ${previewId}: sourcePath`);
    }

    if (seenPreviewIds.has(previewId)) {
      throw new Error(`Invalid previews manifest: duplicate previewId "${previewId}"`);
    }

    seenPreviewIds.add(previewId);

    return {
      previewId,
      sourcePath,
      snippetRegion:
        typeof record.snippetRegion === "string" ? record.snippetRegion : undefined,
      title: typeof record.title === "string" ? record.title : undefined,
      description: typeof record.description === "string" ? record.description : undefined,
      category: typeof record.category === "string" ? record.category : undefined,
      renderable:
        typeof record.renderable === "boolean" ? record.renderable : undefined,
    } satisfies PreviewManifestEntry;
  });

  return {
    version: typeof candidate.version === "number" ? candidate.version : 1,
    generatedAt:
      typeof candidate.generatedAt === "string"
        ? candidate.generatedAt
        : new Date(0).toISOString(),
    entries,
  };
}
