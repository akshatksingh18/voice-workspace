# Dictation performance and acceptance

**Status:** CPU bottleneck reproduced; GPU and local script conversion measured. Instant
dictation and updated live accuracy/insertion acceptance have not passed.

## Initial physical result

Akshat's first Notepad test did capture, recognize and insert speech. His reported release-to-text
delay exceeded 10 seconds. Delivered Hindi used Devanagari and a spoken technical acronym was
rendered phonetically. This is a failed language/speed acceptance test, not a passed dictation
suite. The screenshot/audio/transcripts remain local and are not in this repository.

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

## Script conversion

The authored deterministic Rust converter averages about 5 microseconds per short synthetic
H03-style fixture (10,000 iterations). Eight native test groups and six history-delivery checks
pass, including mixed-script fixtures and fail-closed handling. It requires no text model/cloud
call and adds negligible delay compared with recognition.

This addresses script, not acoustic accuracy. Incorrectly recognized words stay incorrect; exact
loanword normalization does not justify guessing a misheard acronym. Uncommon Hindi spelling and
schwa deletion remain limited. Unit fixtures are not evidence that all spoken H01–H06 pass.

## Runtime tuning and next gate

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
fixtures in the updated GUI, then pursue a smaller/quantized multilingual decoder or bounded
incremental recognition if the measured latency still fails. Do not select an English-only engine
to win a speed benchmark while losing Hindi.

Measure total release-to-paste separately from audio duration. The new release INFO metric
`dictation_latency` reports capture/ASR/output/paste/total milliseconds without content. Headless
`--stats-only --json` reports load and inference only. Never commit raw diagnostic output with
transcript text, recordings, model files, user profiles or history databases.
