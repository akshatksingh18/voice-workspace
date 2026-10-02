# Dictation performance and acceptance

**Status:** English-only evaluation. Akshat accepts the earlier Parakeet streaming profile's live speed.
The full-recording/vocabulary quality retest passed technical words/punctuation by Akshat's report.
Broader accuracy, insertion/reliability and quantitative p50/p95 remain open.
Turbo's older live test failed latency/Hindi acceptance. The Hindi converter is off, not a solved feature.

## Current physical acceptance boundary

Akshat reports that the selected English profile's speed is now exactly the experience he wanted.
Keep this model as the baseline; preserve the old streaming profile for comparison. No exact new
release-to-paste duration, sample count or p95 was supplied. This is qualitative live speed
acceptance, not proof of maximum accuracy, all-editor reliability or a guaranteed sub-second p95.
Akshat then tried E03: PostgreSQL became split phonetic words, an extra article appeared, and
list commas plus the terminal period were absent. Kubernetes and REST API were retained.
That streaming baseline failed technical/punctuation acceptance. After deployment, Akshat reports
the full-recording/three-term profile's technical words and punctuation worked perfectly in his
live retest. This is user-reported one-fixture acceptance; no new transcript, exact delay, repeat
count or punctuation statistics were supplied. It does not establish full E01–E12 or p95.
Next tests broaden English critical vocabulary/meaning and insertion safety. Requested spoken
self-correction is not implemented; benchmark its additional work before enabling it so it does
not regress the accepted speed. New mode/profile preparation does not inherit live speed acceptance.

## Same-recording technical/punctuation comparison

Measured 2026-10-02, offline, with Handy closed and no concurrent native compilation. Reused the
latest synthetic E03 microphone recording locally: 8.28 s, 16 kHz mono PCM. Recordings/transcripts
remain ignored. Three runs per path, explicit English, actual NVIDIA MX450 bound as Vulkan1 in
the standalone diagnostic. Each process loaded/primed its selected path; caches and thermal state
were not controlled. These are recognition/finalization timings, not full GUI release-to-paste.

- Parakeet Q8 streaming: release/finalization 0.333/0.324/0.435 s; 4 lexical word errors and
  critical-term check failed each run. No commas or sentence-ending punctuation. First partials
  arrived 2.3–2.6 s into speech. Startup load 6.961 s, discarded-silence prime 5.111 s.
- Parakeet Q8 full recording: recognition 0.439/0.406/0.378 s; critical terms retained, 1 lexical
  word error, final period but no list commas. Load 1.033 s, prime 0.189 s (cache-warm sample).
- Moonshine Small Q8 full recording: 0.531/0.223/0.220 s; critical terms retained, 1 lexical
  error, final period but no list commas. Load 2.588 s, prime 5.703 s.
- Moonshine Medium Q8 full recording: 0.416/0.299/0.292 s; critical-term check failed, 3 lexical
  errors, no commas or sentence ending. Load 2.909 s, prime 0.191 s.
- Whisper Turbo full recording: 3.358/3.224/3.220 s; 0 lexical errors, technical terms retained,
  both list commas and sentence ending present. Load 23.988 s, prime 6.059 s. This quality result
  does not justify replacing the speed-accepted model with a much slower default.

Separate post-ASR dictionary check: PostgreSQL, Kubernetes and REST API, threshold 0.18.
With the prefix-preservation fix, streaming Parakeet retained critical terms and fell to 1 lexical
error; Parakeet batch was already correct on those terms and unchanged. Medium Moonshine fell to
2 errors; Small changed casing only. Dictionary cost was 75–1,083 microseconds in Parakeet
streaming and 77–95 microseconds in batch. These few samples are not a scaling/p95 guarantee.
The dictionary preserves ordinary prefixes; it does not remove the article or infer punctuation.
All 48 standalone diagnostic/text-filter tests passed, including that regression.

Decision: retain Parakeet Q8/NVIDIA and expose opt-in full-recording recognition, warming the
chosen path. Prepare a three-term manual vocabulary for the next live test. Whole-recording
recognition improved this one clip, not all accents/utterances; longer speech can cost more after
release and batch has no live preview. The app's normalizer preserves punctuation; Parakeet's
native API ignores runtime punctuation toggles. A missing checkbox is not the cause.

After the full native release build, the deployed app's transcript-free headless path loaded/
primed in 7.886 s and recognized the same clip in 0.780/0.399/0.443 s. INFO confirms NVIDIA MX450
bound as Vulkan0; the profile has full-recording mode plus the three manual terms. The GUI stays
alive after load and batch priming (0.893 s in the sampled GUI startup). These verify deployment/
readiness and native inference, not microphone/VAD/paste latency or a new critical-word pass.

