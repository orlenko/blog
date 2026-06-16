---
title: "A Tiny Script to See the Images You've Been Pasting Into Claude"
date: 2026-05-DD HH:MM:SS -0500
---

When you paste an image into a Claude Code session, the file ends up somewhere on disk and the model sees a reference to it. You don't see the image again. Most of the time that's fine, but every so often I'd find myself losing track of what I'd actually shown the model. Was that the right screenshot? Did I paste the new diagram or the older version? The chat scrollback doesn't tell you.

I wrote [a small script](https://gist.github.com/orlenko/444ff24ff928979b94a3a734dba77f69) that pops up a preview of the images I've recently pasted into a Claude session. It's a gist, not a project. About as much code as it needed to be and no more.

Not really a tool. Just a small piece of glue that closes a small annoyance.
