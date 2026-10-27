# Local-first voice workspace research

**Status:** Research supporting the accepted standalone Voice Workspace project. Akshat's
direction is a self-hosted Wispr Flow alternative combining Handy dictation, personal notes,
meeting transcription, and correction learning. Handy remains the accepted desktop base; component
selection and this proposed implementation roadmap still need test evidence. The sibling Granola
alternative's narrow implementation scope has not been replaced. Read `product-framework.md`,
`architecture.md`, and `testing-guide.md` for this project's current requirements and gates.

Sources reviewed on October 2, 2026. Repository default branches, published releases, documentation,
and selected source files were inspected; the external applications were not installed or tested.
Published documentation can describe newer code than the shipped release. No feature parity,
performance, privacy guarantee, or cross-platform runtime verification is implied by this review.
An isolated Handy runtime/models and dictation changes are prepared in this project; `setup.md`
and `performance.md` own actual verification evidence. The external comparison apps remain untested.
Akshat now requires English only, prioritizing speed and accuracy. This explicitly supersedes the
previous Roman-Hinglish requirement after a failed live test. The dormant converter is preserved;
setup.md/performance.md own the current English profile and measurements, not this research snapshot.

## Current workspace evidence

- Handy is a Rust/Tauri + React desktop fork. Its Windows source build/startup and initial Notepad
  capture/insertion worked, but speed/script/acronym acceptance failed. Local CPU/GPU model
  inference is measured; Turbo's updated live latency was still about 4 seconds and Hindi output
  failed. Akshat accepts the earlier English streaming profile's live speed; live E03 then failed
  PostgreSQL spelling and punctuation. A same-clip batch/vocabulary comparison motivates the
  new full-recording quality test. Akshat then reported technical words/punctuation worked
  perfectly in the deployed quality retest, cleanup off; broader accuracy,
  insertion/reliability and signed installer behavior remain open. See
  `../voice-workspace-desktop/windows-local-setup.md`. Local ASR, custom vocabulary, filler removal, optional LLM processing,
  and SQLite dictation history already provide useful integration points.
- `../granola-alt/` is a specification on an imported Electron/Natively base, not a completed
  custom meeting app. See its `CLAUDE.md`, `spec.md`, `tasks.md`, and `setup.md`. Native/core build
  checks passed, but the full application build depends on uninitialized premium sources.
- Its current spec uses two Deepgram streams, with local speaker embeddings planned. This is
  not local-only transcription. Manual meeting start, live copyable blocks, searchable history,
  and speaker enrollment are the existing requirements. Summaries are a separate later feature;
  calendar/detection is excluded from the current build and live answer coaching is a permanent
  non-goal. Those boundaries remain in force until explicitly revised.
- Natively's `LICENSE` restricts personal/noncommercial use, internal business use, commercial
  integration, and relicensing. Do not copy or port that source into the intended independently
  distributable Handy product without appropriate permission. A private repo alone does not
  remove those restrictions. Preserve the current repository; no retirement is authorized here.
- The inspected native Windows capture selects a render endpoint and exposes communications
  device information. Selection/routing remains a physical-test gate, not proof of call capture.

## What the reference products actually establish

### Wispr Flow

