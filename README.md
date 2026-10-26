# Voice Workspace

Akshat's local-first, self-hostable voice workspace: speak into any supported desktop text field,
edit text deliberately, keep personal notes, and record consented meetings without a meeting bot.
Handy is the accepted desktop foundation. This owns evaluation, product definition and experimental
dictation improvements maintained in the public Handy fork,
**not an already integrated application**.

Source home: [Akshat's public voice-workspace repository](https://github.com/akshatksingh18/voice-workspace).

## Start here

This Windows machine has a separate Handy test runtime under ignored `runtime/handy/`, with an
English-first local model profile. No cloud key is needed. Read
[setup.md](setup.md) for exact verification boundaries and [testing-guide.md](testing-guide.md)
for microphone selection and the first test. Runtimes/models are not included in GitHub.

Active scope is **English only**, superseding the earlier Hindi/Hinglish requirement. The updated
Turbo live test improved speed but still took 3–4 seconds and produced unwanted English from Hindi.
Hindi work is deferred; the experimental converter is off and existing data is preserved.
The English test candidate is Parakeet Unified EN Q8 on NVIDIA, with startup warm-up and no AI
cleanup or translation. Akshat accepts the earlier streaming profile's live English speed, but
its initial live E03 test missed PostgreSQL and punctuation. The full-recording/narrow-dictionary
profile is deployed; Akshat reports technical words and punctuation worked perfectly on retest,
without AI cleanup. Broader accuracy/insertion/reliability and quantitative latency remain open.
Contextual cleanup/spoken repair are separate experiments, not enabled features. See [performance.md](performance.md) for
comparisons and verification boundaries. Recognition-only timings are not an insertion guarantee.
Spoken self-correction is requested but not built; its proposed behavior and tests are in
[product-framework.md](product-framework.md) and [test-cases.md](test-cases.md).

From PowerShell:

```powershell
Set-Location 'D:\AI Important Files\personal-project\voice-workspace'
.\scripts\verify-workspace.ps1 -CheckRuntime -HashModel
.\scripts\start-test.ps1
```

Close other dictation apps first. The launcher opens Handy; it does not start recording.
Focus Notepad, hold Ctrl+Shift+F12, speak, then release. Escape cancels. If the shortcut cannot be
registered, choose an unused shortcut in Handy and update your test notes. Never test in a real
terminal command line, password field, chat send box, or confidential meeting first.

## Project documents

- [product-framework.md](product-framework.md): Wispr capability comparison, explicit needs,
  proposed acceptance criteria, and small reliability details.
- [architecture.md](architecture.md): ownership, proposed integration, privacy and license gates.
- [voice-workspace-research.md](voice-workspace-research.md): detailed source-backed research.
- [testing-guide.md](testing-guide.md) and [test-cases.md](test-cases.md): settings and synthetic tests.
- [setup.md](setup.md): actual local readiness, not advertised capabilities.
- [performance.md](performance.md): measured latency, user speed acceptance and remaining accuracy/reliability gates.
- [tasks.md](tasks.md): remaining decisions and implementation gates.
- [repositories.json](repositories.json): exact reference revisions and license qualifications.
- [CLAUDE.md](CLAUDE.md): canonical instructions for any coding agent.

## Local copies and recovery

`references/` contains nine real source checkouts: Handy, Akshat's Granola alternative,
OpenWhispr, Anarlog, Minutes, Open Granola, Omascribe, Meetily, and Steno. They are pinned Git
submodules, not merged dependencies. Their history and licenses stay separate. Push is disabled
in the local reference copies. Read the manifest before considering code reuse.

Clone this repository, then run:

```powershell
.\scripts\restore-references.ps1
.\scripts\verify-workspace.ps1
```

Do not use `--recurse-submodules`: some upstream repositories refer to premium/private code that
is not needed or authorized. Recovery uses Akshat's public Handy and Granola-alternative
repositories; public upstream pins also depend on upstream availability. A gitlink is not a permanent offline
mirror. Runtimes can be rebuilt/redownloaded using setup.md; GitHub does not back up private
recordings, note databases, or test profiles. No private-data backup destination is configured.

## Scope

Windows first; macOS/Linux and iPhone need independent implementation/device checks. Keep the
sibling Handy and Granola projects intact. Their product code has not been combined, and the
Granola repository's Natively license prohibits treating it as permissive commercial source.
Local ASR and a local language model are different capabilities. AI rewriting, meeting capture,
speaker identification, and note intelligence must earn separate acceptance tests.
