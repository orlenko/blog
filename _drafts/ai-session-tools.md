---
title: "Three Tools for Living in AI Sessions"
date: 2026-05-DD HH:MM:SS -0500
---

If you spend most of your day with multiple Claude sessions open, a few tools save you specific, recurring pains. None of these were written for AI work, but each one solves a problem that gets worse the more AI sessions you run in parallel.

**[mosh](https://mosh.org):** a replacement for SSH that survives flaky wifi, sleep/wake, and roaming IP addresses. The first time I had a long-running Claude session on a remote box stay alive through a closed laptop and a coffee shop change, I felt like I'd been doing it wrong for years. If you've ever lost a session to a brief network hiccup at exactly the wrong moment, mosh is for you.

**[nono](https://github.com/Mixedbread-ai/nono) and sbx:** sandboxing primitives that let you give an AI agent access to *some* of your machine without giving it access to all of it. `nono`'s model is a three-bucket sandbox: roughly, the things the agent can read, the things it can read and write, and the things it shouldn't touch. This is the unglamorous infrastructure I'd been missing. The difference between "I trust this YOLO loop with my codebase" and "I trust this YOLO loop with my entire home directory" is enormous, and the only way to keep the first without conceding the second is sandboxing. (If you've been running the kind of [External Engine loops I wrote about earlier]({{ site.baseurl }}/2026/01/23/claude-code-loops.html), this is the part where you stop holding your breath.)

**cmux:** a terminal emulator with native Markdown rendering and AI integration baked in. The Markdown rendering alone is a quiet game-changer when most of what your AI sessions emit is Markdown. The part that compounds, though, is how it makes opening, naming, and switching between multiple AI sessions feel native to the terminal rather than bolted on.

None of these are about doing AI work faster. They're about doing the same amount of AI work without the small frictions adding up into a headache.
