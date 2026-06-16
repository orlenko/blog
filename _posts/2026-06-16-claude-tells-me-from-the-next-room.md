---
title: "Claude Finishes Its Work and Tells Me About It From the Next Room"
date: 2026-06-16 18:00:00 -0400
description: "How I get Claude to announce, out loud, what each parallel session just did."
---

![Halftone illustration of a head shouting, three speech bursts coming from the mouth, blue on black]({{ site.baseurl }}/assets/images/aisay.jpg)

There's a small ritual to my workday now. I kick off two or three Claude sessions on different tasks, walk to the kitchen to make coffee, and somewhere between the grind and the pour, the laptop calls out from the other room: "Migration script is done. Schema looks clean." Then, a minute later, from a different session: "Found the regression. It's in the cache key, not the query." I bring my coffee back and pick up the threads in whatever order the spoken summaries came in.

This is a much better workflow than I had any right to expect from `say`, a stop hook, and one paragraph in my global Claude instructions.

## The setup

Three pieces.

**1. A machine-wide Claude instruction.** I added a small section to my global CLAUDE.md telling Claude to include a single line in every reply, prefixed with a speaker emoji:

> Include exactly one `🗣 <one short sentence>` line in your reply when you want audio. One sentence, conversational, summarizing the gist — not the full reply.

It also explains when to *skip* the audio (sub-agents, scripted runs, anywhere a human isn't sitting at the keyboard) and what to leave out of the spoken line (long paths, command output, code dumps — they stay in the text).

**2. A stop hook.** Claude Code's stop hooks fire when a turn ends. Mine grabs the last assistant message from the transcript, finds the `🗣` line, strips the emoji, and pipes the sentence to macOS `say`. No tool call, no MCP, no permissions prompt. The hook does all the work; Claude just has to remember to write the line.

**3. (Optional) a nicer voice.** macOS's built-in voices are functional but not exactly pleasant for hours at a time. If you want something easier on the ears, [aitts](https://github.com/orlenko/aitts) is what I use — a small tool I wrote that's a friendlier `say`, cheap and easier on the ears. If you're happy with `Evan (Enhanced)` or `Daniel`, skip this step.

## Muting

The audio is great when I'm at home alone with the door closed. It's less great when my partner is on a call in the next room or when I'm pairing over video. So I wrote a tiny `voice` script that toggles the hook on and off.

```bash
voice mute     # silence the voice; still pops macOS notifications
voice unmute   # restore audio
voice toggle   # flip
voice          # show current state
```

It works by touching a file at `~/.claude/voice.muted`. The stop hook checks for that file before calling `say`, and if it finds it, pops a macOS notification with the same one-line summary instead. The chyron is still there; it just goes to the notification center instead of out the speakers.

This is a small thing, but the difference between "I get audio when it makes sense and not when it doesn't" and "I get audio always or never" turned out to matter more than I expected.

## Why it's worth setting up

The first time I had three sessions running in parallel and was wondering which would finish first, I expected the audio cues to mostly tell me when things were *done*. What I didn't expect was how much they tell me about *what was done*, in a single glance-free sentence.

There's a real difference between "ding" and "Receipt parser is wired up; tests pass." The first one just calls me back to the laptop. The second one resumes the conversation in my head before I've even sat down. By the time I'm at the keyboard, I already know which session to look at first.

It's also, quietly, motivating. There's something about hearing a calm voice tell you the migration worked, in a workday that otherwise has very few audible victories.

## A few small lessons

A couple of things I learned the boring way.

* Tell Claude to include the spoken line in *every* reply, not just the last one of a long task. Half-completed work is exactly the case you most want a verbal status update for.
* Keep it to one sentence. Two is too many. The transcript still has all the detail; the spoken line is just the chyron.
* Profiles matter. The hook runs `say` regardless, but `say` itself needs audio access in the sandbox, so sessions launched in a locked-down profile will be silent. That's not a bug; it's the profile's job. The 🗣 line still appears as text, so nothing is lost.

That's the whole thing. One emoji convention, one stop hook, one optional voice upgrade. The next time I walk to the kitchen, the laptop will probably tell me what it did before I'm back.
