---
title: "When the Work Needs More Than a Pair"
date: 2026-09-08 16:32:00 -0400
description: "Agent Pair connects two sessions. Agent Orchestra coordinates a larger crew across machines."
image: /assets/og/2026-09-08-agent-orchestra.png
project:
  id: agent-orchestra
  name: Agent Orchestra
  status: installable
  status_label: Installable plugin
  language: Python
  short: "Coordinate coding-agent sessions across machines."
  description: >-
    A durable mailbox hub for one conductor, multiple players, and their child
    sessions, with a shared member tree and task view.
  repository: "https://github.com/orlenko/skills#agent-orchestra"
  install: "claude plugin install agent-orchestra@orlenko-skills"
  workflow:
    label: "Durable mail / one hub"
    steps:
      - "Start the hub"
      - "Join a conductor"
      - "Invite players + their children"
      - "Assign work + collect results"
---

[Agent Pair](https://github.com/orlenko/skills#agent-pair) is one of my daily tools. It connects two coding-agent sessions through a durable mailbox. Give one session the other's invite, and they can talk directly, on the same machine or across machines.

With a larger orchestration, I want one session coordinating the work, several others handling pieces of it, and those sessions able to bring in their own help. [Agent Orchestra](https://github.com/orlenko/skills#agent-orchestra) provides the communication for that arrangement.

There are three roles:

- **Hub:** a process on an always-on machine, holding the mailboxes in SQLite.
- **Conductor:** the session I'm working with, coordinating the other members.
- **Players:** the other sessions. Each can invite his own children.

Everyone connects outbound to the hub, so only the hub needs to be reachable. Invites pin its TLS certificate. Sessions can address the conductor, their parent, children, or siblings without me relaying messages between terminals.

Mail is durable. The monitor saves incoming messages locally before acknowledging them and retries outgoing mail. There's a member tree and a task view derived from the messages, so I can see who's involved and what work has been assigned.

One operational detail: Claude can wake when mail arrives. Codex currently picks it up through lifecycle hooks and notifications; idle wakeups aren't equivalent between the two.

I still use Pair for two sessions. It needs no hub, and setting up a whole Orchestra for a conversation between two agents would be unnecessary admin.

Pair and Orchestra handle communication, [Undrudge]({{ '/2026/05/04/undrudge.html' | relative_url }}) finds repetitive work worth automating, and [aiq]({{ '/2026/09/08/the-show-must-go-on.html' | relative_url }}) handles quota and handoffs. All four are part of my daily setup.

Claude Code and Codex plugins. Python 3.10+, OpenSSL. [Setup and source](https://github.com/orlenko/skills#agent-orchestra).
