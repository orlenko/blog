---
title: "Tracking Your AI-Powered Chaos: A Tool for When You Can't Remember What the Hell You Did"
date: 2026-01-23
---

My project manager asked me last week: "So what did we accomplish this month?"

I stared at my screen. Blinked a few times. Opened my mouth. Closed it.

I had absolutely no fucking idea.

## The Problem with Being Too Productive

Here's the thing about working with AI coding assistants: you get a *lot* done. Like, an unreasonable amount. On any given day, I might have five or six Claude Code sessions running in parallel. One is hunting down a bug in the authentication flow. Another is implementing a feature. A third is writing documentation (yes, really). A fourth is debugging why CI is being a little bitch. A fifth is addressing AI-generated review comments on a PR.

It's chaos, but it's *productive* chaos.

The problem? When you're shipping that fast, you lose track. The work blurs together. You know you did a lot, you can *feel* it, but when someone asks for specifics? Your brain just serves up a 404.

I tried asking Claude to analyze my Git history and generate a report. That worked, sort of. But it felt like archaeology—digging through commit messages after the fact, trying to reconstruct what I was thinking two weeks ago.

What I really wanted was something that just... watches. Takes notes while I work. So when I need to remember, or when I want to brag, or when my PM needs a status update, I can just ask: "What did I do?"

## So I Built a Thing

Meet [claude-activity-log](https://github.com/orlenko/claude-activity-log).

It's a little daemon that monitors all your Claude Code sessions, logs everything to SQLite, and generates AI-powered summaries. Daily, weekly, monthly—whatever granularity you need.

The idea is simple: it runs in the background, watches the session files Claude creates, and quietly records everything. Then when you want to know what you did, you just ask.

```bash
# What did I do today?
claude-activity today

# This week's summary (AI-generated)
claude-activity week

# Search for that thing you remember vaguely
claude-activity search "authentication"
```

## The Features That Actually Matter

**Background monitoring** - Start it once, forget it exists. It watches `~/.claude/projects/` for new sessions and logs them automatically.

**SQLite storage** - Everything goes into a local database. Messages, timestamps, tokens used, git branches, projects. All queryable.

**AI summaries** - This is the good stuff. It uses Haiku (cheap and fast) to generate actual human-readable summaries of what you accomplished. Not just "made 47 commits" but actual descriptions of the work.

**Web UI** - Because sometimes you want to browse your history in a browser like a civilized person. Search, filter by project, view full conversations.

**CLI** - For those of us who live in the terminal. Rich formatted output, colored tables, the works.

## The Slightly Narcissistic Part

I'll be honest: there's something deeply satisfying about looking at your activity log at the end of a week.

It's like a fitness tracker for coding. You can see the sessions pile up, watch the summaries grow, get that little dopamine hit from quantified productivity. "Holy shit, I actually did all that?"

Is it narcissistic? Maybe. But after 20+ years of engineering, I've learned that feeling good about your work matters. Burnout is real. Sometimes you need to see the evidence that you're actually accomplishing things, especially when the work is invisible (debugging, refactoring, infrastructure).

## How to Get It

```bash
git clone https://github.com/orlenko/claude-activity-log.git
cd claude-activity-log
pip install -e .
```

You'll need Python 3.11+ and an Anthropic API key for the AI summaries. Set `ANTHROPIC_API_KEY` in your environment and you're good to go.

Start the daemon:

```bash
claude-activity start
```

Then just... work. It'll watch. When you're curious:

```bash
claude-activity today --detailed
```

## Who This Is For

If you're running multiple Claude sessions, if you're using AI assistants heavily in your workflow, if your PM keeps asking "what did you work on this sprint?"—this might be useful.

Or maybe you just want to feel good about how much you're getting done. That's valid too.

The tool is MIT licensed, PRs are welcome, and if you find it useful, that makes me happy. If you don't, well, at least I can look at my own activity log and feel productive.

---

*This post was dictated while I should have been sleeping. The irony of blogging about productivity tracking instead of being productive is not lost on me.*
