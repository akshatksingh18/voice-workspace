# First tests and settings

**Status:** English-only evaluation. Akshat accepts the current Parakeet profile's live speed;
the earlier streaming E03 test failed technical spelling/punctuation, but Akshat reports the
full-recording/three-term retest worked perfectly. The Snapdragon X CPU run kept technical words
but missed commas. Broader accuracy, quantitative latency and insertion/reliability remain open. Dedicated spoken
self-correction is not implemented; its fixtures specify future behavior, not expected current output.
See setup.md for deployment evidence and performance.md for measured samples.

## Snapdragon laptop — combined retest (current)

One sitting, built-in mic, blank Notepad, Left Alt+Space (was Left Ctrl+S). One sentence per hold unless a step says
otherwise; 2–3 s between holds; normal pace. Early-chunk recognition is **on** for steps 1–4.
This is the first live test of the Voice Workspace build from `main` (renamed app, new engine
worker, re-warm and early phrases ported to it), so also check step 0.

0. **App check:** the tray shows the new microphone icon and the window says Voice Workspace;
   the shortcut, microphone, custom words and earlier history are still there.
1. **Idle start:** leave the app idle 20+ minutes, then say E01 once.
2. **Short sentences:** E01, E07, E12 and E03, twice each.
3. **Long holds (the new feature):** in one hold, read E06, E08 and E09 with a normal pause between
   sentences. Repeat once. Then one ~30 s free-speech hold with natural pauses.
4. **Cancel:** start a long hold, speak 5+ s, pause, speak again, press Escape before releasing.
   Nothing may paste; the next dictation must work.
5. **Comparison:** ask the agent to turn early chunks off and restart the app, then repeat step 3.

Paste the Notepad text. The agent reads `dictation_latency`, `early_chunks` and
`dictation_rewarm_ms` from `Data/logs/voice-workspace.log` and records aggregate results only. Check meaning (negation,
numbers, technical words), duplicated or missing phrases at pause points, and stray periods.

## 1. Voice Workspace desktop first — no account, server or cleanup model

Close any running Voice Workspace, Handy, OpenWhispr or other dictation app from its tray; do not
run two together. Run `scripts/start-test.ps1` from this project, or open
`runtime/desktop/voice-workspace.exe`. This is the build from `../voice-workspace-desktop`, not
stock Handy, an installed copy or the reference source checkout.
Wait until model preparation/loading finishes; preload primes native batch/streaming inference with discarded synthetic
silence and never records your microphone. First startup is slower than later dictations.

The isolated portable settings select:

- Model: **Parakeet Unified EN 0.6B Q8_0**, English-only native GGUF, not old ONNX Parakeet V3.
  Other downloaded models are retained for explicit comparisons, not automatic selection.
- Language: **English**. Translate to English: off. English models are not expected to recognize Hindi.
- Activation: hold-to-talk with the profile's saved Transcribe shortcut, currently **Left Alt+Space**
  (older notes say Left Ctrl+S or Ctrl+Shift+F12). Check it in Settings before testing. Escape: cancel.
- ASR device depends on the laptop. Do not mix their results:
  - First laptop (x64): measured NVIDIA MX450 with Vulkan.
  - Snapdragon X laptop (ARM64): CPU only. The CI build has no GPU backend.
  - ONNX: CPU (no ONNX dictation model selected).
- Roman Hinglish: **off**. Warm model on startup: on. Model Unload: Never during latency tests.
  This consumes more RAM/VRAM; close the test app if it causes system pressure.
- Use full-recording recognition: **on** for the quality test. No live partial preview; the whole
  clip is recognized after release. Restart after changing this setting so startup warms that path.
  Short E03 batch inference was fast offline; longer recordings and GUI delay still need tests.
- Post-processing/AI cleanup and filler removal: off. Use the normal Transcribe shortcut.
- Custom words: PostgreSQL, Kubernetes and REST API; correction threshold 0.18. These are manual
  spelling entries, not auto-learning, an acoustic prompt or a punctuation engine.
- Paste: Ctrl+V; clipboard preservation; automatic Enter/submit off. Pre-paste delay is 20 ms on
  the Snapdragon laptop (60 ms elsewhere); the 60 ms after-paste delay protects clipboard restore.
- Idle re-warm: after 15 s without dictation, pressing the shortcut warms the model while you
  speak. Test it with one dictation after 20+ minutes idle.
- Early phrases (`early_chunk_recognition`, Snapdragon profile only, no UI toggle): finished
  phrases are recognized at pauses while the key is held. Change it only with the app closed.
- Always-on microphone, launch at login, hidden startup, debug mode: off. The app has no updater.
- Log level: INFO for content-free phase timings. Do not enable debug logging.
- Retention: preserve latest 20 history entries, with local audio/text kept for comparison.
  This is not a no-storage mode. Delete synthetic test entries when finished if desired.

In the app's Settings select the intended physical microphone (headset preferred), confirm input
levels, and check shortcut registration. Windows Settings → Privacy & security → Microphone
must permit desktop apps; no administrator mode is needed. These device/privacy choices cannot
be honestly completed without selecting/testing your actual microphone.

On a new laptop, first verify the device in setup.md, run headless `--stats-only` timing on saved
clips, then the live run. Report startup and the first dictation after idle separately from warm
repeats, and speak each fixture in its own hold so timings stay per-fixture.
Focus a blank Notepad document. Hold the Transcribe shortcut, say E01, release, and wait for insertion.
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

