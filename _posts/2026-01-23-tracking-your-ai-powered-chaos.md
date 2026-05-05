---
title: "I Forgot What I Did This Month (So I Built a Tool)"
date: 2026-01-23 09:00:00 +0000
image: /assets/images/robot.jpg
---

![Claude Activity Logger]({{ site.baseurl }}/assets/images/robot.jpg)

Last week my project manager asked what we accomplished this month and I just sat there with my mouth open. I knew we'd done a lot — the merged PRs, the general exhaustion — but the specifics had quietly evaporated.

This is what happens when you run five or six Claude Code sessions in parallel every day. One hunting a bug, one writing docs, one implementing features, one fighting with CI, one responding to review comments. You're productive as hell, but you can't actually remember any of it, because it all blurs into one continuous stream of terminals and diffs.

I ended up asking Claude to dig through my Git history and piece together a report. It worked, but it felt like hiring a private investigator to figure out where you were last Tuesday.

So I built [claude-activity-log](https://github.com/orlenko/claude-activity-log).

It's a daemon that watches your Claude sessions and takes notes. Runs in the background, logs everything to SQLite, and generates AI summaries when you ask for them. Daily, weekly, monthly, whatever you need.

```bash
claude-activity today
claude-activity week
claude-activity search "that auth thing"
```

There's a web UI too, if you're into that.

The actually useful part is the summaries. It uses Haiku to turn raw conversation logs into something readable — not "47 commits" but real descriptions of what you worked on. So when someone asks what you did, you can pull up an answer instead of mumbling about "various things."

There's something a little embarrassing about how satisfying it is to look at your activity log at the end of a week. Like checking your step count, but for coding. Twenty years into this career and I still want a number that says I existed.

If you're running a lot of AI sessions and losing track of your own work, maybe this helps. It's at [github.com/orlenko/claude-activity-log](https://github.com/orlenko/claude-activity-log). Python 3.11+, needs an Anthropic API key for summaries.

```bash
git clone https://github.com/orlenko/claude-activity-log.git
cd claude-activity-log
pip install -e .
claude-activity start
```

Then it watches while you work. When your PM corners you, run `claude-activity week` and answer like someone who paid attention.
