# Local setup and verification boundaries

Prepared runtimes, models, install steps and recovery per laptop. Project status lives in
[CLAUDE.md](CLAUDE.md); measured timings and accuracy in [performance.md](performance.md); open
setup work in [todo.md](todo.md).

## Isolated desktop-app test runtime

Windows build prerequisites, CI workflows and build evidence are owned by
`../voice-workspace-desktop/windows-local-setup.md`. The test executable must come from that
project (the desktop app, started from Handy), with its embedded production frontend; stock Handy
lacks the startup warm-up, re-warm, early phrases and timing-only changes. This is not a
notes/meeting integration build or signed public distribution.

Location: ignored `runtime/desktop/` (named `runtime/handy/` before the app became its own
project): `voice-workspace.exe` with its sibling DLLs and the `resources/` folder from
`src-tauri/resources`. The `portable` marker keeps its original text, `Handy Portable Mode`, which
the app still requires; it activates `runtime/desktop/Data/` for settings, models, history,
recordings and logs (`Data/logs/voice-workspace.log`; older runs logged to `handy.log`). No
normal user profile is touched. Generated files are ignored; never stage them with force.

History keeps the latest 20 entries, so older recordings drop out of `Data/recordings/`.
`private-tests/archive/2026-10-02-first-live-tests/` holds the 7 recordings from the first live
test (2 October, x64 laptop) that had survived only in an old vault copy, plus that day's history
database. Like all of `private-tests/` it is ignored by Git and kept in the local-only vault.

The build is locally built or CI-built and unsigned; do not bypass a Windows application-control
block. Onboarding completion is not proof of language or delivery acceptance. The user-selected
microphone, shortcut and existing history must be preserved when tuning the profile. Confirm
startup priming before dictating; no microphone recording is started by verification. The
timing-only CLI and standalone diagnostic omit transcript text.
Active quality-test settings are described in testing-guide.md.

## Install or update the app

To install or update the app on either laptop, quit it and run `scripts/install-desktop.ps1`: it
downloads the ARM64 or x64 zip for that laptop from the latest `voice-workspace-desktop` GitHub
Release, checks its SHA-256, moves the current exe, DLLs and `resources/` into a dated
`rollback-*` folder with a settings copy, and leaves `Data/` alone. It needs a prepared runtime.
For a **fresh, empty** runtime only, first create `runtime/desktop/`, copy `scripts/portable`
into it and `scripts/handy-baseline.json` to `runtime/desktop/Data/settings_store.json`. Refuse to overwrite
an existing profile. Download the same model from the authorized Hugging Face destination and
verify size/hash for the selected model, then run the verifier/launcher. For Parakeet, use Handy's
supported downloader/cache layout or reproduce the pinned snapshot path in local-models.json;
do not place a duplicate file arbitrarily and assume registry detection. The template uses Auto
GPU selection because hardware identities differ; this laptop's live profile must explicitly select
the measured NVIDIA device. The launcher checks for the app's CLI features and rejects stock builds.
These generated inputs are deliberately not
in GitHub. Do not copy an existing user's settings/history into the repository.

## Second laptop (Windows 11 ARM64, Snapdragon X) — current

