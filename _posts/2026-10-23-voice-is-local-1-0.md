---
title: "Voice is Local 1.0"
date: 2026-10-23 18:52:00 -0400
description: "A free, open-source Mac app for dictation, meeting transcripts and reading articles aloud. Your voice stays on your Mac."
image: /assets/og/2026-10-23-voice-is-local-1-0.png
thumbnail: /assets/images/2026-10-23-voice-is-local-icon.png
project:
  id: voiceislocal
  name: Voice is Local
  status: installable
  status_label: "1.0 / signed download"
  language: Swift
  short: "On-device dictation, meeting transcripts and read-aloud for the Mac."
  description: >-
    A menu bar app that types what you say into the app you're using, records and
    transcribes meetings with speaker labels and summaries, and turns articles
    into audio files. Speech, transcripts and summaries stay on the Mac.
  repository: "https://github.com/orlenko/holos"
  install: "Download the signed DMG from https://voiceislocal.com/"
  workflow:
    label: "Dictate / record / read"
    steps:
      - "Hold Right Option and talk; the text goes where you're typing"
      - "Record a call; both sides, labelled by speaker"
      - "Get a summary and action items, made on the Mac"
      - "Turn an article into an .m4a for your phone"
---

![The Voice is Local icon: an open book with three bars on the left page and three lines on the right, in red, yellow and teal.]({{ '/assets/images/2026-10-23-voice-is-local-icon.png' | relative_url }})

A month ago I wrote about [Voice is Local]({{ '/2026/09/25/look-ma-no-ums.html' | relative_url }}), a dictation app I built because I didn't want my voice going to someone else's server. Back then you had to clone the repository and build it yourself, and it did one thing: you hold a key, talk, and the words show up wherever you're typing.

It's now 1.0. You can download it from [voiceislocal.com](https://voiceislocal.com/) as a signed, notarized app, it's still free and open source, and it does three things instead of one: dictation, meetings, and reading aloud. What it hears, transcribes, summarizes and reads stays on the Mac.

## Why local

The good dictation and meeting tools mostly work by sending your audio to a server. That's how they got good, and it's the part I never liked. Once the recording leaves my machine, I don't know who keeps it, for how long, or what gets trained on it. Apple now ships on-device speech recognition, so I built on that instead, and added open models that also run on the Mac for the rest: speaker labels, a second-pass Whisper transcript, and natural voices. The result is good enough that I cancelled my cloud dictation and meeting subscriptions, and stopped using [aitts](https://github.com/orlenko/aitts), which relies on the OpenAI API and costs a little bit of money and not a little bit of privacy.

There's no account, no subscription and no telemetry. The app uses the network for two things: downloading the models you set up or ask for, and loading a web page you paste into Reading (the page loads as it would in a browser, without keeping cookies). It ships with no models at all; each one downloads the first time you need it, from Apple or from Hugging Face. The website has no analytics either.

## Dictation

Hold Right Option, talk, let go. The text goes into whatever field has focus, with a live preview while you talk if you want one. That part hasn't changed since the first post. Around it:

- Fix a misheard word once and it learns the correction. A word list helps with names and jargon.
- An optional Apple Intelligence pass uses Apple's on-device model to fix misheard words and missing punctuation before the text goes in. It keeps only small, word-for-word fixes and adds about half a second.
- Spoken paths and commands come out as code, on by default: say "dot slash scripts slash build dot S H" and it types `./scripts/build.sh`. That also uses the on-device model when Apple Intelligence is on, and a simpler rule-based conversion when it isn't.
- History keeps your dictations on the Mac, 30 days by default. Run Again recognizes an old recording with today's settings, which is how you find out whether the new word list did anything.
- It leaves your clipboard alone unless you click Copy.

## Meetings

This is the part that grew the most. Voice is Local records your microphone and everything the Mac plays, so both sides of a call end up in one recording. Nothing joins the call, and there's no bot in the participant list announcing that it's taking notes.

You get a live transcript while it records. After you stop, it labels the speakers. You name them, and by default it also learns the voices of the people you name and suggests those names in later meetings. There's a checkbox per meeting, or you can turn it off in People. It also drops the words the microphone picked up from the Mac's speakers, so the other side isn't transcribed twice when you take calls without headphones.

A meeting can mix up to three languages, French and English in the same call, say. When it's over, Apple Intelligence writes a title, a summary, key points and action items, on the Mac. You can export the result as Markdown, plain text or JSON.

There are two optional extras. Deep transcription runs Whisper large-v3 turbo locally over an English meeting after it ends. On one real 53-minute call, it cut the word error rate from 20.9% to 14.6% as shipped, measured against a cloud transcript. That's one call, not a benchmark. It takes about 8 to 11 minutes per hour of audio on an M4 Pro. The other extra is screen capture, off by default, which saves snapshots of the displays when they change (everything on screen, notifications included) and reads their text with on-device OCR after the meeting. They stay on the Mac.

## Reading

The third thing goes the other way. Paste a link to an article, or give it a PDF, Word, HTML, Markdown, RTF, OpenDocument or plain text file, and Voice is Local turns it into a single .m4a audio file with chapters at the headings. AirDrop it to your phone and listen somewhere other than your desk.

It reads with Apple's voices, or with optional natural voices: Kyutai's Pocket TTS, running locally, in English and French. Those packs are big, about 530 MB for English and 1.9 GB for French, which is why they're optional.

## What it needs, and what it won't do

It needs macOS 27 or later on Apple Silicon. There's no Intel version, no older macOS, and no iPhone or Windows app. Summaries and the word-fix pass need Apple Intelligence turned on.

Dictation and meetings work in the languages Apple's on-device transcriber supports. The ones I've actually used are English and French. Deep transcription is English only. Ukrainian isn't there yet because Apple's on-device speech doesn't do Ukrainian; the repository is still called holos, Ukrainian for "voice", as a reminder.

A few more honest limits:

- Typing into other apps depends on each app's text fields, so dictation won't insert everywhere.
- Speaker counts are approximate. Quiet or brief speakers can get merged into someone else.
- Reading can't open pages behind a sign-in or a paywall, and it won't read scanned PDFs that have no text layer.
- There's no auto-update yet. New versions come from the site.
- It's a 1.0 from one person. Some hardware and permission flows are still on the [list of things to check by hand](https://github.com/orlenko/holos/blob/main/docs/manual-testing.md).

## Getting it

Download it from [voiceislocal.com](https://voiceislocal.com/), which also has the SHA-256, an FAQ, and a [privacy page](https://voiceislocal.com/privacy/) on exactly what stays where. The app is signed with a Developer ID and notarized, which means Apple checked it for malware. It isn't in the App Store, and Apple hasn't endorsed it.

Version 1.0.1 is coming soon. It removes a developer-only command I used to compare accuracy against OpenAI's transcription. The current download, 1.0.0, still includes it in the bundled command-line tool. The app never calls it, and it uploads nothing without your own OpenAI API key and an explicit yes. In 1.0.1 the release build doesn't contain it at all, and the build checks that OpenAI's address isn't in there.

The source is on [GitHub](https://github.com/orlenko/holos) under GPLv3 or later. If you build and share your own copy, give it a different name and icon; those belong to Bjola Software Inc.

It's free. If it saves you a subscription, you can [buy me a coffee](https://buy.stripe.com/cNidR96bi2K07NKgSogEg04).
