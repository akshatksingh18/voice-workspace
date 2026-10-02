# Product framework and acceptance requirements

**Status:** Accepted direction: one local-first/self-hostable voice workspace, using Handy as
the desktop base. Feature priorities and numerical gates below are proposed engineering criteria,
not implemented behavior or a claim of complete Wispr parity. Source verification: 2026-10-02;
see the research document's official links and source caveats before refreshing product claims.

## What Akshat has asked for

- A self-hosted Wispr Flow alternative, not just a microphone-to-text demo.
- Reliable desktop dictation, personal notes, meeting notes, and learning from corrected words.
- Spoken self-correction: "Let's meet at 7 pm. Sorry, let's meet at 6 pm." should deliver only
  "Let's meet at 6 pm." This is distinct from learning a preferred spelling from later typed edits.
- English only: prioritize speed and accuracy. Hindi/Hinglish is explicitly removed from active scope
  after the live test failed; the previous Roman-Hinglish requirement is superseded.
- Correct technical names and natural punctuation without losing the accepted fast delivery;
  the live E03 result missed PostgreSQL and punctuation, so speed alone is not acceptance.
- Use Handy as the production desktop foundation; evaluate the best ideas from multiple projects.
- Bring the existing Granola alternative into the analysis without losing its separate context.
- Keep source copies, research, requirements, setup, and agent instructions in this new project.
- Text/Markdown documentation, no Canvas; private GitHub source recovery.
- Offline model preparation is authorized from Hugging Face. Recordings/uploads are not authorized.

Manual meeting start and no live coaching remain standing boundaries from the existing note-taker
plan. iPhone is a longer-term need, not part of this Windows-ready first milestone. There is no
authorization to enable calendar accounts, public sharing, paid services, or third-party data sync.

## Wispr capabilities and our corresponding work

Official feature availability differs by platform, mode, account and release. A matching label
is not proof of matching behavior. Scratchpad notes and meeting Notetaker are distinct products
inside the Wispr experience; dictation language coverage is not meeting-language coverage.

### D1 — Dictate into desktop apps (P0)

Wispr: system-wide dictation with a shortcut and polished insertion. Handy already supplies local
ASR, global shortcuts, selectable microphones, tray/overlay and several paste modes. Physical
Notepad capture/insertion worked in Akshat's initial test, but speed/script/acronym acceptance
failed; updated focus/paste behavior still needs testing. Our gate: 20 repeated short inserts in
Notepad and browser textareas, no lost/doubled text, no unintended submission, and recoverable
transcript on failure. Test terminal-like editors separately, never execute dictated commands.

### D2 — Fast, accurate English (P0)

Use an English-capable local ASR model and explicit English language. Translation, Roman conversion
and prose cleanup are off. Preserve names, technical identifiers, numbers, dates, negation and word
order. Compare streaming finalization and batch recognition on this laptop, not catalog speed scores.
Streaming can move computation into speaking time; it can also increase work or reduce accuracy.
Choose from measured results, with no automatic cloud fallback or silent model change.

Akshat accepts the earlier Parakeet streaming profile's live speed, but its live E03 technical/
punctuation test failed. The same saved clip retained technical terms with a final period using
Parakeet batch in 0.378–0.439 s of recognition; natural list commas were still absent. This one-clip
result motivates opt-in full-recording mode and a narrow manual vocabulary, not an all-model
accuracy claim. Live quality-profile latency/accuracy must be retested; longer clips may slow down.
This qualitative result is not a measured numeric/p95 pass. Proposed warm target: release-to-paste
below one second for short dictations, with cold preparation,
p50/p95, speech duration and resource use reported separately. Measure E01–E12 with Akshat's accent,
both quiet and ordinary room conditions; all meaning-critical tokens must survive. Synthetic TTS
and published WER are screening evidence, not proof of maximum accuracy for his voice.

Hindi/Hinglish is deferred, not an active readiness gate. The old converter and fixtures remain
recoverable. The user reported unwanted English translation from Hindi despite translation being
off; script-only tests did not solve acoustic/meaning accuracy. Do not re-enable it without a new decision.

### D3 — Clean speech without changing intent (P0 punctuation; P1 polish/repair)

Wispr: filler removal, punctuation and cleanup levels; some style features are English-limited.
Handy has filler handling and optional post-processing, but not verified complete contextual
rewrite parity. Add Raw/Light/Structured modes, with raw text always recoverable. Cleanup must
not answer a question in dictated text, add facts, reverse a negation without an explicit spoken
repair, or translate unasked. Changing a number/date/name without a clear spoken correction is a
failure even if prose sounds better. Raw mode and cleanup-timeout
fallback both retain English source meaning. Raw mode skips prose rewriting; original ASR remains
recoverable explicitly. The dormant Hindi converter is not part of this active pipeline. Every rewrite should be undoable;
no silent cloud fallback.

