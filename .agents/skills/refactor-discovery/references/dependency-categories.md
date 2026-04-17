# Dependency Categories

When you assess a candidate for deepening, classify its dependencies. The category drives how you handle the boundary in the proposed interface and how you write tests.

## 1. In-process

Pure computation, in-memory state, no I/O.

**Always deepenable.** Merge the modules and test directly. There is no boundary to negotiate — the only question is what the interface should look like.

Examples: a pricing calculator, a parser, a state machine that mutates an in-memory struct.

## 2. Local-substitutable

Dependencies that have realistic local stand-ins for tests.

**Deepenable when the substitute exists or is cheap to add.** The deepened module is tested with the local stand-in running in the test suite — no mocks at the call site.

Examples:

- Postgres → PGLite or testcontainers
- Filesystem → in-memory FS (`memfs`, `pyfakefs`)
- Redis → embedded Redis or `fakeredis`
- HTTP server → spin up an in-process instance for tests

If no substitute exists, treat it as case 3 or 4.

## 3. Remote but owned (Ports & Adapters)

Your own services across a network boundary — microservices, internal APIs, queues you publish to.

**Define a port at the module boundary.** The deep module owns the logic; the transport is injected. Tests use an in-memory adapter that satisfies the port. Production uses the real HTTP/gRPC/queue adapter.

Recommendation shape for the RFC:

> Define a shared interface (port). Implement an HTTP adapter for production and an in-memory adapter for testing, so the logic can be tested as one deep module even though it's deployed across a network boundary.

This is the highest-leverage category. It's also the easiest to get wrong by leaking transport concerns (HTTP status codes, retry policies) through the port.

## 4. True external (Mock)

Third-party services you don't control — Stripe, Twilio, OpenAI, Salesforce.

**Mock at the boundary.** The deepened module takes the external dependency as an injected port. Tests provide a mock implementation that returns canned responses or asserts on calls.

Tempting but wrong: writing tests against a sandbox environment of the third party. Sandboxes are flaky, slow, and rate-limited. Use them in a small contract-test layer, not throughout the suite.

## How to use these categories in step 2

When you list candidates for the user, tag each candidate with its category. The category sets expectations for what the refactor will require:

- **In-process** — small, contained refactor; mostly a code-move plus test rewrites
- **Local-substitutable** — same scope, plus standing up the substitute if it's missing
- **Ports & adapters** — bigger; introduces a port, two adapters, and a wiring change at the composition root
- **True external** — similar to ports & adapters, but the production adapter already exists somewhere

If a candidate spans two categories (common — e.g., one module talks to Postgres and Stripe), call out both and propose handling them separately.
