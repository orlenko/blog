---
title: "What Was `[image 4]` Again?"
date: 2026-06-16 19:00:00 -0400
description: "A tiny script to preview the images you've pasted into a Claude Code session."
---

A small annoyance that built up over months: when you paste an image into Claude Code, it gets stored on disk and referenced in the scrollback as `[image 1]`, `[image 2]`, `[image 3]`, on up. The session has the pictures. You do not — not in any visible way. So if you go back later to ask "wait, did I paste the right diagram earlier?", the chat won't tell you. It just keeps saying `[image 4]`.

I wrote [a small script](https://gist.github.com/orlenko/444ff24ff928979b94a3a734dba77f69) that pops up previews of the images I've recently pasted into a Claude session. It's a gist, not a project.

The whole tool exists to answer "wait, what *was* that?", then get out of the way.