OpenWhispr's pinned source separates ASR/dictionary from optional cleanup, with prompt rules for
punctuation, jargon and explicit backtracking. Reuse that architecture with provenance, not its
cloud sync or an unvalidated prompt as a correctness guarantee. Full-recording ASR and the manual
dictionary do not solve natural list punctuation/contextual grammar. A separate small local text
model/runtime comparison requires download authority, latency/meaning tests and safe fallback
before adoption; none is configured or enabled. The first slice must not hardcode the test sentence.

Spoken self-correction is a requested behavior, not currently implemented. Proposed first slice:
while the user holds the recording shortcut, keep ASR text provisional, recognize explicit
backtracking and replace only the clearly superseded clause before the one final paste. Full
restatements ("7 pm. Sorry, let's meet at 6 pm") are the first narrow case; elliptical repairs
("7 pm—sorry, 6 pm") and chained corrections need separate tests. Only the explicitly corrected
time/name/number/negation may change; retain unrelated clauses and the original ASR for recovery.

Use a small, local deterministic matcher first, bounded to the current recording and nearby
clause. A cue such as "sorry", "I mean" or "actually" is not sufficient by itself: literal apologies,
quoted speech, unrelated later sentences and uncertain references must not silently delete text.
Raw mode preserves the unrewritten ASR. Ambiguity retains it or presents a draft; no guessed repair.
Benchmark added output time and the full release-to-paste distribution against the speed-accepted
profile. No default LLM load, cloud call, or slower whole-paragraph rewrite is authorized here.
More flexible local-model repair remains a separately measured later option, not a promised result.

The external editor still receives one final insertion on release. Provisional corrections in the
overlay are not permission to continuously rewrite arbitrary text in another application.
Corrections after release/paste are the separate D6 editing boundary, not this first slice.

### D4 — Vocabulary and correction learning (P1)

Wispr: dictionary words, replacement rules and learning from edits. Handy's custom vocabulary
is useful but is not a demonstrated system that learns edits in every other app. Start with
manual words/replacements, then opt-in learning from the just-inserted span. Store candidate,
evidence, context, confidence and approval, not a log of all typing. Require preview/accept,
disable/remove/undo and scoped exceptions. Learning a spelling preference is not retraining an
ASR model. Screen capture, passwords, unrelated typing, and cross-app browsing are excluded.

### D5 — App-specific style (P1)

Wispr: formatting/tone can adapt to app categories. Proposed profiles: plain, chat, email,
document, and code-safe. Initially user chooses the profile; app detection is later, allowlisted
and visible. Code-safe preserves identifiers, paths, symbols, URLs and whitespace. Tone changes
must not rewrite facts or insert an email greeting/signature without an explicit profile rule.
Other-language style support is outside the accepted English-only scope.

### D6 — Selected-text voice editing (P1)

Wispr supports deliberate transforms of selected text. Handy's transcription post-processing
is not equivalent. Proposed command mode has a separate shortcut, captures the selection and
target, previews a diff, and revalidates both before replacing. If focus/text changes, show a
draft instead of overwriting. "Make this shorter" must not replace a whole page when no selection
exists. Undo returns the exact previous text. Ordinary dictation never invokes tools/actions.

A later "correct last dictation" mode may use the last insertion receipt and exact original span,
not a global typing history. Require explicit activation and revalidate app, field/selection and
unchanged text before replacing; unsupported editors or an intervening user edit get a preview/
copyable draft instead. Never send a guessed number of Backspace keys. Correcting after paste
needs this independent implementation/test gate; a same-recording repair does not establish it.

### D7 — Snippets and spoken formatting (P1)

Wispr: reusable text snippets and voice formatting affordances. Add opt-in phrase-to-snippet
rules with collision previews, scoped activation, literal-text escape and multiline insertion.
Treat body text as data, not executable instructions. Test "new line", lists, punctuation and
literal code phrases separately. No arbitrary shell/script execution from a spoken snippet.

### N1 — Personal notes / scratchpad (P0 after dictation gate)

Wispr: quick notes separate from meeting transcripts. Build a local notes inbox with typed or
dictated notes, autosave, timestamps, titles/tags, keyword search, Markdown export and raw text
recovery. Dictate-to-note is explicit: recording a meeting must never paste into the foreground
chat box. User-authored notes, transcript and AI-derived content remain distinguishable.

### M1 — Bot-free meeting capture (P0 after capture spike)

Wispr Notetaker and Granola-style apps capture locally and make notes without a meeting bot.
Handy alone is not a meeting recorder. Evaluate OpenWhispr/Meetily Windows capture behavior,
and Anarlog's note/capture design before choosing a module. Explicit Start/Pause/Resume/Stop,
visible recording state, duration, source meters, headphones-first setup, and consent guidance
are required. Keep microphone and system audio separate; two channels do not identify every
remote speaker. No silent recording on calendar join, app detection, reboot, or hotkey collision.

### M2 — Transcripts and speaker labels (P1)

Live text may be provisional; the final pass can refine timings/text/speaker clustering. Give
segments stable IDs and source provenance. Unknown speakers remain unknown; human name edits
and locks survive reprocessing. Preserve overlap and avoid duplicating system audio heard by
the microphone. Evaluate diarization models on real fixtures before promising accuracy.
Cross-session voice profiles are opt-in, sensitive biometric-like data; deferred by default.

