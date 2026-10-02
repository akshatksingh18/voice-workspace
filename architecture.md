# Architecture and component selection

**Status:** Accepted ownership and guardrails; broader integration design remains proposed.
The Handy fork implements preload/warm-up, diagnostics, an opt-in full-recording mode and a
dictionary prefix-preservation fix; English-only dictation is active,
with the experimental Hindi converter dormant.
No notes/meeting module or inter-app bridge is implemented in this repository.

## Ownership and first decision

This is the future product home. Handy remains the accepted desktop/native dictation foundation,
not a discarded reference. Its private fork is currently the working implementation. The
Granola-alternative fork retains its narrower planning scope and restrictive upstream license.
Do not move/delete either sibling or change its implementation without a specific change task.

Start with an isolated Handy runtime and compare selected Windows experiences in OpenWhispr
and Meetily. Do not transplant an Electron app into Tauri, merge nine whole repositories, or
adopt a meeting backend based solely on README feature claims. If tests suggest changing the
accepted base, present evidence and ask Akshat; this research does not authorize replacement.

## Candidates and boundaries

- Handy: Rust/Tauri/React native app and local transcription core. Retain its platform abstractions,
  keyboard/audio/paste reliability and upstream mergeability; add modules behind explicit interfaces.
- OpenWhispr: workflow/reference for local dictation, corrections, notes, selection edits and
  Windows meeting capture. MIT root source, but assets/dependencies/services require their own
  checks; current main can contain fixes absent from the downloaded 1.10.2 release.
- Anarlog: Tauri/Rust/React note organization and meeting workflow. Community MIT versus enterprise
  commercial scope. Built-in local ASR's documented macOS boundary blocks assuming Windows parity.
- Meetily: Windows meeting capture and local ASR candidate; community MIT and Pro are different.
- Minutes: local files, Markdown/session artifacts, Rust CLI and searchable transcript ideas.
  Windows CLI availability does not imply a Windows version of its macOS desktop app.
- Open Granola: architecture/reference only; known Windows capture placeholders block base selection.
- Omascribe: lightweight typed-note-plus-transcript workflow; Linux-oriented, not a Windows base.
- Steno: meeting notepad/reference, Windows alpha maturity gate.
- Granola alternative/Natively: observe requirements/UX only. Personal-use, noncommercial restrictions
  are incompatible with simply copying its code into a permissively licensed production product.

Manifest records exact revisions. Before reusing any file, record upstream path/SHA/copyright,
per-file license, transitive dependencies, native binary and model/asset terms, notice obligations,
and any modifications. Private hosting is not a substitute for license compliance. No bundled
brand fonts/icons, premium submodules or trademarks assumed reusable. Product license unresolved.

## Proposed module seams

One desktop shell; distinct Dictate, Edit, Note and Meeting modes. Share services, not UI state:

1. Audio capture: native mic plus Windows WASAPI loopback adapter. Emits bounded PCM chunks with
   session/source/sequence/sample rate/channels/timebase. Keeps sources distinct and reports gaps.
2. ASR service: English-first selection over Handy's existing model registry, checksum/version,
   capability flags and cancellation; keep batch and streaming capabilities distinct.
   Dictation has priority; meeting chunks queue with bounded backlog and persistence/recovery.
3. Delivery service: target/selection token, stale-target revalidation, clipboard transaction,
   exactly-once paste receipt, fallback and undo. Meeting transcripts cannot reach auto-paste.
4. Language/correction service: explicit transformations, vocabulary hints, scoped replacement
   rules and opt-in correction candidates. Active English dictation bypasses the dormant Hindi
   converter. Keep raw ASR, deterministic corrections and LLM output separate; preserve provenance.
   Proposed spoken-repair stage resolves only explicit current-recording backtracking before the
   final delivery. It does not watch external typing or edit a prior paste; see the boundary below.
5. Note/meeting service: user notes, segment stream, recording state, transcript versions, speaker
   labels and explicit export. Human text and locked labels survive AI reruns.
