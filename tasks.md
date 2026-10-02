# Current work and transition gates

**Status:** Experimental dictation implementation and evaluation. Notes/meeting integration is
not built; near-instant speed and updated live language acceptance remain open.

## G0 — Source and baseline preparation

- [x] Create standalone project, canonical CLAUDE chain and parent routing.
- [x] Move research here; document product framework, nitpicks, architecture and test fixtures.
- [x] Download local reference sources without executing dependency/install scripts.
- [x] Download and hash-check multilingual Whisper Small for English and Hindi/Hinglish.
- [x] Copy isolated Handy release runtime; provision safe baseline settings.
- [x] Validate script syntax, launcher/restore previews, source pins and safe remotes.
- [x] Validate Handy portable startup and generated setting persistence; startup alone is not ASR evidence.
- [ ] Exercise fresh-machine source/runtime restoration before calling recovery fully verified.
- [x] Publish only source/docs/gitlinks to Akshat's private voice-workspace GitHub repository.

## G1 — Physical dictation comparison (next)

- [x] Initial user Notepad capture/insertion attempted: failed Roman script, technical acronym and
  speed acceptance (reported release-to-text over 10 seconds).
- [ ] Akshat selects microphone and performs E01/E02/H01/H03 first.
- [ ] Run 20 inserts, silence, Escape, clipboard and focus-change checks; capture aggregate results.
- [x] Decide Hindi output policy: natural Roman Hinglish, not Devanagari or English translation.
- [x] P0 implementation: experimental local Hindi-to-Roman-Hinglish conversion before display/paste,
  independent of cleanup; preserve English, meaning and raw provenance; no silent script fallback.
- [x] Eight native converter test groups and six history-delivery regression checks pass; this
  is synthetic coverage, not general spoken accuracy.
- [x] Measure CPU/NVIDIA/Intel Small inference; reproduce CPU bottleneck and choose NVIDIA.
- [x] Add opt-in startup model preload and content-free latency diagnostics.
- [x] Download and hash-check the approved Whisper Turbo model for a local comparison.
- [x] Build/deploy the updated native Windows fork, preserve rollback/profile/history, select
  Turbo/NVIDIA and verify real headless inference/conversion (3.3–3.8 s samples, not instant).
- [x] Verify updated GUI startup/priming, safe persisted settings and transcript-free timing mode;
  leave app idle for Akshat's live test, without automatically recording.
- [ ] Pass H01-H06 script/meaning checks with cleanup off before calling language setup ready.
- [ ] Measure and choose acceptable warm/cold latency, including Romanization overhead.
- [ ] Try manual vocabulary separately; avoid claiming auto-learning is implemented.
- [ ] Prepare OpenWhispr offline comparison profile only after reviewing released onboarding/egress.
- [ ] Compare same model/settings; retain Handy base unless Akshat explicitly accepts a change.

## G2/G3 — Minimal useful integrated slice

- [ ] Consented Windows two-source capture spike; compare OpenWhispr/Meetily and native adapters.
- [ ] Review exact component/dependency/model/asset licenses; no Natively code copied.
- [ ] Select capture module and define versioned audio/session/segment contracts.
- [ ] Add note inbox, autosave, SQLite migrations/FTS and Markdown export in a small Handy-based slice.
- [ ] Manual meeting start/pause/stop, gap reporting, durable transcript and human speaker locks.
- [ ] Test echo/duplicates/overlap/devices/sleep/crash/disk-full before confidential meetings.

## G4/G5 — Intelligence and release quality

- [ ] Add Raw/Light/Structured cleanup with validation, local failure fallback and undo.
- [ ] Add explicit selected-text edit preview and stale-target revalidation.
- [ ] Add approved vocabulary/replacement rules, then bounded opt-in correction learning.
- [ ] Benchmark a small local/self-hosted text model on available hardware before adoption.
- [ ] Grounded summaries/action items/questions with citations and unknown owner/date handling.
- [ ] Retention/deletion/backup scope, content-redacted logs, egress tests and security review.
- [ ] Sustained meeting soak tests, signed packaging/update provenance and recovery exercise.

## Deferred / requires another decision

iPhone/keyboard/share extension device spike; macOS/Linux physical tests; calendar behavior;
LAN inference/auth/TLS; MCP/export integrations; encrypted-at-rest design; private-data backup
destination; cross-session voice identity; connectors/public sharing. No live coaching and no
automatic recording remain boundaries. Do not tick runtime/feature boxes from source research.
