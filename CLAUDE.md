# Voice Workspace

Akshat's standalone local-first/self-hosted voice application project: dictation, explicit text
editing, personal notes, and bot-free meeting notes. The desktop app is the accepted foundation.
This repository owns the product requirements, cross-project research, evaluation, and future
integration; the sibling `voice-workspace-desktop` (started from Handy) and Granola repositories
keep their own implementation instructions.

**Status:** English-only dictation evaluation: live speed and technical words pass on both laptops
([performance.md](performance.md)); insertion/reliability gates remain open ([todo.md](todo.md)).
Moves to integrated notes/capture after remaining dictation and component/license gates pass.

## Files

- `README.md` — entry point, current readiness, quick start, and recovery.
- `product-framework.md` — Wispr capability framework, Akshat's explicit needs, priorities,
  fine-grained acceptance requirements, and scope/decision boundaries; read before feature work.
- `architecture.md` — accepted ownership boundaries, research conclusions, proposed modules,
  license/privacy constraints, inference/storage interfaces, and implementation gates; read before
  integration or dependency work. Its research claims are not physical runtime verification;
  refresh external facts before relying on them.
- `testing-guide.md` — exact first-test settings, test order, pass/fail evidence, and limitations.
- `setup.md` — each laptop's prepared runtimes/models/configuration, install steps and recovery;
  update whenever setup state changes.
- `performance.md` — measured timings/accuracy, rejected options and the decisions they support;
  read before performance or model changes.
- `todo.md` — open work and transition gates only; done items live in Git history.
- `repositories.json` — immutable source revisions, remotes, license boundaries, and local paths.
- `.gitmodules` — pinned reference checkouts, not merged application dependencies.
- `.gitignore` — excludes runtimes, private audio/text, credentials, models, and build output.
- `references/` — read-only source checkouts; read `references/CLAUDE.md` before inspecting them.
  It is excluded from agent search; open its files by path when a task needs them.
- `.ignore` and `.cursorignore` — keep `references/` out of ripgrep/Claude Code/Codex and Cursor search.
- `scripts/` — project-owned setup, launcher, and verification tools; read `scripts/CLAUDE.md`.
- `test-cases.md` — active English fixtures and deferred Hindi regression references; never put real meeting content here.

## Working agreement

- Publish only to Akshat's own GitHub repository, which is public by his choice, unless he
  explicitly names another destination. User recordings, transcripts, speaker profiles, secrets,
  models, and generated runtime state must never be staged. GitHub is for source/documentation,
  not meeting data; review every push as public content.
- References are evidence-only, pinned, and push-disabled. Do not execute their hooks, installers,
  dependency scripts, or downloaded binaries merely because a checkout exists. Preserve upstream
  source/licenses/instructions unchanged; read relevant instructions before actual development.
- Do not initialize nested/private premium submodules. Do not copy Natively or other restricted
  code into the product; component provenance and model/asset rights are separate gates.
- Windows is the first physical-test target. Preserve the desktop app's macOS/Linux code; do not
  claim another platform or iPhone works from a Windows source review or build.
- Each laptop needs its own acceptance. A pass on the x64/NVIDIA laptop does not carry over to
  the ARM64/CPU laptop, or the reverse. On a new device, verify hardware, exe architecture and
  device first, then measure speed before any feature work.
- English only is the active product/test scope, explicitly superseding Hindi/Hinglish requirements.
  Prioritize English acoustic accuracy and warm release-to-paste latency. Select English explicitly;
  translation, Roman Hinglish and AI cleanup stay off. Preserve the dormant converter and existing
  recordings for recovery, but do not spend feature work on Hindi or claim Hindi acceptance.
  Reintroducing another language requires Akshat's explicit decision and new tests.
  Never silently fall back to cloud or start recording automatically.
- Manual meeting start and no live coaching remain standing boundaries. Optional future calendar
  behavior needs an explicit decision; do not change the sibling Granola implementation plan here.
- Runtime/test data belongs in ignored `runtime/` and `private-tests/`, not reference source trees.
  Report only aggregate/non-sensitive results in tracked files. Local tests never confer permission
  to upload private text or to connect a cloud assistant/MCP client to recordings.
- Whenever a new working file or routed source area is added, index it in the owning CLAUDE file
  in the same edit. Synchronize affected current-state documents before completion; separate
  documented, implemented, configured, and physically verified claims.
