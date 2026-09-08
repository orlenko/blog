---
title: "The Show Must Go On"
date: 2026-09-08 15:21:00 -0400
description: "I got tired of overnight jobs stopping at a usage limit while another subscription still had room. So I made aiq."
image: /assets/og/2026-09-08-the-show-must-go-on.png
thumbnail: /assets/images/2026-09-08-aiq-shift-change.png
---

![A cheerful robot crew hands over a shift logbook while a printing machine keeps running.]({{ '/assets/images/2026-09-08-aiq-shift-change.png' | relative_url }})

At work, I'm running large orchestrations that exhaust the quota of a single Max or Pro subscription pretty quickly. I found myself manually switching between accounts, telling Claude to write a handoff for Codex and telling Codex to write a handoff for Claude, and doing this repeatedly.

Sometimes I'd leave a large job overnight, and it would exhaust the quota and get stuck in the middle of the night. That was frustrating. I have multiple subscriptions to switch between, and the work should be able to continue, so I made [aiq](https://github.com/orlenko/aiq).

aiq pools Claude Code and Codex accounts. PATH shims route `claude`, `codex`, and their workers, including nested launches.

For long-running orchestrations:

```bash
aiq long claude
# or
aiq long codex
```

The session runs under tmux. Near a quota limit, hooks ask the agent to finish the current unit of work, stop his background jobs, and write a handoff. aiq then restarts in the same pane on an account with headroom.

- Same provider: resume the full conversation on another account.
- Different provider: start a fresh session from the handoff and working tree. Claude can hand off to Codex or vice versa.
- Pool exhausted: wait for a quota reset, then continue.

Accounts share settings, plugins, and history; credentials stay separate.

Routing considers remaining quota, reset times, and worker load. Interactive launches are sticky per workspace; workers are scored per call, with concurrency caps and a weekly reserve. `aiq status --explain` shows the ranking.

macOS and Linux. MIT. [Setup and source](https://github.com/orlenko/aiq#install).
