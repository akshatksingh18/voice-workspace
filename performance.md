# Dictation performance and acceptance

**Status:** English-only optimization. Turbo's live latency is still unacceptable and Hindi
meaning/translation failed. Parakeet is the faster candidate; instant full insertion and accuracy
for Akshat's voice have not passed. The older Hindi converter is off, not a solved language feature.

## Initial physical result

Akshat's first Notepad test did capture, recognize and insert speech. His reported release-to-text
delay exceeded 10 seconds. Delivered Hindi used Devanagari and a spoken technical acronym was
rendered phonetically. This is a failed language/speed acceptance test, not a passed dictation
suite. The screenshot/audio/transcripts remain local and are not in this repository.

The subsequent updated Turbo test was physically performed by Akshat: he reports 3–4 seconds and
Hindi delivered in English, not Hinglish. Content-free INFO metrics show three release-to-paste
samples of **4.527, 4.246 and 4.029 s**, including ASR of 4.007, 3.749 and 3.585 s; output processing
was 0–1 ms and paste 231–245 ms. Recognition is the dominant delay. Translation was configured off;
the report does not prove a Translate API was invoked. Root cause of Hindi's acoustic/language
behavior is not resolved. Akshat explicitly removed Hindi/Hinglish and chose English-only scope.

## English model screening and current decision

Measured 2026-10-02, offline, English selected, no translation, AI cleanup or vocabulary hints.
Cached **Parakeet Unified EN 0.6B Q8_0**, not ONNX Parakeet V3, is the selected test candidate.
The actual app headless path, using the stable NVIDIA selector on the same old 7.14-second local
clip, loaded in 6.607 s and recognized in **9.892, 0.430 and 0.362 s**. The first-run spike remains
important; the clip is mixed-language and is only a speed comparison, not an English accuracy gold.

The standalone `../handy/src-tauri/examples/asr_latency.rs` diagnostic uses the same installed
transcribe-cpp 0.2.4/runtime libraries. It warms with one second of discarded silence, then paces
100 ms frames at real-time speed for streaming. `release_ms` is the time beyond the WAV's duration,
including feed backlog and finalization. It omits microphone/VAD/IPC/paste/history and app filters.
Default stream/run options and explicit English were used. All following runs verify **NVIDIA MX450**
as bound device (`Vulkan1` in this diagnostic; indices differ from app processes).

Synthetic offline Windows SAPI English voice fixtures, no microphone:

- Parakeet E01 (4.765 s), streaming: release 4.032, 0.559, 0.292 s; 2 lexical word errors per run,
  limited critical-token checks passed. Spoken number formatting can inflate this score.
- Parakeet E03 (5.760 s), streaming: release 2.260, 0.301, 4.010 s; 2 lexical errors per run,
  critical technical-token check failed. This is an accuracy failure, not a passed English suite.
- Parakeet E06 (7.195 s), streaming: release 1.459, 0.569, 0.398 s; 0/17 lexical errors and limited
  API/negation/deploy/staging token checks passed, not full semantic/user-accent verification.
- Moonshine Streaming Small Q8, E06: batch 1.299/0.297 s; streaming release 7.117/1.621 s.
- Moonshine Streaming Medium Q8, E06: batch 1.217/0.359 s; streaming release 4.706/2.254 s.
  Both Moonshine variants had 0/17 lexical errors on this one easy synthetic fixture.
- Whisper Turbo/NVIDIA, E03: batch 3.278/3.294 s, 0/11 lexical errors and critical-token checks
  passed. It did better on this technical fixture than Parakeet, at substantially higher latency.

Native release compilation was running during this screening, so CPU/RAM contention, caches and
thermal state were uncontrolled; do not rank p95 or maximum accuracy from these samples. Earlier
index-based diagnostic runs actually bound Intel Iris Xe and are not mislabeled as NVIDIA evidence.
They are not used for the profile/device decision. Always record actual device name, not assumed index.

Parakeet has the stronger measured default-streaming latency here. Moonshine's fast **batch** results
do not imply fast default streaming. Moonshine decode interval/CPU path and alternate Parakeet quants
remain possible later experiments, not tested winners. Catalog scores and external WER do not prove
maximum accuracy for accented speech. Turbo remains a manual accuracy comparison/fallback; it is
not automatically invoked for a fast model's output. Keep the selected Q8 model until comparable live tests support
a change; do not introduce a smaller quant solely on advertised speed.

The fork now warms native streaming paths before loading completes, instead of priming Whisper
alone. This moves cold shader/decoder work to explicit preparation; synthetic warm-up may not cover
all audio shapes. First real dictation can still be slower. Later activation/GUI evidence belongs
in setup.md, and the final physical gate remains E01–E08/R01–R06 with Akshat's microphone.