The live quality retest's punctuation passed by user report, despite the saved-clip batch sample
missing list commas. Do not generalize either sample to all utterances or claim the dictionary
creates punctuation. Broader punctuation/contextual grammar and spoken repair remain separate gates.
OpenWhispr's pinned cleanup workflow is an implementation reference (see research), not tested
local performance. No cleanup model/runtime has been downloaded or configured for this slice;
Akshat approved a separate local text-model/Windows-runtime comparison from official GitHub/Hugging
Face. It is an isolated experiment, not permission to upload recordings or enable cloud cleanup.
Never synthesize
hardcoded E03 output, insert commas around every conjunction, or silently use cloud inference.

## Local cleanup experiment — not adopted

Measured 2026-10-02 with official Qwen3-0.6B Q8 and llama.cpp b11146, pinned download/integrity
details in setup.md. `scripts/benchmark-cleanup.ps1` uses eight public dummy text fixtures, two
runs each per CPU/NVIDIA configuration, plus one NVIDIA diagnostic pass to inspect only fixed
dummy completions. No user recordings/history/transcripts are inputs. Handy's profile was
unchanged, AI cleanup off; its process residency and other user activity were not controlled.
Authenticated loopback-only helper, offline, no agent/tools/MCP/web UI/proxy;
one slot, 2,048-token context, four threads, non-thinking, temperature 0, seed 42, 96-token cap.
This deterministic screen differs from Qwen's suggested general chat sampling; it is not a claim
that every prompt/model configuration fails. No model/server is activated in Handy.

- CPU: startup/preparation 6.549 s; requests 0.187–1.210 s. Second identical requests ranged
  0.187–0.558 s. Sampled process working set about 954 MiB.
- NVIDIA configuration: explicit Vulkan1, verified device list identifies MX450; startup 5.665 s,
  requests 0.089–1.288 s, second identical requests 0.089–0.274 s. Working-set samples 974–978 MiB.
  A later diagnostic startup was 2.649 s. No independent GPU allocation/bound-device telemetry
  was captured in the log-disabled server; do not present process RAM as VRAM or whole-system memory.
- Timings include local HTTP/tokenization/inference, exclude ASR/VAD/paste and are not complete
  release-to-text. Repeated prompts benefit from KV/prefix caching. First requests were slower
  despite startup warm-up; resource caches/temperature and user activity were uncontrolled.

Only P02 (technical names), C06 (literal apology) and N01 (versions/negation) matched their expected
surface text in both repeats/device settings: 3/8 fixtures. This comparison ignores capitalization,
punctuation and whitespace; it is a narrow surface check, not comprehensive semantic validation.
P02's optional comma differed stylistically and is not itself a meaning failure. All responses
ended normally with no tool calls; none hit the output cap. Completion/fallback checks alone do
not protect meaning.

The separate fixed-dummy readback confirms real failures, not just formatting differences:
C01 and C02 kept the superseded 7 pm and deleted the 6 pm correction; C05 retained contradictory
old/new deployment clauses; D01 discarded its second sentence despite normal completion. P01
added both list commas but retained the extra article. These are unsuitable for automatic cleanup.
No real transcript/output is copied here, and no source from OpenWhispr was copied into the prompt.

Decision: do not adopt this prompt/model configuration or enable default cleanup. Retain the
user-accepted full-recording/dictionary profile without an LLM. Spoken correction remains planned;
first prove the narrow explicit full-restatement matcher and literal/quoted/ambiguous exceptions,
with raw recovery and latency gates, rather than relying on an unvalidated tiny model. Future
prompt/model comparisons are possible but need a new implementation/evaluation slice, not a
claim that downloading a model solves punctuation or correction. Helpers stopped after tests;
no persistent endpoint/service or cloud fallback was configured.

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
including feed backlog and finalization. It omits microphone/VAD/IPC/paste/history; raw recognition
is scored separately from optional dictionary matching, which was off in the initial screening.
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
in setup.md, and the final physical gate remains E01–E12/R01–R06 with Akshat's microphone.

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
is warm release-to-paste under one second, with p95 and cold-start reported separately. Akshat
accepts the current English speed qualitatively, but this numeric guarantee has not been established
on the 8 GB / 2 GB VRAM laptop. Test the same public
English fixtures in the updated GUI. English-only models are now explicitly authorized by the
changed product scope; Hindi preservation is not an active gate. If latency still fails, measure
remaining queue/finalization/paste phases before choosing another model or streaming operating point.

Measure total release-to-paste separately from audio duration. The new release INFO metric
`dictation_latency` reports capture/ASR/output/paste/total milliseconds without content. Headless
`--stats-only --json` reports load and inference only. Never commit raw diagnostic output with
transcript text, recordings, model files, user profiles or history databases.