The earlier empty-dictionary streaming baseline failed live E03. Akshat reports technical spelling
and punctuation passed the full-recording/three-term live retest, cleanup off. Keep that profile;
repeat and broaden fixtures, checking neighboring words and release delay separately. One user
report is not universal punctuation/accuracy or a numeric latency guarantee. Saved-clip batch
screening lacked list commas; record live and offline results separately rather than overriding either.
For controlled comparisons, save the profile first, change only the mode (restart to warm it),
then only the dictionary. Do not erase other settings/history. The saved-clip screening isolated
raw batch/stream outputs and dictionary effects; the reported live retest is qualitative evidence.

Then read E09–E12 with the current model and your natural pronunciation, without pre-seeding their
additional terms. For a repeat empty-dictionary baseline, preserve the three prepared entries locally.
Check each technical spelling/acronym plus numbers, units and negation; minor punctuation differences
are not meaning errors. Repeat each three times. Then, only for missed terms, add the intended
spelling under Advanced Settings → Custom Words and repeat the same sentence separately.
Parakeet uses post-ASR fuzzy matching here, not acoustic prompting; a dictionary entry is not a
guarantee and must not corrupt neighboring ordinary words. Keep this distinct from automatic
correction learning and spoken self-correction, neither of which has been built here.
CPU/Small and NVIDIA/Intel comparisons are recorded in performance.md; they are not instant.
Measure at least three warmed-up utterances in the new GUI. INFO `dictation_latency` logs separate
capture, recognition, output, paste and total release-to-paste time. CLI timings omit insertion.
Do not read a load-only or best-of-two number as p95. Keep vocabulary tests separate from model/device changes.
Do not load a large text model just because a discrete GPU exists: this machine has 8 GB RAM
and about 2 GB discrete VRAM. Save aggregate conclusions, not private text, into tracked docs.

Initial proposed gate: E01–E12 with the user's natural English accent, 20 inserts without loss,
duplication or auto-submit; all negation/number/date fixtures preserve meaning; cancel and failure
leave recoverable text. Test quiet and ordinary room conditions. Keep the
headless ASR-only and full GUI measurements separate. Speed is qualitatively accepted, not a new
measured p95; correction work must preserve that accepted responsiveness. Latency targets should be
chosen from measurements; log stop-to-insert time separately from spoken duration.

`scripts/benchmark-asr.ps1` uses the fork's standalone native diagnostic, not the complete GUI.
In stream mode it paces 100 ms frames in real time and includes remaining backlog/finalization in `release_ms`.
Batch mode measures complete-clip recognition. Optional `-GoldFile` and `-VocabularyFile` remain
local; it reports lexical errors before/after vocabulary, comma counts and sentence-ending presence,
never transcript text. Vocabulary scoring needs a gold file and uses threshold 0.18.
Use the returned bound device name, not a presumed index. Gold scoring ignores case/punctuation
but counts valid number formatting as word errors; its limited critical-token checks are not
full semantic validation. Synthetic offline Windows TTS screens candidates but does not prove
accuracy for Akshat's voice. Compile prerequisites are in ../voice-workspace-desktop/windows-local-setup.md.
Never upload recordings, local diagnostics or gold transcripts. Post-ASR vocabulary correction on
non-Whisper models is not acoustic prompting or automatic learning.

## 3. OpenWhispr comparison — not preconfigured or launched

The signed official portable v1.10.2 Windows executable is downloaded in ignored `downloads/`.
Do not assume current-main features exist in that release. Its initial onboarding, account/network
defaults, profile/model locations and offline settings have not been verified against that binary;
it is **not** a second ready-to-use isolated test profile.

When explicitly starting this comparison, close Voice Workspace, review onboarding, choose local/guest mode
if offered, a supported local English model, English language, translation/cleanup/assistant/screen context off, no
cloud keys, sync/calendar/connectors/meeting detection/automatic recording off. Verify the UI can
actually provide those choices. Do not improvise unsupported localStorage/Chromium-profile flags.
Use the existing model only through a supported model-location/import setting; otherwise a separate
authorized download is needed. Refuse testing private data until egress defaults are established.

Rerun identical fixtures and settings. A fair comparison matches model/mic/noise/cleanup and
separates source review from released runtime results. OpenWhispr is a workflow benchmark, not
an accepted replacement for the desktop app. No installer/account setup is needed for the desktop-app test.

## 4. Meeting evaluation and local intelligence — later

The optional dummy-only cleanup benchmark is separate from dictation. It has been exercised with
Qwen3-0.6B Q8/llama.cpp but failed correction/meaning gates; it is not an accepted app cleanup
profile. Keep AI cleanup off. See setup.md for verified inputs, PowerShell/version/security limits
and performance.md for results. Do not send saved recordings/history to that helper or a cloud provider.

After English dictation passes, prepare a manual, consented dummy call in the actual meeting app with
headphones. Evaluate microphone plus Windows system loopback, silence, overlap, duplicates,
device switches, pause/resume and crash recovery. Do not call two sources "full diarization".
If local capture fails, stop and preserve evidence; don't quietly enable a cloud provider.

Only after capture is dependable choose a license-approved module and a local text model.
Test summary/selected editing with preview, raw fallback, grounded citations and unknown values.
No real meetings, automatic recording, live coaching, calendar OAuth, biometric enrollment,
external MCP or uploads are part of this first setup. No iPhone install/build is prepared.