Flow separates dictation from meeting notes. Its official documentation describes formatting,
spoken self-correction, cleanup levels, app-category styles, vocabulary/correction rules, snippets,
selected-text commands/transforms, and Scratchpad drafts. Dictionary entries can be learned from
edits and context; that does not establish proprietary model retraining or disclose its full
learning algorithm. [Dictionary](https://docs.wisprflow.ai/articles/4052411709-teach-flow-your-words-with-the-dictionary),
[import/learning provenance](https://docs.wisprflow.ai/articles/8955301725-How-Do-I-Bulk-Import-Dictionary-Items-and-Snippets),
[styles](https://docs.wisprflow.ai/articles/2368263928-how-to-setup-flow-styles),
[cleanup](https://docs.wisprflow.ai/articles/4283510616-auto-cleanup-control-how-much-flow-edits-your-dictation-beta),
[Backtrack](https://docs.wisprflow.ai/articles/5373093536-how-do-i-use-smart-formatting-and-backtrack),
[transforms](https://docs.wisprflow.ai/articles/8068950331-how-to-use-transforms-beta),
[Scratchpad](https://docs.wisprflow.ai/articles/9618237082-using-the-scratchpad-to-save-and-edit-notes).

The September release notes establish Windows Notetaker availability, bot-free capture, live
transcripts and later refinement, summaries, cross-meeting questions with citations, calendar
context, imports, and MCP access limited to meetings rather than dictations. Dictation's 100+
language claim is distinct from Notetaker's documented 21 transcription languages.
[Official releases](https://wisprflow.ai/whats-new).

### OpenWhispr — first evaluation candidate

MIT Electron/React application with substantial overlap: dictation, notes, meeting transcription,
and local/cloud providers. It has a published 1.10.2 release. This is a candidate for evaluating
existing functionality before committing to custom development, not an approved replacement for
Handy. [README](https://github.com/OpenWhispr/openwhispr),
[license](https://github.com/OpenWhispr/openwhispr/blob/main/LICENSE),
[release](https://github.com/OpenWhispr/openwhispr/releases/tag/v1.10.2).

Its docs describe opt-in correction learning and provisional/suggested/confirmed/locked speaker
labels. The source includes a Windows diarization executable route and separate segmentation and
embedding models. Use those as implementation references after provenance review. Its Windows
docs and unreleased changelog explicitly discuss Teams capture failures; test the exact shipped
version instead of assuming fixes on main are released.
[Learning](https://docs.openwhispr.com/help/customise/custom-dictionary),
[speaker UX](https://docs.openwhispr.com/help/meetings/speaker-labels),
[diarization source](https://github.com/OpenWhispr/openwhispr/blob/main/src/helpers/diarization.js),
[Windows](https://docs.openwhispr.com/platform/windows),
[changelog](https://github.com/OpenWhispr/openwhispr/blob/main/CHANGELOG.md).

Focused local source review at immutable revision `0c232a3eaa30f2fde318d0ae0254dfb19cca3f54`:
`src/locales/en/prompts.json` defines punctuation/grammar/spelling cleanup, exact dictionary
spellings, preserving jargon, and explicit spoken backtracking, with literal/emphatic exceptions.
`src/helpers/audioManager.js` separates optional cleanup from recognition, checks complete output,
and falls back to raw text on failure/truncation. Its Parakeet local-server route does not pass
Whisper dictionary prompts. `src/utils/cleanupOutput.ts` checks whole-transcript duplication, not
complete semantic fidelity. `src/services/DictionaryService.ts` is a cloud-sync service, not a
portable local dictionary implementation. These are useful workflow ideas; no code/prompt was
copied or external app run, and no local cleanup latency was measured. Preserve MIT provenance
and notices if actual code/prompt reuse follows. Do not import cloud/account behavior implicitly.

For Handy, first improve the chosen ASR path and manual vocabulary, then independently benchmark
punctuation/repair cleanup. Switching to another app with the same recognizer is not itself an
accuracy fix. This laptop's RAM/VRAM and accepted responsiveness are explicit adoption gates.
The approved official Qwen3-0.6B Q8/llama.cpp experiment later ran locally on dummy text, not
OpenWhispr itself. It was fast but kept superseded times and dropped clauses; that configuration
was not adopted. The successful live technical/punctuation profile remains non-LLM. Local evidence
and pinned inputs belong in performance.md/setup.md, not model marketing or source prompt claims.

### Anarlog — strong meeting-module reference, Windows local-ASR caveat

Formerly Hyprnote; the community meeting app uses Rust/Tauri/React, local SQLite, an editor,
exports, and CLI/MCP. The team now also builds a separate Char product; this repository is not
Char's current codebase. Its community layer is MIT, while `enterprise/` is commercial.
[Repository](https://github.com/fastrepl/anarlog),
[license boundary](https://github.com/fastrepl/anarlog/blob/main/LICENSING.md).

Its current provider docs list built-in on-device transcription on eligible Macs, not an
equivalent built-in Windows path. A local Deepgram-compatible server is another option. Local LLM
summaries do not by themselves make audio transcription local. This is a conditional source of
meeting/editor/provider architecture, not a ready-made Windows offline engine.
[Providers](https://docs.anarlog.so/models-and-providers).

### Minutes — local files and agent-access reference

MIT project emphasizing Markdown/YAML ownership, recording/transcription, CLI, and MCP. Borrow
export schemas, explicit sharing scopes, and evidence-backed recall patterns rather than its
live coaching features. Windows CLI installation is documented, with a diarization build caveat;
do not confuse that with tested Windows desktop parity.
[Repository](https://github.com/silverstein/minutes),
[Windows install](https://github.com/silverstein/minutes/blob/main/docs/install.md).

### Open Granola — ideas, not a verified production foundation

Apache-2.0 project describing local summaries, briefs, commitments, and privacy controls. Source
inspection reveals that the Windows loopback routine just starts a sleeping thread and pushes no
audio. Its releases page currently has no releases. Treat product claims as unproven.
[README](https://github.com/anshuman-pandey/open-granola),
[loopback source](https://github.com/anshuman-pandey/open-granola/blob/main/src-tauri/src/audio/loopback.rs),
[releases](https://github.com/anshuman-pandey/open-granola/releases).

The Windows Airlock routine logs a requested block instead of implementing WFP filtering; its
non-macOS network test does not assert failure. The inspected vocabulary prompt is constant,
and speaker assignment ignores the segment time bounds. These selected findings are enough to
reject a production-readiness assumption, not a complete security or correctness audit.
[Airlock](https://github.com/anshuman-pandey/open-granola/blob/main/src-tauri/src/airlock.rs),
[transcription](https://github.com/anshuman-pandey/open-granola/blob/main/src-tauri/src/transcribe.rs).

### Omascribe — focused workflow ideas

MIT Python terminal app aimed at Linux/Omarchy, with mic/system recording, local Whisper, optional
Ollama summaries, typed notes, Markdown outputs, and an audio routing test. Useful UX ideas, not a
Windows desktop base. [Repository](https://github.com/jamespember/omascribe).

### Additional shortlist

- [Meetily](https://github.com/Zackriya-Solutions/meetily): MIT community Tauri/Rust meeting app,
  documented Windows installer and local transcription/summaries. Pro is a separate codebase;
  do not assign its diarization or enterprise features to the community edition.
- [Steno](https://github.com/ruzin/stenoai): MIT local meeting notepad; README labels Windows alpha.
  Worth observing, not presumed stable Windows parity.

## Recommended product design

### English ASR shortlist

The active language decision is English only. Refresh/reviewed primary cards on 2026-10-02:

- **Parakeet Unified EN 0.6B Q8**: English, punctuation/capitalization, native port supports batch
  and buffered streaming. Reuses the already cached model; local measurements in performance.md
  support it as the first test candidate, not a universal accuracy winner.
  [NVIDIA base](https://huggingface.co/nvidia/parakeet-unified-en-0.6b),
  [Handy GGUF port](https://huggingface.co/handy-computer/parakeet-unified-en-0.6b-gguf).
- **Moonshine Streaming Small/Medium Q8**: English-only compact models; downloaded and screened
  locally. Batch is fast, but default streaming fell behind on this machine. Decode cadence/native
  backend matters; an optimized vendor benchmark does not describe Handy's exact default path.
  [Small port](https://huggingface.co/handy-computer/moonshine-streaming-small-gguf),
  [Medium port](https://huggingface.co/handy-computer/moonshine-streaming-medium-gguf),
  [upstream Medium](https://huggingface.co/moonshine-ai/moonshine-streaming-medium).
- **Whisper Turbo**: retained measured reference, not the preferred English latency profile.
  Handy's current native Whisper path is batch-only; changing recognition language alone does not
  process speech in advance. No cloud ASR or heavier LLM is introduced for this comparison.

No model has both globally maximum speed and accuracy across hardware, accents and noise. Test
critical words and warm/cold delivery, then choose the Pareto tradeoff appropriate to this laptop.
Published WER is not an accented-microphone acceptance result. Parakeet's GGUF card says CC-BY-4.0
but the current NVIDIA base says NVIDIA Open Model License: packaging must reconcile provenance/
terms before redistributing weights. Moonshine English cards list MIT. Local testing permission
does not settle redistribution, and all weights/recordings remain out of GitHub.

### Integration direction

One eventual desktop product, four explicit modes: Dictate into another app; Edit selected text;
Notes for drafts/voice memos; Meetings for long-running mic plus call audio. Share vocabulary,
provider settings, library/search, and export. Keep recording destinations and state separate:
meeting transcripts must never auto-paste into a focused chat or terminal.

Keep Handy's platform layer and add bounded components rather than combining entire applications.
Suggested modules: vocabulary/corrections, text transforms, documents/revisions, meeting capture,
transcript blocks, diarization, search, and optional read-only MCP. Extract portable Rust crates
or reimplement ideas with provenance; Electron helpers are not drop-in Tauri modules. Keep a
small patch series over Handy and pin any reused external files to immutable revisions.

Start with local inference inside the app or loopback sidecars, not a mandatory server. An optional
user-owned LAN server can later host heavier ASR/LLM jobs. LLM OpenAI compatibility does not imply
compatible streaming-ASR APIs: define and test both contracts. No silent cloud fallback. Provide
separate cancellation/timeouts/queues for dictation and meetings so a long summary cannot starve
a hotkey dictation. LAN service access requires pairing/authentication and encryption; do not
expose an unauthenticated audio endpoint to the internet.

Use SQLite transactions and FTS5 initially; optional vector indexing later. Keep dictations,
meeting transcripts, human notes, and generated outputs as distinct records. Stable segment IDs,
source track, monotonic timestamps, revision/final status, and speaker-label confidence allow
live corrections without rewriting the wrong block. Preserve human notes across regeneration;
never replace them with an AI summary. Export Markdown plus structured metadata; keep the DB as
the initial single writer, rather than unsafely sharing one live database across two apps or devices.

## Correction learning and trustworthy AI

Spoken self-correction, later typed correction, and an explicit rewrite request are different
operations. Begin with manual vocabulary and exact correction rules; then user-approved learning
inside our own editor; then opt-in observation in supported external apps.

External learning should track only the recently inserted span in the same accessible field,
for a short window. Discard on focus/document changes and skip password fields. Unsupported
editors need an explicit correction shortcut, not global typing capture. Distinguish small word
fixes from stylistic rewrites; suggest a learned mapping before activating it. Make learned terms
editable, exportable, reversible, and removable. Do not learn new facts from unverified AI summaries.

Use conservative cleanup by default, optional stronger polish, per-app styles, and raw-text
recovery. Protect names, numbers, dates, amounts, negations, and mixed-language text. A timeout
should return the available validated delivery text without prose cleanup, not lose it or silently
call a cloud provider. English is the active scope; the earlier Hindi converter is off and its
acoustic/meaning acceptance failed. User
dictation and imported transcripts are data, not executable instructions for agents.

Meeting labels start provisional, with manual naming and locking. Two audio tracks distinguish
sources, not every remote person. Real diarization needs segmentation, speaker embeddings, and
clustering; cross-meeting recognition is a separate opt-in feature. Benchmark actual multi-person
calls before selecting a model or similarity threshold. Sherpa-onnx is a credible native candidate,
not a measured winner. Review licenses/access conditions for each model as well as library code.
[Sherpa documentation](https://k2-fsa.github.io/sherpa/onnx/speaker-diarization/index.html),
[example model/access conditions](https://huggingface.co/pyannote/segmentation-3.0).

Ground summaries/actions in transcript segments with timestamp links. Unknown owners/dates stay
unknown. Later commitment tracking needs explicit proposed/confirmed/completed/cancelled states;
a suggestion is not a promise. No automatic email, task creation, coaching, or background recording.

## Phases and decision gates

1. Pass a physical Handy English-only ASR accuracy/latency/paste baseline, then evaluate a pinned OpenWhispr
   release on Windows using consented test audio: dictation/paste in actual editors, local-only
   operation and resource use. Later compare Teams/Zoom/browser capture, labels and export.
   This is the build-versus-adapt gate, not a base switch; use the current testing-guide.md.
2. Prove Handy microphone-to-text and reliable paste; add cleanup presets, manual correction
   pairs, snippets, and selected-text editing with recoverable previews. Benchmark latency and
   meaning preservation before widening context capture.
3. Add personal notes and revisions, keyword search, exports, and approved in-editor learning.
4. Prove a permissive Windows meeting capture implementation, separate tracks, live provisional
   blocks/copying, incremental persistence, and recovery. Add real diarization after capture works.
5. Add post-meeting refinement, typed-note-guided summaries/actions, evidence-linked recall, and
   narrowly scoped MCP. Obtain approval to reconcile the existing Granola plan before replacing
   its Deepgram/Natively implementation path. Keep summaries separate from the transcription phase.
6. Optional LAN inference/sync and native mobile companion after desktop gates pass. iPhone is
   a separate capture/keyboard product, not an automatic Tauri port. Keyboard/microphone/secure-field
   constraints and App Review require their own feasibility spike.
   [Apple keyboard limitations](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/CustomKeyboard.html).

Acceptance tests must include headset/output switches, Bluetooth routing, mute, overlap, silence,
sleep/resume, crashes, long calls, unavailable models, blocked network, accented English, and
clipboard/focus races. Measure word errors, correction learning mistakes, speaker attribution,
stop-to-paste latency, transcript lag, memory/CPU/GPU, and recovery completeness on stated hardware.
Targets are to be set from those measurements, not copied from marketing pages.

## Release/privacy gates and remaining decisions

- Record upstream revision/path/license for every reused component; preserve notices and check
  model/asset licenses independently. Handy branding requires separate rebranding before distribution.
- Keep raw audio retention user-controlled, speaker profiles deletable, storage encrypted where
  promised, logs redacted, and recording visibly disclosed. Do not promise SSD secure erasure from
  zero-fill/VACUUM; handle keys, WAL/indexes, exports, and backup copies consistently.
- Meeting content, recordings, embeddings, and keys do not belong in GitHub. The workspace's
  OneDrive archive excludes personal-projects; application user-data recovery needs a separate,
  explicit destination/policy before copying it anywhere.
- Any agent/MCP access is an egress permission boundary. Local storage plus a cloud assistant is
  not a local-only workflow; restrict access by collection, keep dictations excluded by default,
  and require explicit authorization before sending meeting content outside the workspace.
- Windows first for physical testing; preserve Handy's existing macOS/Linux paths. This research
  is source review, not runtime evidence. Current dictation changes and actual tests are owned by
  setup.md, performance.md and ../voice-workspace-desktop/voice-workspace-features.md. The imported code-review-graph
  tools were unavailable, so focused source inspection was used.
- Decisions still needed: personal-only versus distributable/business use; measured suitability of
  OpenWhispr; meeting engine selection; retention; mobile packaging; and whether later calendar
  integration should revise the deliberately manual-start meeting scope.
