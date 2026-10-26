# Local setup and verification boundaries

**Status:** English-only runtime/profile evaluation; local GPU inference and model integrity are
verified, and Akshat accepts the earlier Parakeet streaming profile's live English speed.
The full-recording quality profile is deployed; Akshat reports its live technical-word/punctuation
retest worked perfectly. Broader accuracy/insertion/reliability, quantitative latency and signed
packaging remain open.
Hindi work is deferred; dedicated spoken self-correction is not implemented or enabled.

## Machine and prerequisite boundary

Read-only hardware verification on 2026-10-02: Intel Core i5-1135G7, 4 cores/8 threads, 7.8 GiB
reported system RAM; NVIDIA MX450 reports 2 GiB dedicated VRAM and Intel Iris Xe is also present.
The CPU Small baseline was measured and rejected for excessive delay; NVIDIA Vulkan is the
measured faster device. English-only Parakeet is the current candidate; no concurrent LLM is configured.
Read performance.md for exact samples and caveats; hardware presence alone is not proof of speed.

Handy's existing Windows source-build prerequisites and build evidence remain owned by
`../handy/windows-local-setup.md`. No new compiler/toolchain/dependency install was needed here.
The test executable must come from the updated Handy 0.9.7 private fork, with its embedded
production frontend. Stock Handy lacks the fork's startup warm-up and timing-only changes. This is not a notes/meeting
integration build or signed public distribution.

## Isolated Handy test runtime

Location: `runtime/handy/handy.exe` with required sibling DLLs and resources copied from the
existing release directory. The `portable` marker contains `Handy Portable Mode`, activating
`runtime/handy/Data/` for settings/models/history/recordings/logs. The user's normal Handy
profile is not overwritten. Generated files are ignored; never stage them with force.

Active quality-test settings are described in testing-guide.md. The initial portable startup was verified;
Akshat subsequently recorded/inserted speech in Notepad, reporting the failed acceptance described
in performance.md. Local headless CPU/GPU inference used saved audio without a microphone/paste.
Onboarding completion is not proof of language or delivery acceptance. The user-selected microphone,
shortcut and existing history must be preserved when tuning the profile.

Original runtime benchmark provenance SHA-256:
`5b97789e07688cf713d7d0914053dbbd40a220e747ded22f2ad3a0f53c2ece32`.
Current English quality runtime SHA-256: `d4a376bdba1c0a34c9b30e9c2369e1b2bb2bd8435dc3bbc1c341343f9ebc51c4`.
The release build used Tauri's embedded production asset protocol and passed headless native
device/inference/conversion checks. It is locally built and unsigned; do not bypass a Windows
application-control block. Rollback copies are ignored `runtime/handy/handy-before-hinglish.exe`
and `runtime/handy/Data/settings-before-hinglish.json`; no existing recordings were removed.
The prior Turbo/Hinglish fork executable is retained as `runtime/handy/handy-before-english.exe`
(SHA-256 `165f7e253283d100d2ffa1f6a147fbc5b221e5944a9df944e9815182c8cb8d8b`). Native runtime
DLL hashes matched the new source-build output, so no incompatible library replacement was made.
The English profile selects explicit English, Roman Hinglish off, translation/cleanup off,
preload on and unload Never, retaining the user's microphone/shortcut/history. Confirm startup
priming before dictating; no microphone recording is started by verification. The timing-only CLI
and standalone diagnostic omit transcript text. `settings-before-english-model.json` preserves
the prior Turbo model selection locally; earlier rollback files remain untouched.
The earlier English streaming GUI passed startup/priming (2.251 s priming in that sample), and
Akshat accepted its live speed. His subsequent E03 test failed PostgreSQL and punctuation; see
performance.md for the same-recording offline comparison. That speed report does not apply
automatically to the newly prepared quality profile or establish numeric p95/insertion reliability.

