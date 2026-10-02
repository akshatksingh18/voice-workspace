# Local setup and verification boundaries

**Status:** Isolated Handy baseline, reference collection and 20-second startup check passed.
Physical microphone, ASR output, hotkey and paste tests remain unverified.

## Machine and prerequisite boundary

Read-only hardware verification on 2026-10-02: Intel Core i5-1135G7, 4 cores/8 threads, 7.8 GiB
reported system RAM; NVIDIA MX450 reports 2 GiB dedicated VRAM and Intel Iris Xe is also present.
Start with CPU ASR, no concurrent LLM. Hardware presence is not proof of inference speed.

Handy's existing Windows source-build prerequisites and build evidence remain owned by
`../handy/windows-local-setup.md`. No new compiler/toolchain/dependency install was needed here.
The copied release binary is Handy 0.9.7 from that verified local source build; this is not a
new integrated Voice Workspace build or signed public distribution.

## Isolated Handy test runtime

Location: `runtime/handy/handy.exe` with required sibling DLLs and resources copied from the
existing release directory. The `portable` marker contains `Handy Portable Mode`, activating
`runtime/handy/Data/` for settings/models/history/recordings/logs. The user's normal Handy
profile is not overwritten. Generated files are ignored; never stage them with force.

Prepared settings are described in testing-guide.md. Partial settings use Handy's own schema
defaults. The process stayed alive for 20 seconds, reported this portable Data/Hugging Face path,
created local history/WebView state, and serialized the selected model/language/hotkey/CPU
settings correctly. Only that owned test process was closed; no recording or inference was run.
Onboarding completion in this disposable profile means a model has been provisioned, not that
any physical microphone or paste test passed. Select your microphone in the GUI.

Executable SHA-256: `5b97789e07688cf713d7d0914053dbbd40a220e747ded22f2ad3a0f53c2ece32`.
Locally built unsigned application; do not bypass a Windows application-control block.

## Multilingual model

Authorized source: [ggerganov/whisper.cpp on Hugging Face](https://huggingface.co/ggerganov/whisper.cpp).
File: `ggml-small.bin`, 487,601,967 bytes. SHA-256 checked against Hugging Face LFS metadata:
`1be3a9b2063867b937e64e2ec7483364a79917e157fa98c5d94b5c1fffea987b`.
Stored at `runtime/handy/Data/models/ggml-small.bin`; selected Handy model ID is `small`.
This is multilingual, not the `.en` variant. Download/hash verification does not prove accuracy.
Model/packaging redistribution license review remains separate from permission to download/test.

On another machine, rebuild/copy Handy's release executable, its top-level runtime DLLs and
resources. For a **fresh, empty** runtime only, copy `scripts/portable` beside the executable
and `scripts/handy-baseline.json` to `runtime/handy/Data/settings_store.json`. Refuse to overwrite
an existing profile. Download the same model from the authorized Hugging Face destination and
verify size/hash, then run the verifier/launcher. These generated inputs are deliberately not
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
source pin/remote/license-file checks and runtime/model hashing passed. A full fresh-machine
restore has not been run; no third-party application feature is validated by those checks.

Project remote: `https://github.com/akshatksingh18/voice-workspace.git`, owned by Akshat and verified
private. Visibility must remain private. Runtimes/weights/private-tests are ignored.
Private audio/text data has no backup destination configured; personal-project is excluded from
the workspace OneDrive archive. Source recovery is not private-data recovery.

## Required manual checks / things deliberately not configured

- Choose and permit microphone, press shortcut and verify actual English/Hindi/Hinglish output.
- Verify insertion/cancellation/clipboard behavior in real supported apps and preferred script.
- OpenWhispr/Meetily meeting runtime preparation after baseline; no capture module selected yet.
- No local cleanup/summary LLM installed, no LAN service/Docker, no cloud API keys or account login.
- No calendar integrations, automatic meeting recording, external MCP, sync or biometric profiles.
- No integrated application, iPhone runtime, production signing or encrypted-at-rest implementation.