Updated app headless verification after the native build finished: Parakeet bound to the stable
NVIDIA selector, supports streaming and does not support translation. Load plus streaming priming
took 13.738 s (priming 6.720 s), then **batch** recognition of the old 7.14-second clip took
2.874, 0.345 and 0.338 s. This confirms native English-profile inference and content-free output,
not live streaming insertion. The first batch run is still slower despite streaming warm-up;
do not conflate preparation with covering every execution path or audio shape.

With native compilation finished and Handy closed, repeat E06/NVIDIA streaming: load 7.117 s,
silence prime 8.218 s; release/finalization **1.050, 0.314 and 0.307 s**, 0/17 lexical errors and
limited critical-token checks passed. First partials arrived about 2.3–2.4 s into the WAV.
This is the cleanest local streaming sample, still not microphone-to-paste or p95 evidence.

## Device comparison

Measured 2026-10-02 with Handy 0.9.7's headless batch path, multilingual Whisper Small, Automatic
language, no translation, cleanup or vocabulary hints, and the same 7.14-second local recording.
Each device had one model load and two inference runs in a single process. No VAD, live microphone,
clipboard or insertion was exercised by this benchmark.

- CPU: load 6.857 s; recognition runs 44.417 s and 34.742 s.
- NVIDIA MX450 / Vulkan0: load 7.721 s; recognition runs 23.629 s and 7.539 s.
- Intel Iris Xe / Vulkan1: load 7.930 s; recognition runs 44.521 s and 42.623 s.

The second NVIDIA run is about 4.6 times faster than the second CPU run, but 7.5 seconds is still
not near-instant. “Warm” here means the second run in the same model/session; filesystem/shader
caches and temperature were not controlled. These are individual samples, not p50/p95 guarantees.
Device indices are process-local; the GUI/profile must use a stable GPU selector.

## Dormant script conversion — previous requirement

The authored deterministic Rust converter averages about 5 microseconds per short synthetic
H03-style fixture (10,000 iterations). Eight native test groups and six history-delivery checks
pass, including mixed-script fixtures and fail-closed handling. It requires no text model/cloud
call and adds negligible delay compared with recognition.

This addresses script, not acoustic accuracy. Incorrectly recognized words stay incorrect; exact
loanword normalization does not justify guessing a misheard acronym. Uncommon Hindi spelling and
schwa deletion remain limited. Unit fixtures are not evidence that all spoken H01–H06 pass.

## Retained Whisper comparison evidence

Approved Whisper Turbo download: Hugging Face `ggerganov/whisper.cpp`,
`ggml-large-v3-turbo.bin`, 1,624,555,275 bytes, SHA-256
`1fc70f774d38eb169993ac391eea357ef47c88757ef72ee5943879b7e8e2bc69`.
On the same NVIDIA device/recording with the original runtime and no hints: load 23.049 s;
recognition runs 13.634 s and 3.501 s. That warm sample is roughly 10 times faster than CPU Small,
but still not instant; two runs do not establish general recognition accuracy or latency.

Use the measured NVIDIA device, preload the selected model at startup and keep it loaded during
dictation tests; keep microphone-always-on and AI cleanup off. Preload also primes Whisper with
discarded synthetic silence, paying initial decoder/kernel costs before “loaded” is shown.
Wait for startup preparation to finish; a warm-up failure can leave the first run slow.
Additional model results/activation must be recorded here
before declaring them faster; download integrity alone is not a speed or quality test.
These are previous multilingual comparisons, not the active English-only selection.

Updated private-fork runtime/profile verification: Turbo bound to the persisted NVIDIA selector
(`Vulkan0`), cleanup/translation off, Roman conversion and startup priming on. On the same
7.14-second recording, load plus synthetic priming took 36.159 s, followed by recognition/
conversion runs of 3.794 s, 3.367 s and 3.340 s. No Devanagari remained and the exact Latin acronym
API was present. That is a script/token check, not complete transcript accuracy or a new live
microphone/paste test. Process working set sampled once per second peaked at about 352 MiB;
this excludes GPU/shared memory, other processes and unsampled peaks, not total memory usage.
Keep startup cost separate from release-to-text time; the new build pays it before dictation.

The target experience is near-immediate delivery for short speech; a proposed measurable target
is warm release-to-paste under one second, with p95 and cold-start reported separately. This is
not achieved or accepted as a guarantee on the 8 GB / 2 GB VRAM laptop. Test the same public
English fixtures in the updated GUI. English-only models are now explicitly authorized by the
changed product scope; Hindi preservation is not an active gate. If latency still fails, measure
remaining queue/finalization/paste phases before choosing another model or streaming operating point.

Measure total release-to-paste separately from audio duration. The new release INFO metric
`dictation_latency` reports capture/ASR/output/paste/total milliseconds without content. Headless
`--stats-only --json` reports load and inference only. Never commit raw diagnostic output with
transcript text, recordings, model files, user profiles or history databases.