The quality fork's full Tauri Windows release build passed with embedded production frontend.
All 14 sibling DLLs matched the deployed runtime; only the executable was replaced. The isolated
profile enables full-recording recognition and PostgreSQL/Kubernetes/REST API, threshold 0.18.
Every other pre-existing setting was checked unchanged, including microphone, shortcut and privacy;
history/recordings were not deleted. Non-overwriting rollback copies are
`handy-before-english-quality.exe` (SHA-256
`b09a409df19f66e1de6b343a5240b35d8250a94baaac1ac99fb94856635c375d`) and
`Data/settings-before-english-quality.json`; prior rollback files remain untouched.
Updated transcript-free headless inference on the same 8.28-second E03 clip loaded/primed in
7.886 s, then recognized in 0.780/0.399/0.443 s on the persisted NVIDIA setting (Vulkan0 in this app).
No microphone, VAD, paste or history insertion was exercised. The updated GUI stays alive for at
least 60 seconds after NVIDIA load and full-recording priming (0.893 s in the sampled startup).
Persisted mode/vocabulary and unchanged other profile fields were verified. This is readiness,
not by itself a microphone/paste/accuracy test. Akshat then reported a successful live technical/
punctuation retest; no exact latency or completed wider suite was supplied. AI cleanup remains off.
A separate local text-model/Windows-runtime test from official GitHub/Hugging Face is approved;
this does not authorize uploading audio/transcripts, cloud processing or automatic adoption.

## Local model inputs

English candidate: cached **Parakeet Unified EN 0.6B Q8_0** (731,357,568 bytes), model ID
`handy-computer/parakeet-unified-en-0.6b-gguf/parakeet-unified-en-0.6b-Q8_0.gguf`.
Its pinned snapshot `7e948f21b7bdbac698d3318db9d350f1096f3b6c` is under isolated
`Data/huggingface/hub/`; its SHA-256 matches catalog/LFS metadata:
`4b50b6dd862bf6e346929aaf4f5eaacec003bfa3f56462d6c874b41ef2f38795`.
This is the native GGUF streaming model, not ONNX Parakeet V2/V3. No new Parakeet download was needed.

Authorized English comparisons downloaded from Hugging Face and hash-verified:

- Moonshine Streaming Small Q8_0: 198,506,848 bytes, revision
  `7e32b1b3dfce5d3a38dad59630ffce608f15c4aa`.
- Moonshine Streaming Medium Q8_0: 295,793,568 bytes, revision
  `0f99e956a9e63d591ddd7f2a20dfead255e96c68`.

Both are in `Data/models/`. `scripts/local-models.json` owns their exact hashes/paths and the
Parakeet cache path; `model-input.ps1` refuses paths outside isolated Data. Permission to test/download
is not permission to redistribute weights. Parakeet's port lists CC-BY-4.0 while the current NVIDIA
base lists NVIDIA Open Model License; reconcile this before packaging. Moonshine's current English
cards list MIT. No weights are shipped to GitHub. Read performance.md for actual comparison limits.

The following older multilingual inputs are retained, not the active language scope:

