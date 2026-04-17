# Testing Strategy

The core principle: **replace, don't layer.**

When a deep module replaces a cluster of shallow modules, the old unit tests on those shallow modules become waste. They lock the implementation in place, slow down the refactor, and don't catch the bugs that actually happen — which live in how the shallow modules interact, not inside any one of them.

## What to write

Write new tests at the deepened module's interface boundary. Each test:

- Calls the public interface
- Sets up dependencies through the port (in-memory adapter, fake, or local substitute)
- Asserts on observable outcomes — return values, emitted events, persisted state visible through the same port
- Does not reach into private state or implementation details

A good boundary test survives an internal refactor. If you can move code around inside the module without changing any test, the tests are at the right level.

## What to delete

In the RFC, list the old tests that should go away. Be explicit — vague "remove obsolete tests" instructions don't get followed.

Typical candidates for deletion:

- Unit tests on private helpers that only existed to be testable
- Tests that mock collaborators inside the new module's boundary
- Tests that assert on internal data shapes the new interface no longer exposes

If a test catches a real behavior that the new boundary tests don't, keep it — and consider whether the boundary tests have a gap.

## Test environment

Write down what the tests need to run:

- **In-process**: nothing extra
- **Local-substitutable**: the substitute (PGLite, in-memory FS, etc.) and any setup it requires
- **Ports & adapters**: the in-memory adapter (your own code) plus a contract test that runs the same suite against the real adapter
- **Mock**: mock implementations of external SDKs

The contract test pattern is worth calling out for ports & adapters: the same test suite runs against both the in-memory adapter and the real one. The in-memory adapter is fast feedback; the real adapter catches drift.

## A note on coverage

Coverage numbers will dip during the refactor because you delete tests before you write replacements. Don't panic. The right metric is: are the behaviors that matter still verified? If yes, ship the refactor and let the number recover.
