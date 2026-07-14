import assert from "node:assert/strict";
import test from "node:test";

async function render() {
  const workerUrl = new URL("../dist/server/index.js", import.meta.url);
  workerUrl.searchParams.set("test", `${process.pid}-${Date.now()}`);
  const { default: worker } = await import(workerUrl.href);

  return worker.fetch(
    new Request("http://localhost/", {
      headers: { accept: "text/html" },
    }),
    {
      ASSETS: {
        fetch: async () => new Response("Not found", { status: 404 }),
      },
    },
    {
      waitUntil() {},
      passThroughOnException() {},
    },
  );
}

test("server-renders the Mix performance report", async () => {
  const response = await render();
  assert.equal(response.status, 200);
  assert.match(response.headers.get("content-type") ?? "", /^text\/html\b/i);

  const html = await response.text();
  assert.match(html, /<title>Mix Rendering Performance/);
  assert.match(html, /The static overhead is real/);
  assert.match(html, /218\.10/);
  assert.match(html, /Flutter, Mix, optimized Mix/);
  assert.match(html, /Two notifications, one resolution/);
  assert.match(html, /Keep the optimization/);
  assert.doesNotMatch(html, /codex-preview|react-loading-skeleton|Your site is taking shape/);
});

test("renders all benchmark scenarios and evidence cautions", async () => {
  const response = await render();
  const html = await response.text();

  for (const scenario of ["S0", "S0I", "S1", "S1I", "S2"]) {
    assert.match(html, new RegExp(`>${scenario}<`));
  }

  assert.match(html, /Variant evaluation \+ merge/);
  assert.match(html, /physical mobile devices/i);
  assert.match(html, /No broad mobile or energy claim/);
});
