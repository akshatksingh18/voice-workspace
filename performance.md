# Dictation performance and acceptance

Measured results, rejected options and the decisions they support. Project status lives in
[CLAUDE.md](CLAUDE.md).

## Current physical acceptance boundary

First laptop (x64, NVIDIA):

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

## Second laptop — Snapdragon X CPU (ARM64)

Measured 2026-10-26 on the Snapdragon X X126100 (8 Oryon cores, 15.6 GiB RAM), Windows 11 ARM64,
Balanced power plan, **on battery**, with the CI-built CPU-only ARM64 exe (setup.md). These results
do not transfer to the first laptop's x64/NVIDIA profile, or the reverse.

Headless full-recording path (`--stats-only`), Parakeet Q8 bound to the Oryon CPU, saved local clips:

- 8.28 s E03 clip: load 1.804 s (first process), recognition 0.467/0.471/0.494/0.451/0.496 s
  (first laptop's NVIDIA: 0.780/0.399/0.443 s).
- 7.14 s clip: load 0.848 s, recognition 0.408–0.492 s. 12.21 s clip: load 0.874 s, 0.721–0.754 s.
- About 17–18× real time; recognition grows roughly 55–60 ms per second of speech.

GUI startup: model loaded and warmed about 1 s after launch (warm-up 72 ms); working set ~1.1 GB.
Live Notepad run, built-in Microphone Array, INFO `dictation_latency` (stop-to-paste):

| Hold | Audio | ASR | Paste | Stop-to-paste |
|---|---|---|---|---|
| E01, first dictation ~85 min after startup | 4.80 s | 2.861 s | 0.228 s | **3.192 s** |
| E03 ×3 in one hold | 23.16 s | 1.350 s | 0.225 s | 1.673 s |
| E07 | 6.57 s | 0.432 s | 0.226 s | **0.723 s** |
| ~17 s free speech | 16.74 s | 0.976 s | 0.225 s | 1.268 s |

Capture was 55–87 ms; output processing 0 ms. Akshat called the delay "good enough" but asked for
closer to instant. Findings:

- **First use after a long idle is slow** (2.86 s ASR for 4.8 s of audio, ~6× the warm rate)
  even though startup warm-up succeeded; the idle re-warm below fixes it.
- **Warm delay is mostly ASR**, which scales with utterance length; short sentences paste in ~0.7 s.
- **Paste's 225 ms is mostly after the text is visible**: 60 ms pre-delay, then Ctrl+V with a 100 ms
  modifier hold and a 60 ms post-delay before clipboard restore. Perceived delay is ~150 ms below
  the logged stop-to-paste.

Accuracy (Akshat's Notepad text, scored here; text not stored): every PostgreSQL/Kubernetes/REST API
instance correct (3/3), numbers in E01/E07 preserved, sentence-ending periods mostly present.
Failures: E03 list commas missing all three times and one repeat added "the" before PostgreSQL;
E07 lost the comma before "not" and the period after "2.10"; E01 gave "3.30" for "three thirty".
False starts are transcribed literally (cleanup off). This matches the
earlier saved-clip batch result (no list commas), so the first laptop's "perfect" retest was not
a general punctuation guarantee.

**Retest with the re-warm build** (re-warm on shortcut press after 15 s idle, 20 ms paste
pre-delay; setup.md), same mic, on battery:

| Hold | Audio | Re-warm | ASR | Paste | Stop-to-paste |
|---|---|---|---|---|---|
| E01 after 26.8 min idle | 4.35 s | 183 ms, during speech | 0.488 s | 0.187 s | **0.743 s** (was 3.192 s) |
| E07 ×3 in one hold | 16.74 s | not needed (6 s idle) | 1.207 s | 0.187 s | 1.457 s |

The re-warm removes the idle first-use spike: the first dictation after a long idle now matches
warm speed. Paste fell by the expected ~40 ms. Keep both. E01 was fully correct ("three thirty"
as words this time; number formatting varies between runs).

**E07 meaning failure:** all three repeats came out as "2.102.10": "not" was dropped and the two
versions merged, losing the negation. Re-running the saved recording offline gives the same output
3/3, while the earlier single-hold E07 recording keeps "not" 3/3. So it is the model's reading of
that audio (faster run-on repeats), not the re-warm, paste change or randomness. The three custom
words are unrelated to this phrase; a dictionary-off rerun was not done. Negation/number fixtures
need per-sentence holds and more repeats before calling this pass or fail.

**Per-sentence retest** (one sentence per hold, normal pace): six holds of 4.7–10.0 s pasted in
0.545/0.577/0.604/0.676/0.697/0.870 s stop-to-paste (ASR 0.288–0.606 s, paste ~0.186 s); a re-warm
ran once after 7.5 min idle (160 ms). Akshat pasted five of the six results:

- E01 1/1 fully correct, including the comma before "not".
- E07 3/3 kept "not", "2.1", "2.10" and "15 milliseconds": meaning preserved. The comma landed
  after "2.10" instead of a sentence break, and two of three lacked the final period.
- E12 1/1 kept "HTTP 429" and "500 milliseconds"; both sentence-ending periods were missing.

So negation held when each sentence had its own hold; the earlier loss came with fast run-on
repeats. Remaining weakness: sentence boundaries inside one hold become commas or nothing.

Early-chunk recognition recognizes each finished phrase at a pause while the key is held, so
release only decodes the last phrase (setup.md). It targets the long-hold cost above (1.27–1.67 s
for 17–23 s holds). Upstream #2282 chunking only cuts audio over 40 s, so it does not help normal
dictation. Plugged-in/Best-performance timing is unmeasured. Streaming mode is faster on long holds
but failed E03 accuracy; a smaller quant is not justified on speed alone.

**Standalone build on the new engine worker** (Release v0.10.0, commit `3c57e35c`), headless
`--stats-only` (plugged in), three runs each: a 5.76 s clip 0.315–0.341 s (worker load 1.741 s) and a 7.20 s clip
0.490–0.538 s (load 1.039 s), about 15–18x real time. GUI startup warm-up 72–121 ms.

**Live combined retest (2026-10-30)**, Snapdragon X CPU, built-in mic, Notepad, Left Ctrl+S:

| Hold / Content | Audio | Re-warm | Early chunks | Tail audio / decode | Release ASR | Paste | Stop-to-paste |
|---|---|---|---|---|---|---|---|
| E01 after 108.9 min idle | 4.38 s | 1,839 ms | 0 (none) | 4.38 s / 255 ms | 0.260 s | 0.193 s | **0.525 s** (was 3.192 s cold) |
| E01 + E07 + E12 + E03 (32.1 s hold) | 29.12 s | 101 ms (66 s idle) | 3 chunks (21.47 s / 1,350 ms) | 7.65 s / 414 ms | 0.418 s | 0.187 s | **0.671 s** (was 1.67 s on 23 s) |
| E06 + E08 + E09 (22.5 s hold) | 18.14 s | 93 ms (38 s idle) | 3 chunks (18.14 s / 1,016 ms) | 0.00 s / 0 ms | **0.001 s** | 0.192 s | **0.254 s** |

Findings:
- **Idle re-warm verified on new engine:** after 108.9 min idle, re-warm executed during speech;
  first dictation pasted in **525 ms** (ASR 260 ms), eliminating the cold-idle spike (down from 3.192 s).
- **Early phrase recognition eliminates long-hold release delay:**
  - On the 32.1 s hold, 3 early phrases (21.5 s of speech) were decoded in background during speech
    pauses; only the final 7.65 s tail was decoded after release (418 ms ASR), pasting in **671 ms**.
  - On the 22.5 s hold, all 18.14 s of speech was decoded during pauses before release (`tail_audio_ms=0`);
    post-release ASR was **1 ms**, and total stop-to-paste was **254 ms** (purely Windows key release / paste delay).
    Perceived latency was near-instantaneous.
- **Accuracy and phrasing across chunk boundaries:**
  - Meaning-critical tokens preserved 100%: negation ("not Friday", "not 2.10", "do not deploy today"),
    versioning ("version 2.1 not 2.10"), numbers and units ("15 milliseconds", "HTTP 429", "500 milliseconds"),
    and user name ("Akshat").
  - Technical vocabulary: PostgreSQL, Kubernetes, and REST API all 3/3 capitalized and spelled correctly (custom words).
    OAuth, JWT, and Redis recognized correctly without being in Custom Words.
  - No duplicated or dropped phrases at pause boundaries. Sentence boundaries inside continuous holds
    occasionally omit a trailing period (e.g. between E08 and E09) or comma, but semantic integrity is intact.
  - Decision: keep early phrase recognition enabled.

## Rejected options

All measured 2026-10-02 on the first laptop (x64, NVIDIA MX450) unless noted. Full samples are in
Git history (commit `e6e7a44`).

| Option | Key evidence | Decision |
|---|---|---|
| Whisper Small (multilingual) on CPU or Intel Iris Xe | Same 7.14 s clip, second run: CPU 34.742 s, Intel 42.623 s, NVIDIA MX450 7.539 s | Rejected for excessive delay; NVIDIA Vulkan chosen on that laptop |
| Hindi/Hinglish dictation (first live test, then updated Turbo) | First live test: over 10 s, Devanagari output, acronym rendered phonetically. Turbo live: 4.029–4.527 s release-to-paste (ASR 3.585–4.007 s); Hindi delivered in English | English-only scope; Hindi/Hinglish removed |
| Hindi script converter | About 5 microseconds per short fixture; synthetic tests pass and fail closed; does not fix acoustic errors | Dormant and off; code and fixtures stay recoverable |
| Whisper Turbo as the English default | Saved E03: 0 lexical errors with both list commas, but 3.220–3.358 s recognition and 23.988 s load | Manual accuracy comparison/fallback only; never invoked automatically |
| Parakeet Q8 streaming | Live E03: PostgreSQL became split phonetic words, an extra article, no list commas or final period. Saved E03: 4 lexical errors, critical-term check failed each run | Replaced by full-recording mode (next section) |
| Moonshine Streaming Small/Medium Q8 | Batch fast, but default streaming release on E06 was 1.621–7.117 s; Medium failed E03 critical terms | Not adopted; decode interval/CPU path remain possible later experiments |
| Smaller Parakeet quant | Not tested | Not justified by advertised speed alone |
| Qwen3-0.6B Q8 cleanup | 3/8 dummy fixtures; kept superseded times and dropped clauses | Not adopted (see below) |

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

The deployed quality build's headless path recognized the same clip in 0.780/0.399/0.443 s after
a 7.886 s load/prime (NVIDIA MX450 bound as Vulkan0); that verifies deployment and native
inference, not microphone/VAD/paste latency.

The live quality retest's punctuation passed by user report, despite the saved-clip batch sample
missing list commas. Do not generalize either sample to all utterances or claim the dictionary
creates punctuation. Broader punctuation/contextual grammar and spoken repair remain separate gates.
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

## How to measure

- The target experience is near-immediate delivery for short speech; a proposed measurable target
  is warm release-to-paste under one second, with p95 and cold-start reported separately.
- Measure total release-to-paste separately from audio duration. The release INFO metric
  `dictation_latency` reports capture/ASR/output/paste/total milliseconds without content. Headless
  `--stats-only --json` reports load and inference only.
- The standalone `../voice-workspace-desktop/src-tauri/examples/asr_latency.rs` diagnostic
  (`scripts/benchmark-asr.ps1`) warms with one second of discarded silence, then paces
  100 ms frames at real-time speed for streaming. `release_ms` is the time beyond the WAV's duration,
  including feed backlog and finalization. It omits microphone/VAD/IPC/paste/history.
- Always record actual device name, not assumed index. Device indices are process-local; the
  GUI/profile must use a stable GPU selector.
- Keep startup cost separate from release-to-text time. A warm-up failure can leave the first run slow.
- Catalog scores and external WER do not prove maximum accuracy for accented speech.
- Additional model results/activation must be recorded here
  before declaring them faster; download integrity alone is not a speed or quality test.
- If latency still fails, measure remaining queue/finalization/paste phases before choosing
  another model or streaming operating point.
- Never commit raw diagnostic output with transcript text, recordings, model files, user profiles
  or history databases.
