# First tests and settings

**Status:** Prepared baseline configuration; physical microphone recognition, shortcut registration
and insertion still require Akshat's tests. See setup.md for actual machine verification.

## 1. Handy first — no account, server or cleanup model

Close any running Handy/OpenWhispr/other dictation app from its tray; do not run both together.
Run `scripts/start-test.ps1` from this project, or open `runtime/handy/handy.exe`. This is the
copied local build, not an installed replacement or the reference source checkout.

The isolated portable settings select:

- Model: multilingual **Whisper Small** (`small`), not Small.en or an English-only engine.
- Language: Automatic. Translate to English: off. Hindi-only failures should be retested with
  Hindi selected explicitly; mixed Hinglish should return to Automatic for comparison.
- Activation: hold-to-talk; Ctrl+Shift+F12. Escape: cancel.
- ASR and ONNX acceleration: CPU for the reproducible baseline; model unload after 5 minutes.
- Post-processing/AI cleanup and filler removal: off. Use the normal Transcribe shortcut.
- Custom words: initially empty, then a separate technical-word test.
- Paste: Ctrl+V; clipboard preservation; automatic Enter/submit off.
- Always-on microphone, launch at login, update checks, hidden startup, debug mode: off.
- Retention: preserve latest 20 history entries, with local audio/text kept for comparison.
  This is not a no-storage mode. Delete synthetic test entries when finished if desired.

In Handy Settings select the intended physical microphone (headset preferred), confirm input
levels, and check shortcut registration. Windows Settings → Privacy & security → Microphone
must permit desktop apps; no administrator mode is needed. These device/privacy choices cannot
be honestly completed without selecting/testing your actual microphone.

Focus a blank Notepad document. Hold Ctrl+Shift+F12, say E01, release, and wait for insertion.
Try E02, H01 and H03. Leave focus in place for initial tests. Record whether Hindi appears in
Devanagari or Roman text; neither proves that mixed-language normalization is implemented.

Then run cancellation, silence, clipboard and repeated-insertion tests from test-cases.md.
After a quiet baseline, try a browser textarea and your usual harmless editor. Do not use a real
chat send box/terminal/password field. If paste fails, inspect History and use Copy; don't repeatedly
trigger recordings to recover the same text. An app that starts successfully can still fail ASR.

## 2. Change one variable at a time

Add only synthetic/domain terms (PostgreSQL/Kubernetes/REST API) to Custom Words and rerun E03/H06.
Keep this distinct from automatic correction learning, which has not been built here.
Compare CPU versus Vulkan/Auto only after the baseline; measure memory and cold/warm latency.
Do not load a large text model just because a discrete GPU exists: this machine has 8 GB RAM
and about 2 GB discrete VRAM. Save aggregate conclusions, not private text, into tracked docs.

Initial proposed gate: 20 inserts without loss/duplication/auto-submit; all negation/number/date
fixtures preserve meaning; cancel and failure leave recoverable text. Latency targets should be
chosen from measurements; log stop-to-insert time separately from spoken duration.

## 3. OpenWhispr comparison — not preconfigured or launched

The signed official portable v1.10.2 Windows executable is downloaded in ignored `downloads/`.
Do not assume current-main features exist in that release. Its initial onboarding, account/network
defaults, profile/model locations and offline settings have not been verified against that binary;
it is **not** a second ready-to-use isolated test profile.

When explicitly starting this comparison, close Handy, review onboarding, choose local/guest mode
if offered, local Whisper Small, Automatic, translation/cleanup/assistant/screen context off, no
cloud keys, sync/calendar/connectors/meeting detection/automatic recording off. Verify the UI can
actually provide those choices. Do not improvise unsupported localStorage/Chromium-profile flags.
Use the existing model only through a supported model-location/import setting; otherwise a separate
authorized download is needed. Refuse testing private data until egress defaults are established.

Rerun identical fixtures and settings. A fair comparison matches model/mic/noise/cleanup and
separates source review from released runtime results. OpenWhispr is a workflow benchmark, not
an accepted replacement for Handy. No installer/account setup is needed for the Handy-first test.

## 4. Meeting evaluation and local intelligence — later

After dictation passes, prepare a manual, consented dummy call in the actual meeting app with
headphones. Evaluate microphone plus Windows system loopback, silence, overlap, duplicates,
device switches, pause/resume and crash recovery. Do not call two sources "full diarization".
If local capture fails, stop and preserve evidence; don't quietly enable a cloud provider.

Only after capture is dependable choose a license-approved module and a local text model.
Test summary/selected editing with preview, raw fallback, grounded citations and unknown values.
No real meetings, automatic recording, live coaching, calendar OAuth, biometric enrollment,
external MCP or uploads are part of this first setup. No iPhone install/build is prepared.
