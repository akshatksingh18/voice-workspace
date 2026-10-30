# Current work and transition gates

**Status:** English-only dictation evaluation. Standalone Voice Workspace v0.10.0 combined retest
passed on the Snapdragon X laptop: idle re-warm delivered 525 ms after 108.9 min idle; early phrase
recognition dropped 22.5–32.1 s holds to 254–671 ms stop-to-paste (1–418 ms ASR) with 100% critical
token, negation, number, technical word and user name accuracy. Keep early chunks on.
Broader editor insertion/reliability and quantitative suites remain open. Spoken self-correction
is requested/planned, not built; notes/meetings are not integrated.

## G0 — Source and baseline preparation

- [x] Create standalone project, canonical CLAUDE chain and parent routing.
- [x] Move research here; document product framework, nitpicks, architecture and test fixtures.
- [x] Download local reference sources without executing dependency/install scripts.
- [x] Download and hash-check multilingual Whisper Small, retained for comparison/recovery.
- [x] Copy isolated desktop-app release runtime; provision safe baseline settings.
- [x] Validate script syntax, launcher/restore previews, source pins and safe remotes.
- [x] Validate portable startup and generated setting persistence; startup alone is not ASR evidence.
- [ ] Exercise fresh-machine source/runtime restoration before calling recovery fully verified.
- [x] Publish only source/docs/gitlinks to Akshat's private voice-workspace GitHub repository.

## G1 — Physical dictation comparison (next)

Snapdragon X laptop (ARM64, CPU only) — first priority on this device:

- [x] Verify hardware, ARM64 exe/DLL hashes, CPU-only device, portable profile and that Windows
  runs the unsigned exe without a bypass.
- [x] Headless CPU timing on saved clips and a live Notepad run (E01, E03 ×3, E07, free speech);
  results in performance.md. Akshat: speed "good enough", wants closer to instant.
- [x] Build (ARM64 CI) and deploy re-warm on shortcut press after idle, plus 20 ms paste pre-delay.
- [x] Retest after 26.8 min idle: re-warm ran during speech; first dictation 0.74 s (was 3.19 s).
  Keep the re-warm build and 20 ms pre-delay.
- [x] E07 dropped "not" in all three run-on repeats (reproducible from the recording). Retest
  one sentence per hold: E07 kept "not" 3/3, E01 and E12 kept numbers (performance.md).
- [x] Build (ARM64 CI) and deploy opt-in early-chunk recognition, enabled in this profile.
- [x] Port re-warm and early chunks onto the imported engine worker and make the desktop app its
  own project (Voice Workspace name, no updater, no upstream remote or mirror); CI passes and the
  ARM64 build from `main` is deployed here (setup.md).
- [x] Run the combined retest in testing-guide.md (app check, idle start, short sentences, long
  holds with early chunks on, cancel); re-warm passed (0.525 s after 108.9 min idle), early chunks
  passed (0.254–0.671 s stop-to-paste on 22.5–32.1 s holds; 1–418 ms ASR after release); keep early
  chunks on (performance.md). Step 5 (comparison with it off) optional.
- [ ] Plugged-in timing.
- [x] Run E06 and E12 here: version numbers, HTTP 429, timeouts, negation and technical names preserved.
- [ ] Recheck the shortcut: the profile's Left Ctrl+S overlaps Notepad's Save.

First laptop (x64, NVIDIA):

- [ ] Only if dictating on this laptop again: on it, pull `voice-workspace`, quit the old app, run
  `scripts/install-desktop.ps1` (it installs the latest x64 release, renames `runtime/handy` to
  `runtime/desktop` and keeps a rollback folder), then `scripts/start-test.ps1` and confirm the
  NVIDIA device is listed and bound.
- [x] Initial user Notepad capture/insertion attempted: failed Roman script, technical acronym and
  speed acceptance (reported release-to-text over 10 seconds).
- [x] Updated Turbo live test attempted: user reports 3–4 seconds; INFO logs show 4.029–4.527 s
  release-to-paste. Hindi came out in English despite translation off; failed acceptance.
- [x] Accept English-only product scope; supersede Hindi/Hinglish requirement and disable converter.
- [x] Akshat accepts the current Parakeet profile's live English speed; no exact new latency/p95 reported.
- [x] Attempt live E03: PostgreSQL and punctuation failed; Kubernetes/REST API retained.
- [x] Compare the same saved E03 recording across downloaded models and batch/stream paths;
  retain Parakeet, with full-recording mode as the next short-dictation quality candidate.
- [x] Add opt-in full-recording setting and matching warm-up; fix dictionary prefix swallowing;
  48 standalone diagnostic/text-filter tests pass. Deployment evidence belongs in setup.md.
