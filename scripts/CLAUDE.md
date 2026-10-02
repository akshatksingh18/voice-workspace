# Voice Workspace Tools

Project-owned Windows launch, source-recovery, and local test preparation tools. These tools are
not the integrated application. Product decisions belong in the parent project documents.

**Status:** Experimental dictation test tooling — model/profile checks and launch/recovery tools
support the Handy fork. Updated physical ASR/paste acceptance and fresh-machine restoration remain open.

## Files

- `start-test.ps1` — launch a selected prepared app without starting microphone recording.
- `verify-workspace.ps1` — check pinned sources, ignored runtime readiness, and unsafe tracked files.
- `restore-references.ps1` — restore only the explicitly listed top-level reference gitlinks;
  never initialize premium/nested submodules or update pins automatically.
- `handy-baseline.json` — nonsensitive portable settings template for a fresh test profile;
  not the user's live settings, and not proof of microphone or inference success.
- `local-models.json` — allowed downloaded model paths, sizes and verified checksums shared by
  the launcher and runtime verifier; no automatic download or redistribution authorization.
- `model-input.ps1` — read-only model path/size/hash resolver for the isolated Data directory,
  including pinned Hugging Face cache files; dot-sourced by launch and verification tools.
- `benchmark-asr.ps1` — run the fork's standalone local timing/error diagnostic with explicit
  device selection; no mic/paste/upload. Read performance.md for interpretation and compile prerequisites.
- `portable` — Handy's supported marker template; copy beside a fresh test executable only.

## Working agreement

- Use explicit validated paths within this project. Never delete or reset existing user state.
- Set task-specific variables, not HOME/CODEX_HOME. Hide background helper windows; normal GUI
  windows are allowed only when launching a user-selected interactive test app.
- No recordings, uploads, telemetry-enabling settings, cloud keys, or auto-start changes.
- Runtime source/config/model downloads require an authorized destination. Never bypass Windows
  application-control policy or signature failures to get a test running.
- Index new tools here in the same edit and synchronize setup/testing docs when behavior changes.