The project folder was unpacked here without executables, DLLs, models or downloads. All model
and download files are restored from the pinned sources below, each checked for size and SHA-256
(`model-input.ps1` passes `Get-VoiceModelInput -HashModel` for Parakeet, Turbo, Small and both
Moonshine files): Parakeet in the Hugging Face cache layout under
`Data/huggingface/hub/models--handy-computer--parakeet-unified-en-0.6b-gguf/` (file in
`blobs/<sha256>`, a hard link at `snapshots/<revision>/`, `refs/main` holding the revision),
the other ASR models in `Data/models/`, `Qwen3-0.6B-Q8_0.gguf` in `runtime/cleanup/models/`, and
`llama-b11146-bin-win-vulkan-x64.zip` plus `OpenWhispr-1.10.2.exe` in `downloads/` (the exe
re-verified as Authenticode-valid, signer Gizmo Labs Inc.; still not installed or launched).
The extracted llama.cpp folder is the x64 Vulkan build and its launcher hash matches; this
laptop's Snapdragon has no use for it, and the cleanup experiment stays off.
`runtime/cleanup/` and the zip are parked in `%LOCALAPPDATA%\ai-cleanup\phase3-holding\`.

`runtime/desktop/` holds GitHub Release **v0.10.0** (`voice-workspace-desktop` commit
`3c57e35c`, [release run 40520112353](https://github.com/akshatksingh18/voice-workspace-desktop/actions/runs/40520112353)),
installed with `scripts/install-desktop.ps1`: the unsigned CPU-only ARM64 `voice-workspace.exe`
(SHA-256 `b8421972d307c859b952ba2b020563b0758c2a74fdf171857bc662995addb055`), its eight ARM64
VC++ runtime DLLs and `resources/` (tray icons and the `silero-vad-v6.2-F32.gguf` voice detector
the new engine needs), with `VERSION.txt` and the zip's `SHA256SUMS.txt`. It is Handy's final
engine with idle re-warm and early phrases ported to its worker, after the standalone makeover.
There are no `ggml*`/`transcribe` DLLs. Windows added no download mark to the installed files.

Rollback copies, newest first:

- `rollback-unversioned-20261027-094056/`: the same code built by CI before the release, with its
  DLLs, resources and a settings copy.
- `handy-before-standalone.exe`: old engine with re-warm and early chunks.
- `handy-before-early-chunks.exe`: old engine, re-warm only.
- `handy-before-rewarm.exe`: first tested build.

Those three old-engine exes need `resources-before-standalone/` renamed back to
`resources/`. Settings before the standalone change are in `Data/settings-before-standalone.json`.

Hardware is a Snapdragon X X126100 (8 Oryon cores, 15.6 GiB RAM, Adreno X1-45, unused). The exe's
PE header is ARM64 and it is not marked as downloaded; Windows runs it without an
application-control block (Smart App Control reports off; nothing was bypassed). `--list-devices`
shows only the Oryon CPU and portable mode resolves to this `Data/`. The release starts, loads
Parakeet in its worker process and warms it. Saved profile on this laptop:
`transcribe_accelerator` `cpu` with no GPU device (rollback `Data/settings-before-arm64-cpu.json`),
microphone **Default** (the built-in Microphone Array; the first laptop's C922 is absent),
Transcribe shortcut **Left Alt+Space** (push-to-talk; rollback `Data/settings-before-alt-space.json`; was Left Ctrl+S), paste pre-delay **20 ms** (was 60; rollback
`Data/settings-before-paste-delay.json`) with the 60 ms after-paste delay kept for clipboard
restore, and `early_chunk_recognition` **true** (no UI toggle; edit with the app closed; rollback
`Data/settings-before-early-chunks.json`). Idle re-warm and early phrases are verified live on
this engine (performance.md). `asr_latency.exe` from the first laptop is not recreated.

## First laptop (x64, NVIDIA)

Read-only hardware verification on 2026-10-02: Intel Core i5-1135G7, 4 cores/8 threads, 7.8 GiB
reported system RAM; NVIDIA MX450 reports 2 GiB dedicated VRAM and Intel Iris Xe is also present.
NVIDIA Vulkan is the measured faster device; no concurrent LLM is configured. Hardware presence
alone is not proof of speed.

Its runtime still holds the older Handy-era executable in `runtime/handy/`; that laptop needs the
rebuild and folder rename in todo.md. Original runtime benchmark provenance SHA-256:
`5b97789e07688cf713d7d0914053dbbd40a220e747ded22f2ad3a0f53c2ece32`.
Current English quality runtime SHA-256: `d4a376bdba1c0a34c9b30e9c2369e1b2bb2bd8435dc3bbc1c341343f9ebc51c4`.

The English profile selects explicit English, Roman Hinglish off, translation/cleanup off,
preload on and unload Never, retaining the user's microphone/shortcut/history. The isolated
profile enables full-recording recognition and PostgreSQL/Kubernetes/REST API, threshold 0.18,
with INFO timings and debug off. Backend indices can change between processes; persist the stable
NVIDIA selector and verify bound device name.

Rollback copies there (no existing recordings were removed):

- `runtime/handy/handy-before-hinglish.exe` and `runtime/handy/Data/settings-before-hinglish.json`.
- The prior Turbo/Hinglish fork executable is retained as `runtime/handy/handy-before-english.exe`
  (SHA-256 `165f7e253283d100d2ffa1f6a147fbc5b221e5944a9df944e9815182c8cb8d8b`).
- `settings-before-english-model.json` preserves the prior Turbo model selection locally.
- `handy-before-english-quality.exe` (SHA-256
  `b09a409df19f66e1de6b343a5240b35d8250a94baaac1ac99fb94856635c375d`) and
  `Data/settings-before-english-quality.json`.

## Local model inputs

English candidate: cached **Parakeet Unified EN 0.6B Q8_0** (731,357,568 bytes), model ID
`handy-computer/parakeet-unified-en-0.6b-gguf/parakeet-unified-en-0.6b-Q8_0.gguf`.
Its pinned snapshot `7e948f21b7bdbac698d3318db9d350f1096f3b6c` is under isolated
`Data/huggingface/hub/`; its SHA-256 matches catalog/LFS metadata:
`4b50b6dd862bf6e346929aaf4f5eaacec003bfa3f56462d6c874b41ef2f38795`.
This is the native GGUF streaming model, not ONNX Parakeet V2/V3.

Authorized English comparisons downloaded from Hugging Face and hash-verified:

- Moonshine Streaming Small Q8_0: 198,506,848 bytes, revision
  `7e32b1b3dfce5d3a38dad59630ffce608f15c4aa`.
- Moonshine Streaming Medium Q8_0: 295,793,568 bytes, revision
  `0f99e956a9e63d591ddd7f2a20dfead255e96c68`.

Both are in `Data/models/`. `scripts/local-models.json` owns their exact hashes/paths and the
Parakeet cache path; `model-input.ps1` refuses paths outside isolated Data. Permission to test/download
is not permission to redistribute weights. Parakeet's port lists CC-BY-4.0 while the current NVIDIA
base lists NVIDIA Open Model License; reconcile this before packaging. Moonshine's current English
cards list MIT. No weights are shipped to GitHub.

Older multilingual Whisper inputs are retained for comparison, not the active language scope:

- Authorized source: [ggerganov/whisper.cpp on Hugging Face](https://huggingface.co/ggerganov/whisper.cpp).
- File: `ggml-small.bin`, 487,601,967 bytes; model ID `small`; SHA-256 checked against Hugging Face LFS metadata:
  `1be3a9b2063867b937e64e2ec7483364a79917e157fa98c5d94b5c1fffea987b`.
  Stored at `runtime/desktop/Data/models/ggml-small.bin` (`runtime/handy/` on the x64 laptop until renamed).
  This is multilingual, not the `.en` variant.
- Akshat also explicitly approved local Turbo testing. `ggml-large-v3-turbo.bin`, 1,624,555,275 bytes,
  SHA-256 `1fc70f774d38eb169993ac391eea357ef47c88757ef72ee5943879b7e8e2bc69` matches Hugging Face
  LFS metadata and Handy's catalog checksum; model ID `turbo`, same directory.

Download/hash verification does not prove accuracy. The dormant Hindi converter is described in
../voice-workspace-desktop/voice-workspace-features.md.

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

Opt-in PowerShell 7.2+ `scripts/benchmark-cleanup.ps1` verifies these inputs and runs only
built-in public dummy fixtures; `scripts/CLAUDE.md` describes its helper and performance.md its
results. If forcibly interrupted, inspect the exact experiment
executable/PID before stopping an orphan; never kill all dictation/LLM processes.
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

Seven top-level source checkouts; exact revisions/URLs/licenses in repositories.json and gitlinks.
No third-party dependency installation or nested/premium submodule initialization. Local push
URLs disabled and hooks disabled for these evidence checkouts. Source files are not merged.

The scripts use temporary, exact-path Git safe-directory options for this project and its seven
known reference paths, handling Windows sandbox/user ownership differences without trusting all
repositories or modifying global Git configuration. A full fresh-machine
restore has not been run; no third-party application feature is validated by those checks.

Project remote: `https://github.com/akshatksingh18/voice-workspace.git`, owned by Akshat and public.
Review every push as public content. Runtimes/weights/private-tests are ignored.
No runtime, model or private test file is tracked. This is source recovery, not a private-data backup.
Private audio/text data has no backup destination configured; personal-project is excluded from
the workspace OneDrive archive.

## Deliberately not configured

- Spoken self-correction is proposed; no rule engine, cleanup model or previous-insertion edit mode is enabled.
- No capture module selected yet for OpenWhispr/Meetily meeting runtime preparation.
- A small cleanup candidate/runtime is downloaded only for the isolated experiment; no Handy
  cleanup/summary model configured, persistent local/LAN service, Docker, cloud keys or account login.
- No calendar integrations, automatic meeting recording, external MCP, sync or biometric profiles.
- No integrated application, iPhone runtime, production signing or encrypted-at-rest implementation.
