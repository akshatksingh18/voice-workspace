# Voice Workspace Tools

Project-owned Windows launch, source-recovery, and local test preparation tools. These tools are
not the integrated application. Product decisions belong in the parent project documents.

**Status:** Setup tooling — syntax, baseline verification and launcher/restore previews passed;
physical microphone/ASR/paste tests are still required, and fresh-machine restoration is unverified.

## Files

- `start-test.ps1` — launch a selected prepared app without starting microphone recording.
- `verify-workspace.ps1` — check pinned sources, ignored runtime readiness, and unsafe tracked files.
- `restore-references.ps1` — restore only the explicitly listed top-level reference gitlinks;
  never initialize premium/nested submodules or update pins automatically.
- `handy-baseline.json` — nonsensitive portable settings template for a fresh test profile;
  not the user's live settings, and not proof of microphone or inference success.
- `portable` — Handy's supported marker template; copy beside a fresh test executable only.

## Working agreement

- Use explicit validated paths within this project. Never delete or reset existing user state.
- Set task-specific variables, not HOME/CODEX_HOME. Hide background helper windows; normal GUI
  windows are allowed only when launching a user-selected interactive test app.
- No recordings, uploads, telemetry-enabling settings, cloud keys, or auto-start changes.
- Runtime source/config/model downloads require an authorized destination. Never bypass Windows
  application-control policy or signature failures to get a test running.
- Index new tools here in the same edit and synchronize setup/testing docs when behavior changes.
