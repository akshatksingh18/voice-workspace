# Voice Workspace

Akshat's local-first, self-hostable voice workspace: speak into any supported desktop text field,
edit text deliberately, keep personal notes, and record consented meetings without a meeting bot.
Handy is the accepted desktop foundation. This is an evaluation and product-definition repository,
**not an already integrated application**.

Source home: [Akshat's private voice-workspace repository](https://github.com/akshatksingh18/voice-workspace).

## Start here

This Windows machine has a separate Handy test runtime under ignored `runtime/handy/`, with a
multilingual Whisper Small model for English and Hindi/Hinglish. No cloud key is needed. Read
[setup.md](setup.md) for exact verification boundaries and [testing-guide.md](testing-guide.md)
for microphone selection and the first test. Runtimes/models are not included in GitHub.

Required product output: Hindi in natural **Roman Hinglish**, with English words unchanged.
Example: "Kal ki meeting teen baje rakho, chaar baje nahi." No Devanagari or English translation
in the delivered transcript. The current Handy runtime is an ASR-only baseline: it has no
configured Romanization stage and may still produce Devanagari. It is not ready for this output
requirement; adding and testing the local Roman-Hinglish delivery step is the next P0 task.

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
- [tasks.md](tasks.md): remaining decisions and implementation gates.
- [repositories.json](repositories.json): exact reference revisions and license qualifications.
- [CLAUDE.md](CLAUDE.md): canonical instructions for any coding agent.

## Local copies and recovery

`references/` contains nine real source checkouts: Handy, Akshat's Granola alternative,
OpenWhispr, Anarlog, Minutes, Open Granola, Omascribe, Meetily, and Steno. They are pinned Git
submodules, not merged dependencies. Their history and licenses stay separate. Push is disabled
in the local reference copies. Read the manifest before considering code reuse.

Clone this **private** repository while authenticated as Akshat, then run:

```powershell
.\scripts\restore-references.ps1
.\scripts\verify-workspace.ps1
```

Do not use `--recurse-submodules`: some upstream repositories refer to premium/private code that
is not needed or authorized. Recovery requires access to the two private source repositories;
public upstream pins also depend on upstream availability. A gitlink is not a permanent offline
mirror. Runtimes can be rebuilt/redownloaded using setup.md; GitHub does not back up private
recordings, note databases, or test profiles. No private-data backup destination is configured.

## Scope

Windows first; macOS/Linux and iPhone need independent implementation/device checks. Keep the
sibling Handy and Granola projects intact. Their product code has not been combined, and the
Granola repository's Natively license prohibits treating it as permissive commercial source.
Local ASR and a local language model are different capabilities. AI rewriting, meeting capture,
speaker identification, and note intelligence must earn separate acceptance tests.
