# First tests and settings

**Status:** English-only evaluation. Turbo's updated live test still took 3–4 seconds and Hindi
output failed. The faster English candidate needs Akshat's microphone/paste acceptance.
See setup.md for deployment evidence and performance.md for measured samples.

## 1. Handy first — no account, server or cleanup model

Close any running Handy/OpenWhispr/other dictation app from its tray; do not run both together.
Run `scripts/start-test.ps1` from this project, or open `runtime/handy/handy.exe`. This is the
updated private-fork build, not an installed replacement or the reference source checkout.
Wait until model preparation/loading finishes; preload primes native batch/streaming inference with discarded synthetic
silence and never records your microphone. First startup is slower than later dictations.

The isolated portable settings select:

- Model: **Parakeet Unified EN 0.6B Q8_0**, English-only native GGUF, not old ONNX Parakeet V3.
  Other downloaded models are retained for explicit comparisons, not automatic selection.
- Language: **English**. Translate to English: off. English models are not expected to recognize Hindi.
- Activation: hold-to-talk; Ctrl+Shift+F12. Escape: cancel.
- ASR: measured NVIDIA MX450 device with Vulkan. ONNX: CPU (no ONNX dictation model selected).
- Roman Hinglish: **off**. Warm model on startup: on. Model Unload: Never during latency tests.
  This consumes more RAM/VRAM; close the test app if it causes system pressure.
- Post-processing/AI cleanup and filler removal: off. Use the normal Transcribe shortcut.
- Custom words: initially empty, then a separate technical-word test.
- Paste: Ctrl+V; clipboard preservation; automatic Enter/submit off.
- Always-on microphone, launch at login, update checks, hidden startup, debug mode: off.
- Log level: INFO for content-free phase timings. Do not enable debug logging.
- Retention: preserve latest 20 history entries, with local audio/text kept for comparison.
  This is not a no-storage mode. Delete synthetic test entries when finished if desired.

In Handy Settings select the intended physical microphone (headset preferred), confirm input
levels, and check shortcut registration. Windows Settings → Privacy & security → Microphone
must permit desktop apps; no administrator mode is needed. These device/privacy choices cannot
be honestly completed without selecting/testing your actual microphone.

Focus a blank Notepad document. Hold Ctrl+Shift+F12, say E01, release, and wait for insertion.
Try E03 and E06. Start speaking after the recording-ready cue and leave focus in place.
Say: "Please move the meeting to tomorrow, and do not deploy today. First test the API on staging."
Check tomorrow, API, negation and ordering, then three short utterances and a 30-second paragraph.
Hindi/Hinglish is deferred, superseding the old requirement; do not re-enable it. Existing audio
and the dormant converter remain recoverable. The target is warm release-to-paste under one second,
not a guarantee. A streaming partial can revise; first-partial time is not final insertion time.

Then run cancellation, silence, clipboard and repeated-insertion tests from test-cases.md.
After a quiet baseline, try a browser textarea and your usual harmless editor. Do not use a real
chat send box/terminal/password field. If paste fails, inspect History and use Copy; don't repeatedly
trigger recordings to recover the same text. An app that starts successfully can still fail ASR.
History shows delivered text by default; old/unconverted entries can be retried or explicitly
revealed with Show raw recognition (recovery only). Existing recordings were not deleted.

## 2. Change one variable at a time

Add only synthetic/domain terms (PostgreSQL/Kubernetes/REST API) to Custom Words and rerun E03.
Keep this distinct from automatic correction learning, which has not been built here.
CPU/Small and NVIDIA/Intel comparisons are recorded in performance.md; they are not instant.
Measure at least three warmed-up utterances in the new GUI. INFO `dictation_latency` logs separate
capture, recognition, output, paste and total release-to-paste time. CLI timings omit insertion.
Do not read a load-only or best-of-two number as p95. Keep vocabulary tests separate from model/device changes.
Do not load a large text model just because a discrete GPU exists: this machine has 8 GB RAM
and about 2 GB discrete VRAM. Save aggregate conclusions, not private text, into tracked docs.

Initial proposed gate: E01–E08 with the user's natural English accent, 20 inserts without loss,
duplication or auto-submit; all negation/number/date fixtures preserve meaning; cancel and failure
leave recoverable text. Test quiet and ordinary room conditions. Keep the
headless ASR-only and full GUI measurements separate. Latency targets should be
chosen from measurements; log stop-to-insert time separately from spoken duration.

`scripts/benchmark-asr.ps1` uses the fork's standalone native diagnostic, not the complete GUI.
It paces 100 ms frames in real time and includes remaining backlog/finalization in `release_ms`.
Use the returned bound device name, not a presumed index. Gold scoring ignores case/punctuation
but counts valid number formatting as word errors; its limited critical-token checks are not
full semantic validation. Synthetic offline Windows TTS screens candidates but does not prove
accuracy for Akshat's voice. Compile prerequisites are in ../handy/windows-local-setup.md.
Never upload recordings, local diagnostics or gold transcripts. Post-ASR vocabulary correction on
non-Whisper models is not acoustic prompting or automatic learning.

## 3. OpenWhispr comparison — not preconfigured or launched

The signed official portable v1.10.2 Windows executable is downloaded in ignored `downloads/`.
Do not assume current-main features exist in that release. Its initial onboarding, account/network
defaults, profile/model locations and offline settings have not been verified against that binary;
it is **not** a second ready-to-use isolated test profile.

When explicitly starting this comparison, close Handy, review onboarding, choose local/guest mode
if offered, a supported local English model, English language, translation/cleanup/assistant/screen context off, no
cloud keys, sync/calendar/connectors/meeting detection/automatic recording off. Verify the UI can
actually provide those choices. Do not improvise unsupported localStorage/Chromium-profile flags.
Use the existing model only through a supported model-location/import setting; otherwise a separate
authorized download is needed. Refuse testing private data until egress defaults are established.

Rerun identical fixtures and settings. A fair comparison matches model/mic/noise/cleanup and
separates source review from released runtime results. OpenWhispr is a workflow benchmark, not
an accepted replacement for Handy. No installer/account setup is needed for the Handy-first test.

## 4. Meeting evaluation and local intelligence — later

After English dictation passes, prepare a manual, consented dummy call in the actual meeting app with
headphones. Evaluate microphone plus Windows system loopback, silence, overlap, duplicates,
device switches, pause/resume and crash recovery. Do not call two sources "full diarization".
If local capture fails, stop and preserve evidence; don't quietly enable a cloud provider.

Only after capture is dependable choose a license-approved module and a local text model.
Test summary/selected editing with preview, raw fallback, grounded citations and unknown values.
No real meetings, automatic recording, live coaching, calendar OAuth, biometric enrollment,
external MCP or uploads are part of this first setup. No iPhone install/build is prepared.
