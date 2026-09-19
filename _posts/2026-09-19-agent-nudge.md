---
title: "Still Waiting?"
date: 2026-09-19 09:30:00 -0400
description: "agent-nudge is a small daemon that notices when a Claude or Codex session in tmux has dozed off and asks it, once, whether it's done."
image: /assets/og/2026-09-19-agent-nudge.png
thumbnail: /assets/images/2026-09-19-agent-nudge.jpg
project:
  id: agent-nudge
  name: Agent Nudge
  status: installable
  status_label: Installable plugin
  language: Python
  short: "Wake Claude and Codex sessions in tmux that stopped short of their goal."
  description: >-
    A per-machine daemon that watches agent panes in tmux and, when one has
    gone idle with work left, types a single polite question into it.
  repository: "https://github.com/orlenko/skills#agent-nudge"
  install: "claude plugin install agent-nudge@orlenko-skills"
  workflow:
    label: "Watch panes / nudge once"
    steps:
      - "Find agent panes in tmux"
      - "Wait for a quiet screen and an empty input box"
      - "Ask a classifier whether it's really idle"
      - "Type one line, then back off"
---

![Two men in a pub: one in a bowler hat holds a pint while the other leans in, eyebrows raised, to nudge him.]({{ '/assets/images/2026-09-19-agent-nudge.jpg' | relative_url }})

Coding agents stop short. They finish a step, write a tidy report, and sit there. Or they say "I'll report back when CI goes green" and then set up nothing whatsoever that would tell them CI went green. When I'm around, a two-word "still waiting?" usually gets them going again. When I'm asleep and there are several of them in tmux panes, nobody asks, and in the morning I find a row of agents politely waiting for each other.

So I made [agent-nudge](https://github.com/orlenko/skills#agent-nudge): a gentle-mannered supervisor that helps the team members snap out of their daydreaming.

## What it does

It's a small per-machine daemon, standard-library Python, running under launchd on macOS or `systemd --user` on Linux. Every 30 seconds it finds the tmux panes running `claude` or `codex` (by walking the process tree under each pane), reads each screen with `tmux capture-pane -e`, and keeps track of how long each one has been still.

When a session has been idle for 10 minutes, it types one line into the pane with `tmux send-keys`:

> [agent-nudge] You have been idle for 12 min. Is your goal done, or are you blocked? If anything is still unblocked, continue with it. If you are waiting on something, say what, and set up something that will wake you.

It works through tmux rather than hooks, which means there is nothing to configure per session. Any Claude or Codex session in a pane is covered, because to the agent the nudge is just another prompt somebody typed.

## Manners

Typing into someone's live terminal is rude unless you're careful about it, so most of the code is about when not to. It only types when all of these hold:

- The screen above the input box hasn't changed for the idle threshold. If the footer shows a monitor or background task running, the threshold stretches to 60 minutes, since the agent presumably has something coming.
- The input box is empty. This is less obvious than it sounds: Claude draws its prompt suggestions in dim text, so a line reading `❯ check messages` may well be empty. The parser reads the text styling, so it never tacks a nudge onto the end of something a person was halfway through typing.
- Nobody has typed anything in that tmux session for 5 minutes.
- There's no spinner and no dialog on screen.
- A cheap classifier (TypeSafe's Jev, about $0.00004 and 0.4 seconds a call) agrees that the screen is idle and that the agent's last message isn't a question for its human. If the agent has asked me something, the next move is mine.

It nudges once per stop. If the agent answers and stops again, the next wait triples, up to four hours. It starts in dry-run, logging what it would have said, until you switch it to live. A pane can opt out with a tmux option (`@nudge off`).

When the classifier sees that the agent is waiting on something outside itself, and nothing on screen is actually watching for it, the nudge gets more pointed: "You said you'd act when something changes, and nothing is watching for it. Check it now."

## The first day

It ran in dry-run for a few hours and then went live on two machines. Two cases from that first day:

A player was waiting on a CI check with nothing watching it. The check had already passed some time earlier. The nudge arrived, the agent looked, and it carried on as if it had meant to all along.

The other was worse: in a multi-agent setup, one player had been sitting idle for seven and a half hours while 58 messages from the other agents piled up unread. Every health signal said it was fine. The nudger flagged it within minutes of first seeing the pane.

## Orchestra players

That second case comes from [Agent Orchestra](https://bjola.org/2026/09/08/agent-orchestra.html), which keeps durable mail between many agent sessions (Maestro conducting, Trumpet and Triangle doing the work). The nudger reads Orchestra's local files to match a pane to its seat. A player with mail that arrived after it went quiet gets nudged after 2 minutes instead of 10, with a note that N messages came in and nothing woke it. A player with nothing assigned is idle by design, and it's left alone.

Building this turned up two bugs in Orchestra's own wake-up, both fixed the same day. Claude Code runs a different hook, `StopFailure`, when a turn ends in an API error, and Orchestra wasn't listening for it. And leaving FYI mail unread used to switch off the wake-up waiter entirely. Every health check missed both. It took something outside the system, reading the actual screen, to catch either one.

## Trying it

```sh
claude plugin marketplace add orlenko/skills        # if you haven't already
claude plugin install agent-nudge@orlenko-skills    # or: codex plugin add agent-nudge@orlenko-skills
mkdir -p ~/.config/agent-nudge && echo 'TYPESAFE_API_KEY=...' > ~/.config/agent-nudge/env && chmod 600 ~/.config/agent-nudge/env
```

Then ask the agent to install the nudger. The plugin's skill knows where its `agent-nudge` script lives and runs `install` (the launchd or systemd user service, starting in dry-run). From a clone of the repo you can run it directly:

```sh
plugins/agent-nudge/bin/agent-nudge install
plugins/agent-nudge/bin/agent-nudge log         # what it would have said
plugins/agent-nudge/bin/agent-nudge mode live   # once the log looks right
```

The [README](https://github.com/orlenko/skills#agent-nudge) has the current commands.

## Caveats

- With the key set, the last 40 or so lines of an idle pane's screen go to TypeSafe, a third-party API, once per stop. Live mode requires the classifier; dry-run works without it.
- It only sees sessions running inside tmux.
- The Codex screen parsing hasn't been checked against a real Codex pane yet. Claude's has.
- It's a day old. I don't have numbers yet on how often a nudge turns into real work. The log records that, so ask me again in a month.