6. Intelligence service: independent local/self-hosted text adapter, constrained schemas, grounded
   citations, unknown values, validation and timeout fallback. No ambient external-action tools.
7. Storage service: single writer to SQLite with migrations and FTS5; app-private data area distinct
   from Git source. Markdown/plain text exports are portable output, not a second conflicting DB.

Use request/session/segment IDs across IPC. Events are versioned: started, partial, final, retracted,
failed, cancelled and stopped; renderer applies idempotent updates keyed by ID, not arrival time.
Finalization is bounded and durable. Retractions target stable IDs, and stale results cannot modify
a newer recording or note. The UI shows provisional text; final ASR is not automatic ground truth.

## Proposed data contracts

- Session: id, mode, created time, language policy, capture sources, state, consent acknowledgement,
  model revision and measured gaps. Store no inferred consent or automatic attendance facts.
- Segment: stable id/session/source, start/end on one session timebase, raw text, optional revised
  text, finality, speaker cluster, uncertainty and human lock. Keep edits/version provenance.
- Note: id/title/authored body, optional session link, tags, created/updated times and revision.
- Derived note: input revision/hash, template/model version, summary, decisions, actions with
  nullable owner/due date, and supporting segment IDs. Never overwrite authored body by default.
- Correction candidate: bounded inserted-span edit, proposed wrong/right mapping, scope, confidence,
  evidence count, consent and approval state. No general keystroke history or screenshots.

Speaker clustering runs after reliable capture/transcription. "Local" versus "system" is only a
source label; system audio can contain multiple speakers. Manual labels take precedence. Cross-
session identity and embeddings require an explicit separate privacy decision and deletion tests.

## Inference and deployment

### Proposed spoken self-correction slice — not implemented

Retain the speed-accepted English ASR model. Streaming partials may revise, so repair candidates
are provisional and tied to the current session/revision; cancellation or a newer revision invalidates
them. On release, finalized ASR → bounded spoken-repair matcher → validated delivery text → one paste.
The insertion point in Handy is output handling after recognition and before history/delivery;
no ASR-model replacement is needed for this proposed narrow full-restatement case.

Keep original ASR, repaired text and changed span/rule provenance distinct. Plain Raw mode skips
repair. The initial matcher requires both an explicit cue and a matching nearby clause/replacement;
"sorry" alone is not a command. Preserve uncorrected clauses, identifiers and negation. Ambiguous,
quoted or incomplete repairs remain raw/a draft rather than guessed deletions. Measure output
overhead and full release latency before enabling; no LLM or new service is configured by this plan.
General free-form/elliptical repair may need a small local text model, but must pass accuracy and
memory/latency gates on this machine before adoption. Fixture goals are in test-cases.md C01–C08.

Across-recording correction is a later explicit edit operation over a saved insertion receipt,
with target/text/selection revalidation, preview fallback and exact undo. A receipt alone cannot
prove external text is unchanged. Unsupported editors fail closed to a copyable draft; blind
backspaces and global keystroke observation are excluded. No continuous external-editor rewriting
is currently implemented.

### Current ASR path and model policy

Accepted language scope: English only. Current ASR-only path: English local ASR (batch or streaming
finalization) → existing deterministic filters → delivery/history. Translation, Roman Hinglish and
optional LLM cleanup are off. No change to the user's microphone, shortcut or saved audio is implied.
Handy normally feeds streaming-capable native models while recording. The new opt-in
`prefer_batch_transcription` setting instead recognizes the full recording on release and chooses
offline VAD; it defaults false for existing users. The isolated quality profile enables it because
same-clip E03 batch recognition retained technical terms and sentence ending with low recognition
delay. Batch has no live partial preview and long clips can cost more after release.
Preload reconciles capabilities plus this preference and warms the selected path with discarded
synthetic silence. Restart after mode changes to prime the chosen path.
Model Unload → Never retains the context between tests. Cold preparation is not release latency.

