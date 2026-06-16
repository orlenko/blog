---
title: "Small Terminal Upgrades, One Month In"
date: 2026-05-DD HH:MM:SS -0500
---

I went on a small spree of replacing the terminal tools I'd been using by default for fifteen years with their younger, sharper cousins. None of these are new, exactly — most have been around for a while — but they're the ones that earned a permanent spot on my machines after a few weeks of trial.

Roughly in order of how often I now reach for them:

**[bat](https://github.com/sharkdp/bat):** what `cat` would look like if `cat` had been written this century. Syntax highlighting, line numbers, git diff markers in the gutter. After a week with `bat` you stop using `cat` for anything bigger than a one-liner.

**[glow](https://github.com/charmbracelet/glow):** renders Markdown in the terminal. Headings get colored, lists get bullets, code blocks get boxes. The kind of thing that quietly makes you start writing more Markdown READMEs, because reading them is no longer a chore.

**[atuin](https://atuin.sh):** replaces the default `Ctrl-R` shell history with a full-screen TUI that remembers duration, exit code, working directory, host, and session. Once you've searched your history by "the command I ran in this directory last Tuesday that actually succeeded," you can't un-want it. It's also the data source for [undrudge](https://github.com/orlenko/undrudge), which is how I noticed it in the first place.

**[yazi](https://github.com/sxyazi/yazi):** modern terminal file manager, Rust-fast, with image previews and async I/O. If you ever liked Midnight Commander or ranger but found them showing their age, yazi is what you wanted.

**bookokrat:** a terminal reader for PDFs and EPUBs. Niche, but the niche is "reading a book without leaving the terminal," which turns out to be a niche I have.

None of these are revolutionary. Each one is the small kind of upgrade that doesn't get its own conference talk. But after a month, going back to the defaults feels like a downgrade I can't quite tolerate.