- [x] Build/deploy the full-recording quality fork and three-term profile; preserve rollback/history,
  verify 14 matching DLLs, unchanged other settings and transcript-free native inference.
- [x] Verify quality GUI startup/NVIDIA warm-up without recording; not the complete reliability suite.
- [x] Akshat reports technical words/punctuation worked perfectly in the quality retest, cleanup off.
- [ ] Broaden technical/punctuation fixtures and measure live delay; one qualitative retest is not
  the complete critical-word/reliability suite or a numeric p95.
- [ ] Complete English E01–E12 with the chosen microphone.
- [ ] Run 20 inserts, silence, Escape, clipboard and focus-change checks; capture aggregate results.
- [x] Preserve dormant experimental converter and synthetic regression fixtures, not an active P0.
- [x] Measure CPU/NVIDIA/Intel Small inference; reproduce CPU bottleneck and choose NVIDIA.
- [x] Add opt-in startup model preload and content-free latency diagnostics.
- [x] Download and hash-check the approved Whisper Turbo model for a local comparison.
- [x] Build/deploy the native Windows fork with embedded frontend and matching libraries;
  preserve rollback/profile/history and verify transcript-free headless inference.
- [x] Screen cached Parakeet Unified EN and authorized Moonshine Small/Medium Q8 models locally;
  integrity, device identity, batch and streaming evidence belong in performance.md.
- [x] Deploy and verify English streaming priming in the rebuilt fork's headless native path.
- [x] Verify updated English GUI startup/priming and persisted privacy settings; no automatic recording.
- [ ] Pass English critical-word accuracy and quantitatively measure warm release-to-paste;
  keep subjective speed acceptance distinct from the proposed numeric/p95 gate and cold/first run.
- [x] Screen three manual terms offline; prepare PostgreSQL/Kubernetes/REST API for live retest.
- [ ] Test other missed vocabulary one variable at a time; no automatic learning implemented.
- [x] Obtain authority for an isolated small local cleanup model/Windows runtime from official
  GitHub/Hugging Face; no recordings/transcripts uploaded or default cleanup activation.
- [x] Benchmark approved Qwen3-0.6B Q8/llama.cpp CPU/NVIDIA cleanup on dummy text;
  reject default adoption after incorrect time repairs and dropped clauses. Keep app cleanup off.
- [ ] Prove a safe spoken-repair implementation; a fast model/prompt or one technical/punctuation
  pass is not an automatic correction/meaning-preservation gate.
- [ ] Prepare OpenWhispr offline comparison profile only after reviewing released onboarding/egress.
- [ ] Compare same model/settings; retain the desktop app unless Akshat explicitly accepts a change.

## G2/G3 — Minimal useful integrated slice

- [ ] Consented Windows two-source capture spike; compare OpenWhispr/Meetily and native adapters.
- [ ] Review exact component/dependency/model/asset licenses; no Natively code copied.
- [ ] Select capture module and define versioned audio/session/segment contracts.
- [ ] Add note inbox, autosave, SQLite migrations/FTS and Markdown export in a small slice of the desktop app.
- [ ] Manual meeting start/pause/stop, gap reporting, durable transcript and human speaker locks.
- [ ] Test echo/duplicates/overlap/devices/sleep/crash/disk-full before confidential meetings.

## G4/G5 — Intelligence and release quality

- [ ] Proposed next correction slice: same-recording English backtracking before paste; test C01–C08,
  literal apologies/quoted speech, numbers/negation, raw recovery and added latency. No implementation yet.
- [ ] Later explicit previous-insertion correction: verify target and unchanged text, preview/fallback
  and exact undo; never blind backspaces or global typing surveillance.
- [ ] Add Raw/Light/Structured cleanup with validation, local failure fallback and undo.
- [ ] Add explicit selected-text edit preview and stale-target revalidation.
- [ ] Add approved vocabulary/replacement rules, then bounded opt-in correction learning.
- [ ] Benchmark local/self-hosted text inference for longer notes/summaries on this hardware;
  passing short dictation cleanup does not establish long-document capacity.
- [ ] Grounded summaries/action items/questions with citations and unknown owner/date handling.
- [ ] Retention/deletion/backup scope, content-redacted logs, egress tests and security review.
- [ ] Sustained meeting soak tests, signed packaging/update provenance and recovery exercise.

## Deferred / requires another decision

iPhone/keyboard/share extension device spike; macOS/Linux physical tests; calendar behavior;
Hindi/Hinglish (requires a new user decision, not silent reactivation);
LAN inference/auth/TLS; MCP/export integrations; encrypted-at-rest design; private-data backup
destination; cross-session voice identity; connectors/public sharing. No live coaching and no
automatic recording remain boundaries. Do not tick runtime/feature boxes from source research.