The profile seeds three manual dictionary terms. Parakeet applies fuzzy post-ASR matching, not
acoustic prompting. The prefix-preservation fix avoids consuming an ordinary preceding word when
a better suffix match for the same term exists. It neither deletes unspoken articles nor creates
list commas. Native Parakeet punctuation toggles are ignored; normalization preserves punctuation.
The live quality retest's technical words/punctuation passed by user report; this does not make
the dictionary a punctuation engine or prove all utterances. Broader contextual grammar/flexible
repair need independent tests. OpenWhispr's pinned prompt/failure fallback is a reference, not a
validated drop-in. A small local text-model/Windows runtime test is approved from official
GitHub/Hugging Face. No inference server or cleanup is configured in Handy; keep the experiment
separate and default cleanup off unless speed/meaning/fallback gates independently pass.
The tested Qwen3-0.6B Q8 configuration failed explicit time repairs and clause preservation;
therefore no Handy adapter/cleanup activation follows. Benchmark helper lifecycle/inputs are
owned by scripts/benchmark-cleanup.ps1 and setup.md; it is not a production background service.

The converter remains recoverable code, not an active product requirement: its script fixtures
passed, but the user's live Hindi result failed meaning/translation expectations. Reintroducing
Hindi requires a new decision and acoustic tests. Existing history/audio is not deleted. Future
cleanup/notes/export need independent meaning-preservation and privacy gates; none is built here.

The CPU Whisper Small baseline reproduced excessive delay; measured NVIDIA Vulkan acceleration
is faster. See performance.md for device/model evidence and setup.md for the active profile.
Cleanup remains off. This laptop has about 8 GB RAM and
2 GB discrete VRAM, so do not load a large LLM alongside ASR by default. Benchmark warm/cold times,
memory, battery and meeting backlog before selecting a text model. Self-hosted means controllable
inference/storage, not a promise that every task runs quickly on this laptop.

Later text inference can use a loopback/LAN local server with documented capability probes.
ASR needs its own transcription/stream protocol; an OpenAI-compatible chat endpoint is not enough.
Loopback-only by default, authenticated LAN opt-in with TLS/access controls. Cloud mode needs an
explicit destination and consent; never fail over automatically. Cancel/pause long note jobs for
interactive dictation. Sidecars have owned-PID lifecycle, timeouts and restart limits.

Keep offline inference distinct from optional downloads, updates, telemetry, calendar/auth and
assistant networking. Define and measure an egress allowlist before claiming fully offline.
No automatic Docker/backend/calendar setup is needed for the first test.

## Security, storage and recovery gates

Audio, transcripts, notes, keys, speaker data and logs stay out of Git. Source/docs recovery uses
Akshat's private GitHub; the workspace's OneDrive archive excludes personal-project. Private-data
backup has no configured destination and needs explicit approval. Export must warn about scope.

No current claim of encrypted databases. A product release needs storage location/ACL review,
key storage, model integrity, signed installer/update provenance, IPC/path validation, dependency
audit and content-redacted logs. Deletion must cover audio, text, derived content, FTS/vector entries,
WAL and retained profiles with honest backup/SSD limitations. Recordings/transcripts/prompts are
untrusted data; they cannot grant permissions, execute commands, or expand agent tool scope.

## Implementation gates

G0: pinned sources + safe ASR-only isolated test setup. G1: physical English-only
accuracy/latency/paste acceptance, superseding the old Hindi/Hinglish gate. Qualitative English
streaming speed is accepted and the full-recording/vocabulary technical/punctuation retest passed
by user report. Broader fixtures, quantitative coverage and insertion safety remain open.
G2: consented Windows two-source capture spike, headset/echo/device/crash tests.
G3: license-approved minimal notes + transcript integration in Handy. G4: validated correction/
editing and grounded local intelligence. G5: packaging, privacy/security/recovery and sustained
meeting soak tests before production claims. iOS is a later independent G6 device prototype.
