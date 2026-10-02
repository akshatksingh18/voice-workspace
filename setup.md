# Local setup and verification boundaries

**Status:** Updated Windows source build and isolated runtime/profile are deployed and headless
GPU/script checks pass. Initial live dictation failed speed/script/acronym acceptance. New live acceptance,
instant latency, broad Hindi accuracy and signed packaging remain unverified.

## Machine and prerequisite boundary

Read-only hardware verification on 2026-10-02: Intel Core i5-1135G7, 4 cores/8 threads, 7.8 GiB
reported system RAM; NVIDIA MX450 reports 2 GiB dedicated VRAM and Intel Iris Xe is also present.
The CPU Small baseline was measured and rejected for excessive delay; NVIDIA Vulkan is the
measured faster device. Turbo's warm sample was faster than Small. No concurrent LLM is configured.
Read performance.md for exact samples and caveats; hardware presence alone is not proof of speed.

Handy's existing Windows source-build prerequisites and build evidence remain owned by
`../handy/windows-local-setup.md`. No new compiler/toolchain/dependency install was needed here.
The test executable must come from the updated Handy 0.9.7 private fork, with its embedded
production frontend. Stock Handy lacks these delivery/warm-up changes. This is not a notes/meeting
integration build or signed public distribution.

## Isolated Handy test runtime

Location: `runtime/handy/handy.exe` with required sibling DLLs and resources copied from the
existing release directory. The `portable` marker contains `Handy Portable Mode`, activating
`runtime/handy/Data/` for settings/models/history/recordings/logs. The user's normal Handy
profile is not overwritten. Generated files are ignored; never stage them with force.

Prepared settings are described in testing-guide.md. The initial portable startup was verified;
Akshat subsequently recorded/inserted speech in Notepad, reporting the failed acceptance described
in performance.md. Local headless CPU/GPU inference used saved audio without a microphone/paste.
Onboarding completion is not proof of language or delivery acceptance. The user-selected microphone,
shortcut and existing history must be preserved when tuning the profile.

Original runtime benchmark provenance SHA-256:
`5b97789e07688cf713d7d0914053dbbd40a220e747ded22f2ad3a0f53c2ece32`.
Updated runtime SHA-256: `165f7e253283d100d2ffa1f6a147fbc5b221e5944a9df944e9815182c8cb8d8b`.
The release build used Tauri's embedded production asset protocol and passed headless native
device/inference/conversion checks. It is locally built and unsigned; do not bypass a Windows
application-control block. Rollback copies are ignored `runtime/handy/handy-before-hinglish.exe`
and `runtime/handy/Data/settings-before-hinglish.json`; no existing recordings were removed.
The updated GUI is running idle after confirmed NVIDIA/Turbo load and synthetic priming; persisted
Roman/preload/unload/device/privacy settings match the intended profile. No new microphone
recording was started by this verification. The timing-only CLI test omits transcript text.

## Downloaded multilingual models

Authorized source: [ggerganov/whisper.cpp on Hugging Face](https://huggingface.co/ggerganov/whisper.cpp).
File: `ggml-small.bin`, 487,601,967 bytes. SHA-256 checked against Hugging Face LFS metadata:
`1be3a9b2063867b937e64e2ec7483364a79917e157fa98c5d94b5c1fffea987b`.
Stored at `runtime/handy/Data/models/ggml-small.bin`; Handy model ID `small`, retained for comparison.
This is multilingual, not the `.en` variant. Download/hash verification does not prove accuracy.
Model/packaging redistribution license review remains separate from permission to download/test.

Akshat also explicitly approved local Turbo testing. `ggml-large-v3-turbo.bin`, 1,624,555,275 bytes,
SHA-256 `1fc70f774d38eb169993ac391eea357ef47c88757ef72ee5943879b7e8e2bc69` matches Hugging Face
LFS metadata and Handy's catalog checksum. Stored in the same local models directory, model ID
`turbo`. The activated tuned profile selects Turbo/NVIDIA, Roman Hinglish on, startup preload/
synthetic priming on, model unload Never, translation/cleanup off, INFO timing logs and debug off.
No text model or cloud service is needed for conversion. The runtime bound to NVIDIA Vulkan0
and the live profile retained its user-selected microphone, shortcut and history; custom words
remain empty for comparable ASR testing. `scripts/local-models.json` owns shared model checks.

The authored converter passes synthetic tests and fails closed on unsupported script symbols.
It does not repair acoustic recognition errors, and unfamiliar-word spelling can be imperfect.
Updated spoken fixtures and release-to-paste measurements remain required; Latin-only output is
not automatically correct output. See ../handy/voice-workspace-features.md for implementation.

On another machine, rebuild/copy the updated private Handy fork's release executable, its top-level runtime DLLs and
resources. For a **fresh, empty** runtime only, copy `scripts/portable` beside the executable
and `scripts/handy-baseline.json` to `runtime/handy/Data/settings_store.json`. Refuse to overwrite
an existing profile. Download the same model from the authorized Hugging Face destination and
verify size/hash for the selected model, then run the verifier/launcher. The template uses Auto
GPU selection because hardware identities differ; this laptop's live profile must explicitly select
the measured NVIDIA device. The launcher checks for fork CLI features and rejects stock builds.
These generated inputs are deliberately not
in GitHub. Do not copy an existing user's settings/history into the repository.

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

Project remote: `https://github.com/akshatksingh18/voice-workspace.git`, owned by Akshat and verified
private. Visibility must remain private. Runtimes/weights/private-tests are ignored.
The initial source/docs/gitlink push was verified against GitHub's main commit. No runtime,
model or private test file is tracked. This is source recovery, not a private-data backup.
Private audio/text data has no backup destination configured; personal-project is excluded from
the workspace OneDrive archive. Source recovery is not private-data recovery.

## Required manual checks / things deliberately not configured

- Retest the updated build with the selected physical microphone after startup preparation finishes.
- Verify English/Hinglish meaning and script, release-to-paste timing, cancellation, focus and clipboard behavior.
- OpenWhispr/Meetily meeting runtime preparation after baseline; no capture module selected yet.
- No local cleanup/summary LLM installed, no LAN service/Docker, no cloud API keys or account login.
- No calendar integrations, automatic meeting recording, external MCP, sync or biometric profiles.
- No integrated application, iPhone runtime, production signing or encrypted-at-rest implementation.