### N2 — Grounded summaries and note questions (P1)

Wispr Notetaker: summaries, follow-ups, grounded questions and note-oriented integrations.
Generate summary/decisions/action items from transcript plus authored notes; retain citations
to segment IDs. Unstated owner/date is null/unknown, not guessed. Provide templates and a
regenerate preview without erasing user notes. Question answering cites sources or says there
is insufficient evidence. Transcript instructions such as "send this file" cannot invoke tools.

### N3 — Search, export, integrations (P1/P2)

Local keyword search and Markdown/plain text export first. Semantic search only after measured
need, with index deletion and privacy gates. Calendar context, MCP, outbound actions and sharing
are later, independently approved features. Wispr's meeting MCP access is not a reason to expose
all private dictation. Default to no network listener; explicit local read-only access needs
authentication, allowed datasets, source citations, and user-approved destinations.

### P1 — Self-hosting and device coverage (P0 desktop; P2 mobile/server)

No paid account required for local dictation. ASR and cleanup/summarization must be independently
selectable: on-device now, authenticated self-hosted LAN later. OpenAI-compatible text endpoints
do not automatically implement streaming ASR protocols. Offline means no audio/text sent; model
downloads and optional update checks must be explicit. Windows runtime evidence does not prove
Mac/Linux/iPhone behavior. iOS needs a separate app/keyboard/share workflow and a device spike;
secure text fields and keyboard-extension microphone limits must be respected.

## Small details that determine whether this feels trustworthy

### Recording and devices

- Visible idle/recording/transcribing/pasting/error states; accessible text, not color alone.
- One predictable hold/toggle mode; Escape always cancels without paste. Held modifiers must
  not turn an injected paste into a different shortcut. Hotkey conflicts must be visible.
- No empty, repeated or hallucinated text from silence. No truncation at start/end of speech.
- Device names/channel selector; unplug/reconnect, Bluetooth profile changes, default-device
  changes and sleep/resume handled explicitly. No hidden switch to a different microphone.
- Do not mute meeting playback when dictating. Give clear insufficient-memory/model-load errors.
- Battery/CPU-aware model unload and cancel; long summaries must not starve short dictation.

### Insertion and recovery

- Capture/revalidate target and selection; refuse stale targets after switching windows.
- Preserve user's clipboard including supported non-text formats; don't restore over a newer
  user copy. Safe fallback with Copy button/history, not blind repeated paste.
- Respect UAC/elevated app boundaries; never demand running the voice app as administrator.
- No auto-Enter/send/submit. Preserve Unicode, emojis, trailing space, newlines and list structure.
- One recording, one result; retry inference/insertion without secretly recording again.
- Test rich text, browsers, terminals and IMEs separately. Unknown/secure fields fail closed.
- Plain-English error + recoverable raw transcript; logs redact dictated/selected/private text.

### Learning and language

- Don't learn temporary edits, grammatical rewrites, sarcasm, pasted external text, or a
  correction belonging to another person's quoted speech as a permanent spelling rule.
- Unicode-normalized matching with word boundaries, case preservation and scoped replacements;
  no replacing a short name inside a longer word. Preserve Unicode in imported/recoverable text.
- Active dictation is English only; do not translate, infer missing words or activate another language.
- Show which rule changed a word; support per-app/session disable and reset with confirmation.
- Include numbers, currencies, negation, dates, abbreviations and uncommon names in regression tests.

### Notes, meetings and privacy

- Pause indicator and separate mic/system mute; explicitly disclose gaps and failed chunks.
- Crash recovery, incremental persistence, duplicate suppression, resuming after sleep, disk-full
  handling and durable Stop/finalize must be tested before confidential long meetings.
- Keep source transcript immutable/versioned; preserve human notes through regeneration.
- Summary must distinguish proposal from decision and a conditional task from a commitment.
- Search highlights/citations, rename/export/import, deletion across raw audio, text, WAL/indexes
  and optional profiles. Retention semantics must be intelligible; "Never" must not be mistaken
  for "never save" (Handy currently uses it to mean never delete).
- No claim of encrypted-at-rest/secure erase without implementation and tests. SSD/backups can
  retain copies; deleting an entry is not proof of physical erasure.
- Data backup needs a separately approved destination; source GitHub is not a recordings backup.

## Order and decisions

Retain the speed-accepted English model; retest the full-recording/vocabulary quality slice after
the failed live E03 test. Next measure a separate punctuation/cleanup path with explicit authority;
same-recording spoken self-correction remains proposed, preserving speed and raw recovery,
not an implemented or enabled feature. Then build notes + manual meeting
capture. Add explicit editing/cleanup, correction learning and grounded summaries in small tested
slices. Defer mobile, calendar automation, biometric identity, connectors and cloud sync.

Decided: English only; Hindi/Hinglish development and its old acceptance gate are deferred.
Open decisions: preferred hold vs toggle after testing;
allowed data retention; minimal note editor needs; first meeting app/headset; which local text
model fits this 8 GB machine; quantitative latency coverage and whether corrections must also work
across separate recordings/after paste. None justifies silently enabling a service.
