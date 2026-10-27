# Voice Workspace Tools

Project-owned Windows launch, source-recovery, and local test preparation tools. These tools are
not the integrated application. Product decisions belong in the parent project documents.

**Status:** Experimental dictation test tooling — model/profile checks and install/launch/recovery
tools support the voice-workspace-desktop app. Updated physical ASR/paste acceptance and
fresh-machine restoration remain open.

## Files

- `install-desktop.ps1` — install or update the desktop app in `runtime/desktop` from a GitHub
  Release, picking the ARM64 or x64 zip for this laptop; verifies checksums, moves the current
  exe/DLLs/resources into a dated `rollback-*` folder and leaves `Data/` untouched. Refuses while
  the app runs or when no prepared runtime exists; renames a legacy `runtime/handy`.
- `start-test.ps1` — launch a selected prepared app without starting microphone recording;
  report recognition mode and manual vocabulary count without profile/text content.
- `verify-workspace.ps1` — check pinned sources, ignored runtime readiness, and unsafe tracked files;
  report mode/vocabulary count without claiming live acceptance.
- `restore-references.ps1` — restore only the explicitly listed top-level reference gitlinks;
  never initialize premium/nested submodules or update pins automatically.
- `handy-baseline.json` — nonsensitive portable settings template for a fresh test profile;
  not the user's live settings, and not proof of microphone or inference success.
- `local-models.json` — allowed downloaded model paths, sizes and verified checksums shared by
  the launcher and runtime verifier; no automatic download or redistribution authorization.
- `model-input.ps1` — read-only model path/size/hash resolver for the isolated Data directory,
  including pinned Hugging Face cache files; dot-sourced by launch and verification tools.
- `benchmark-asr.ps1` — run the fork's standalone local timing/error/punctuation diagnostic with
  optional local gold and vocabulary files and explicit
  device selection; no mic/paste/upload. Read performance.md for interpretation and compile prerequisites.
- `benchmark-cleanup.ps1` — opt-in local Qwen/llama.cpp experiment on built-in dummy text only;
  verifies pinned model/package/extracted binaries, owns an authenticated loopback-only offline
  helper with tools/MCP disabled, compares CPU/NVIDIA, emits aggregate checks and stops its own PID.
  `-ShowDummyOutput` exposes only built-in public dummy completions for scoring diagnosis; no user input is accepted.
  Never changes the desktop app's settings or processes; no uploads/downloads. Read setup/performance before use.
- `portable` — Handy's supported marker template; copy beside a fresh test executable only.

## Working agreement

- Use explicit validated paths within this project. Never delete or reset existing user state.
- Set task-specific variables, not HOME/CODEX_HOME. Hide background helper windows; normal GUI
  windows are allowed only when launching a user-selected interactive test app.
- No recordings, uploads, telemetry-enabling settings, cloud keys, or auto-start changes.
- Runtime source/config/model downloads require an authorized destination. Never bypass Windows
  application-control policy or signature failures to get a test running.
- Index new tools here in the same edit and synchronize setup/testing docs when behavior changes.