Authorized source: [ggerganov/whisper.cpp on Hugging Face](https://huggingface.co/ggerganov/whisper.cpp).
File: `ggml-small.bin`, 487,601,967 bytes. SHA-256 checked against Hugging Face LFS metadata:
`1be3a9b2063867b937e64e2ec7483364a79917e157fa98c5d94b5c1fffea987b`.
Stored at `runtime/handy/Data/models/ggml-small.bin`; Handy model ID `small`, retained for comparison.
This is multilingual, not the `.en` variant. Download/hash verification does not prove accuracy.
Model/packaging redistribution license review remains separate from permission to download/test.

Akshat also explicitly approved local Turbo testing. `ggml-large-v3-turbo.bin`, 1,624,555,275 bytes,
SHA-256 `1fc70f774d38eb169993ac391eea357ef47c88757ef72ee5943879b7e8e2bc69` matches Hugging Face
LFS metadata and Handy's catalog checksum. Stored in the same local models directory, model ID
`turbo`, retained for explicit comparisons. The active English-only profile selects Parakeet/NVIDIA,
English, startup preload/synthetic priming on, unload Never, Roman conversion/translation/cleanup
off, INFO timings and debug off. Initial ASR screening used an empty dictionary; the next quality
profile seeds PostgreSQL/Kubernetes/REST API, threshold 0.18, with full-recording mode. Backend
indices can change between processes; persist the stable NVIDIA selector and verify bound device name.

The authored converter passes synthetic tests and fails closed on unsupported script symbols.
It does not repair acoustic recognition errors, and unfamiliar-word spelling can be imperfect.
Hindi's live acoustic/meaning test failed and its requirement was removed; the converter is off.
English technical-word/meaning fixtures, reliability checks and quantitative release-to-paste
measurements remain required despite the user's qualitative speed acceptance.
See ../handy/voice-workspace-features.md for implementation.

On another machine, rebuild/copy the updated private Handy fork's release executable, its top-level runtime DLLs and
resources. For a **fresh, empty** runtime only, copy `scripts/portable` beside the executable
and `scripts/handy-baseline.json` to `runtime/handy/Data/settings_store.json`. Refuse to overwrite
an existing profile. Download the same model from the authorized Hugging Face destination and
verify size/hash for the selected model, then run the verifier/launcher. For Parakeet, use Handy's
supported downloader/cache layout or reproduce the pinned snapshot path in local-models.json;
do not place a duplicate file arbitrarily and assume registry detection. The template uses Auto
GPU selection because hardware identities differ; this laptop's live profile must explicitly select
the measured NVIDIA device. The launcher checks for fork CLI features and rejects stock builds.
These generated inputs are deliberately not
in GitHub. Do not copy an existing user's settings/history into the repository.

## Second laptop (Windows 11 ARM64, Snapdragon X) runtime state

The project folder was unpacked here without executables, DLLs, models or downloads. All model
and download files are restored from the pinned sources above, each checked for size and SHA-256
(`model-input.ps1` passes `Get-VoiceModelInput -HashModel` for Parakeet, Turbo, Small and both
Moonshine files): Parakeet in the Hugging Face cache layout under
`Data/huggingface/hub/models--handy-computer--parakeet-unified-en-0.6b-gguf/` (file in
`blobs/<sha256>`, a hard link at `snapshots/<revision>/`, `refs/main` holding the revision),
the other ASR models in `Data/models/`, `Qwen3-0.6B-Q8_0.gguf` in `runtime/cleanup/models/`, and
`llama-b11146-bin-win-vulkan-x64.zip` plus `OpenWhispr-1.10.2.exe` in `downloads/` (the exe
re-verified as Authenticode-valid, signer Gizmo Labs Inc.; still not installed or launched).
The extracted llama.cpp folder is the x64 Vulkan build and its launcher hash matches; this
laptop's Snapdragon has no use for it, and the cleanup experiment stays off.

`runtime/handy/handy.exe` is the unsigned CPU-only ARM64 build from the fork's
`windows-arm64-build.yml` (run 40252857590, commit `12ee212`; `../handy/windows-local-setup.md`
owns the workflow), SHA-256 `61170cd9ffb5982845842879271129982ac0a9b6d12649505ec6f7b6bea16bad`,
with the eight ARM64 VC++ runtime DLLs beside it, all matching the run's `SHA256SUMS.txt`. There
are no `ggml*`/`transcribe` DLLs. `Data/settings_store.json` now has `transcribe_accelerator` set
to `cpu` and `transcribe_gpu_device` cleared (rollback copy `Data/settings-before-arm64-cpu.json`);
every other setting is unchanged. It has not been launched here: whether Windows allows the
unsigned exe, and Parakeet's speed on this CPU, are unverified. The three `handy-before-*.exe`
rollback copies and `asr_latency.exe` from the first laptop are not recreated.

## Separate local cleanup experiment — not activated in Handy

Akshat approved local text-cleanup testing from official GitHub/Hugging Face. Downloaded and
hash-verified official [Qwen3-0.6B Q8 GGUF](https://huggingface.co/Qwen/Qwen3-0.6B-GGUF), revision
`23749fefcc72300e3a2ad315e1317431b06b590a`, Apache-2.0, 639,446,688 bytes, SHA-256
`9465e63a22add5354d9bb4b99e90117043c7124007664907259bd16d043bb031`.
Location: ignored `runtime/cleanup/models/Qwen3-0.6B-Q8_0.gguf`, outside Handy's ASR discovery.
It is a small experiment candidate, not a maximum-accuracy recommendation or new dictation model.

Official [llama.cpp b11146 Windows Vulkan package](https://github.com/ggml-org/llama.cpp/releases/tag/b11146),
source `7fe450e19305b828c199d602c23a8337aaa1f03b`,
[MIT source](https://github.com/ggml-org/llama.cpp/blob/7fe450e19305b828c199d602c23a8337aaa1f03b/LICENSE)
plus bundled dependency notices.
`downloads/llama-b11146-bin-win-vulkan-x64.zip`, 32,127,004 bytes; SHA-256 matches GitHub's digest:
`55a378aa095b466979d85075234f66d7655c7a7483222af0c006c0e55b4d7bd6`.
Extracted separately to `runtime/cleanup/llama-b11146-vulkan/`; never mix its DLLs with Handy's.
The server launcher is unsigned (not an Authenticode/SLSA security audit), SHA-256
`7b886298b688509ced3e92b420edd57dd3d665da72c1fc207d7a537be5870352`.
Version/help/device checks execute normally; no Windows application-control bypass was used.

Opt-in PowerShell 7.2+ `scripts/benchmark-cleanup.ps1` verifies the model/archive and every
extracted executable/DLL against the verified archive. It tests eight built-in public dummy
fixtures, not stored audio/history/files, with an independently authored prompt. An owned helper
uses only 127.0.0.1, an ephemeral port/key, no HTTP proxy, offline mode, no web UI/agent/tools/MCP,
non-thinking mode, one slot, 2,048-token context and four CPU threads. CPU and NVIDIA Vulkan1
are compared separately; process indices differ from Handy. The helper stops in normal/error
cleanup and never changes Handy settings. If forcibly interrupted, inspect the exact experiment
executable/PID before stopping an orphan; never kill all dictation/LLM processes.

The benchmark ran on CPU and the explicit NVIDIA configuration and failed spoken-correction/
meaning-preservation gates; results/adoption decision belong in performance.md. Helpers stopped
after testing. Optional `-ShowDummyOutput` exposes fixed public fixture completions only for scoring
diagnosis; default output is aggregate-only and the runner accepts no user-data input.
The downloaded candidate is not
configured in Handy, no persistent server/service is installed, no cloud cleanup or recording/text
uploads occur, and the successful non-LLM dictation profile remains the default. These downloads
and raw runtime state stay ignored; model redistribution/dependency packaging are separate gates.

## OpenWhispr download only

Official [v1.10.2 release](https://github.com/OpenWhispr/openwhispr/releases/tag/v1.10.2), published
2026-09-15. Asset `OpenWhispr-1.10.2.exe`, 254,108,352 bytes; downloaded into `downloads/`.
Authenticode status Valid, signer Gizmo Labs Inc. SHA-256:
`7f62d334548fa3f03b97b096b05eec836f179550cfc045dfa1cce492105c1ac8`.
No installation, launch, configured offline profile or model inference is claimed. Signature
verification establishes publisher/integrity, not an audit of privacy defaults. Source gitlink
tracks the manifest's main revision, which may be ahead of this release.

## References and recovery

Nine top-level source checkouts; exact revisions/URLs/licenses in repositories.json and gitlinks.
No third-party dependency installation or nested/premium submodule initialization. Local push
URLs disabled and hooks disabled for these evidence checkouts. Source files are not merged.

The scripts use temporary, exact-path Git safe-directory options for this project and its nine
known reference paths, handling Windows sandbox/user ownership differences without trusting all
repositories or modifying global Git configuration. Script syntax, launcher/restore `-WhatIf`,
source pin/remote/license-file checks and runtime/model hashing passed. An actual repeat restore
on the already present checkouts preserved all pins and source cleanliness. A full fresh-machine
restore has not been run; no third-party application feature is validated by those checks.

Project remote: `https://github.com/akshatksingh18/voice-workspace.git`, owned by Akshat and public.
Review every push as public content. Runtimes/weights/private-tests are ignored.
The initial source/docs/gitlink push was verified against GitHub's main commit. No runtime,
model or private test file is tracked. This is source recovery, not a private-data backup.
Private audio/text data has no backup destination configured; personal-project is excluded from
the workspace OneDrive archive. Source recovery is not private-data recovery.

## Required manual checks / things deliberately not configured

- Retain Parakeet/full-recording/three-term profile after the successful user-reported quality retest;
  broaden technical/punctuation fixtures without assuming one pass proves universal accuracy.
- Verify English meaning/critical words, measured release-to-paste timing, cancellation, focus and clipboard behavior.
- Spoken self-correction is proposed; no rule engine, cleanup model or previous-insertion edit mode is enabled.
- OpenWhispr/Meetily meeting runtime preparation after baseline; no capture module selected yet.
- A small cleanup candidate/runtime is downloaded only for the isolated experiment; no Handy
  cleanup/summary model configured, persistent local/LAN service, Docker, cloud keys or account login.
- No calendar integrations, automatic meeting recording, external MCP, sync or biometric profiles.
- No integrated application, iPhone runtime, production signing or encrypted-at-rest implementation.
