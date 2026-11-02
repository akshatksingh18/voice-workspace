# Open work and transition gates

Open items only, highest priority first; finished items are in Git history. Project status:
[CLAUDE.md](CLAUDE.md). Measured results: [performance.md](performance.md).

## G1 — English dictation acceptance (current)

Both laptops:

- [ ] Broaden technical/punctuation fixtures and measure live delay; one qualitative retest is not
  the complete critical-word/reliability suite or a numeric p95.
- [ ] Complete English E01–E12 with the chosen microphone.
- [ ] Run 20 inserts, silence, Escape, clipboard and focus-change checks; capture aggregate results.
- [ ] Pass English critical-word accuracy and quantitatively measure warm release-to-paste;
  keep subjective speed acceptance distinct from the proposed numeric/p95 gate and cold/first run.
- [ ] Test other missed vocabulary one variable at a time; no automatic learning implemented.
- [ ] Prove a safe spoken-repair implementation; a fast model/prompt or one technical/punctuation
  pass is not an automatic correction/meaning-preservation gate.
- [ ] Prepare OpenWhispr offline comparison profile only after reviewing released onboarding/egress.
- [ ] Compare same model/settings; retain the desktop app unless Akshat explicitly accepts a change.
- [ ] Exercise fresh-machine source/runtime restoration before calling recovery fully verified.

Snapdragon X laptop (ARM64, CPU only):

- [ ] Plugged-in timing.
- [ ] Optional: step 5 of the combined retest in testing-guide.md (repeat long holds with early chunks off).

First laptop (x64, NVIDIA):

- [ ] Only if dictating on this laptop again: on it, pull `voice-workspace`, quit the old app, run
  `scripts/install-desktop.ps1` (it installs the latest x64 release, renames `runtime/handy` to
  `runtime/desktop` and keeps a rollback folder), then `scripts/start-test.ps1` and confirm the
  NVIDIA device is listed and bound.

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

Personal-only versus distributable/business use; meeting engine selection; mobile packaging;
iPhone/keyboard/share extension device spike; macOS/Linux physical tests; calendar behavior;
Hindi/Hinglish (requires a new user decision, not silent reactivation);
LAN inference/auth/TLS; MCP/export integrations; encrypted-at-rest design; private-data backup
destination; cross-session voice identity; connectors/public sharing. No live coaching and no
automatic recording remain boundaries. Do not tick runtime/feature boxes from source research.
