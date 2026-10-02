# Voice Workspace

Akshat's standalone local-first/self-hosted voice application project: dictation, explicit text
editing, personal notes, and bot-free meeting notes. Handy is the accepted desktop foundation.
This repository owns the product requirements, cross-project research, evaluation, and future
integration; sibling Handy and Granola repositories keep their own implementation instructions.

**Status:** English-only dictation evaluation — Akshat accepts the Parakeet profile's live speed;
technical-word accuracy and broader insertion/reliability gates remain open. Spoken self-correction
is a requested behavior with a proposed design, not implemented. Code lives in the Handy fork.
Moves to integrated notes/capture after remaining dictation and component/license gates pass.
No integrated Voice Workspace application exists yet.

## Files

- `README.md` — entry point, current readiness, quick start, and recovery.
- `product-framework.md` — Wispr capability framework, Akshat's explicit needs, priorities,
  fine-grained acceptance requirements, and scope/decision boundaries; read before feature work.
- `architecture.md` — accepted ownership boundaries, proposed modules, license/privacy constraints,
  inference/storage interfaces, and implementation gates; read before integration or dependency work.
- `voice-workspace-research.md` — source-backed comparison and rationale; claims are research,
  not physical runtime verification. Refresh external facts before relying on them.
- `testing-guide.md` — exact first-test settings, test order, pass/fail evidence, and limitations.
- `setup.md` — this machine's prepared runtimes/models/configuration, verified evidence, and
  remaining manual actions; update whenever setup state changes.
- `performance.md` — user-reported acceptance failures, aggregate device/model timings,
  converter evidence and remaining latency/accuracy gates; read before performance changes.
- `tasks.md` — current checklists and transition gates, not a session diary.
- `repositories.json` — immutable source revisions, remotes, license boundaries, and local paths.
- `.gitmodules` — pinned reference checkouts, not merged application dependencies.
- `.gitignore` — excludes runtimes, private audio/text, credentials, models, and build output.
- `references/` — read-only source checkouts; read `references/CLAUDE.md` before inspecting them.
- `scripts/` — project-owned setup, launcher, and verification tools; read `scripts/CLAUDE.md`.
- `test-cases.md` — active English fixtures and deferred Hindi regression references; never put real meeting content here.

## Working agreement

- Follow the workspace-root and personal-project CLAUDE chain. Keep instructions canonical here;
  do not create AGENTS.md, .agents, or .codex project instruction trees.
- Publish only to Akshat's own private GitHub unless he explicitly names another destination.
  User recordings, transcripts, speaker profiles, secrets, models, and generated runtime state
  must never be staged. Private GitHub is for source/documentation, not meeting data.
- References are evidence-only, pinned, and push-disabled. Do not execute their hooks, installers,
  dependency scripts, or downloaded binaries merely because a checkout exists. Preserve upstream
  source/licenses/instructions unchanged; read relevant instructions before actual development.
- Do not initialize nested/private premium submodules. Do not copy Natively or other restricted
  code into the product; component provenance and model/asset rights are separate gates.
- Windows is the first physical-test target. Preserve Handy's macOS/Linux boundaries; do not
  claim another platform or iPhone works from a Windows source review or build.
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
