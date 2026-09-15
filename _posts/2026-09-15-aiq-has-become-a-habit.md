---
title: "aiq Has Become a Habit"
date: 2026-09-15 17:15:00 -0400
description: "Quick shell questions, whichever coding agent has room, and long jobs that survive a quota reset: my everyday aiq recipes."
image: /assets/images/2026-09-15-aiq-has-become-a-habit.jpg
thumbnail: /assets/images/2026-09-15-aiq-has-become-a-habit.jpg
project:
  id: aiq
  name: aiq
  status: installable
  status_label: Installable
  language: Go
  short: "Route Claude and Codex sessions across subscriptions."
  description: >-
    Ask questions from the shell, choose a provider automatically, and keep
    long-running sessions moving across account limits with supervised handoffs.
  repository: "https://github.com/orlenko/aiq"
  install: "go install github.com/orlenko/aiq/cmd/aiq@latest"
  workflow:
    label: "Everyday questions + long-running work"
    steps:
      - "Add your subscription accounts"
      - "Let auto choose a provider"
      - "Ask quick questions with aip"
      - "Supervise long jobs through quota limits"
---

![A colourful mural on a brick wall beneath a blue sky, with the words “Everything you can imagine is real.”]({{ '/assets/images/2026-09-15-aiq-has-become-a-habit.jpg' | relative_url }})

*Photo by me.*

I made [aiq](https://github.com/orlenko/aiq) because I was tired of an overnight coding job stopping at a usage limit while another subscription still had room. I [wrote about that first version](https://bjola.org/2026/09/08/the-show-must-go-on.html), and I still use it for exactly that.

What I hadn't expected was how much I would enjoy the small, everyday uses. It has grown into one of my favourite tools. I type `aiq run auto` when I want to work, `aip` followed by a question when I want an answer, and `aiq long claude` when I expect the work to outlast an account's quota. Such an improvement to my quality of life, and I keep being pleased about it.

aiq is a Go command-line tool that pools paid Claude Code and Codex subscriptions. It launches the installed CLIs under separate account credentials, chooses accounts using their quota and reset times, and can supervise a long session through an account or provider change. It runs on macOS and Linux, and the source is MIT-licensed.

Here are the recipes that explain why it has become a habit. The prompts below are generic examples you can adapt to your own work.

## Open a session and get on with it

**One important default: `auto` always enables permission bypass**, including for one-shot questions. On Claude that is `--dangerously-skip-permissions`; on Codex it is `--yolo`, disabling both approvals and sandboxing. That suits how I use it. Use an explicit provider, such as `aiq run claude` or `aiq run codex`, when you want the CLI's normal permission behaviour or provider-specific options.

From the checkout I want to work in:

```bash
aiq run auto
```

aiq considers both providers, picks an eligible account using its quota score, and opens an interactive session. I don't have to choose Claude or Codex first. For a lot of ordinary work, I am happy with either, and the choice was just another small decision between having a thought and doing something about it.

The score favours quota that is about to expire unused. An account with a weekly reset approaching and plenty left can be a better destination than one whose allowance needs to last several more days. It also accounts for the shorter usage windows and worker load. `auto` uses the same machinery across both pools.

The provider and account are chosen at launch. An ordinary `auto` session stays with that choice; supervised mid-session handoffs belong to `aiq long`, which I'll get to below.

I can send the first message as part of the launch:

```bash
aiq run auto -- "Read this repository and explain how the test suite is organised."
```

Or choose how much model I want:

```bash
aiq run auto --model-tier 0
aiq run auto --model-tier 2 --effort 2
```

In the [current tier mapping](https://github.com/orlenko/aiq#automatic-provider-and-model-selection), tier 0 selects Fable or Astra, the default tier 1 selects Opus or Sol, tier 2 selects Sonnet or Terra, and tier 3 selects Haiku or Luna. These are aiq's configured pairings, not a promise that two models behave identically. The tier stays fixed if a worker needs to retry on another account or provider.

Numeric effort is separate from the model tier: `2` means medium, `3` means high, and `4` means xhigh. Leaving it out preserves the CLI's default effort.

## Ask a question without leaving the shell

This is the little convenience I have become especially fond of:

```text
aip how can I see which process is listening on port 8080?
aip what's the difference between git restore and git reset?
aip how do I run a command over ssh without allocating a tty?
```

`aip` is a shell function from the README. The basic version is:

```zsh
aip() {
  aiq run auto -p "$*"
}
```

With just that function, quote the question as you normally would in a shell:

```bash
aip "What's the difference between a login shell and an interactive shell?"
```

`-p` becomes Claude's print mode or Codex's `exec` command. Each question is a fresh worker invocation. aiq scores the accounts for that call, tries to keep workers off accounts carrying interactive sessions when another is available, and can retry an early quota rejection on another account, including across providers.

The extra bit that makes **unquoted** questions pleasant is a zsh line-editor widget. Put the following in `~/.zshrc`, alongside the function above:

```zsh
verbatim_cmds=(aip)

_verbatim_accept_line() {
  local name rest
  for name in $verbatim_cmds; do
    [[ $BUFFER == "$name "* ]] || continue
    rest=${BUFFER#"$name "}
    # Leave an already-quoted history entry alone.
    [[ $rest == "${(qq)${(Q)rest}}" ]] || BUFFER="$name ${(qq)rest}"
    break
  done
  zle .accept-line
}
zle -N accept-line _verbatim_accept_line
```

At Enter, the widget quotes everything after `aip` before zsh interprets the line. Apostrophes, question marks, globs and exclamation marks reach the prompt intact. History stores the quoted form, so recalling the command doesn't quote it twice.

This is for a line beginning with `aip ` in an interactive zsh prompt. Everything after it is question text, including a `|` or `>`; use the underlying `aiq` command when you want actual shell piping or redirection. If your shell setup already customises `accept-line`, integrate the widget with that setup rather than blindly replacing it.

I particularly like this for the small command-line questions that appear while I'm already doing something else. I get an answer in the terminal and carry on. I no longer have to give a forgotten shell flag its own browser expedition.

## Give a one-shot task a little more thought

The underlying command is useful on its own when I want to choose a tier or save the result:

```bash
aiq run auto --model-tier 0 --effort 4 -p \
  "Read docs/cache-design.md. Review invalidation and concurrency risks. Do not edit files." \
  > cache-review.md
```

For a smaller task:

```bash
aiq run auto --model-tier 2 --effort 2 -p \
  "Explain how this repository runs its unit tests. Do not change anything."
```

These are coding-agent invocations with access to the current workspace, so I can refer to a file in the checkout. “Do not edit files” is an instruction to the agent; `auto` still has permission bypass enabled. If I want Codex's actual read-only sandbox, I choose Codex explicitly and pass native options after `--`:

```bash
aiq run codex -- exec --sandbox read-only \
  "Review the uncommitted diff for correctness. Do not modify files."
```

`auto` translates the common prompt, tier and effort controls. For native flags, a specific account, or resuming a particular conversation, I use the provider explicitly.

## Let the existing commands use the pool

Once the shims are installed and first on `PATH`, familiar commands route through aiq:

```bash
claude
codex
claude -p "Explain the build scripts in this checkout."
codex exec "Review the current diff."
```

A shim is a small wrapper that selects an account and then launches the real CLI. This also covers workers an agent launches by those command names, so existing scripts can benefit without being rewritten around a new API.

Explicit-provider interactive sessions are sticky per workspace. Workers are scored per invocation and respect concurrency caps and a weekly reserve. If a fleet sometimes reaches the worker cap, I can let workers wait for a slot:

```bash
AIQ_WAIT=600 codex exec "Review the tests in this checkout."
```

That waits up to ten minutes for worker capacity. An exhausted pool still refuses immediately on this path; waiting for a usage reset is part of the long-session supervisor.

## Keep a big job moving through quota limits

The heavy-duty end is where aiq started:

```bash
aiq long claude
# Or start with Codex:
aiq long codex
```

Run one of these from the workspace. aiq starts or attaches to its supervised session in tmux. I give the agent the task as usual: work through a migration, run a repair-and-test loop, or coordinate a larger batch of work.

For an unattended workflow where I deliberately want permission bypass, the explicit forms are:

```bash
aiq long claude -- --dangerously-skip-permissions
aiq long codex -- --yolo
```

The supervisor watches the account's quota. With the default configuration, when the tightest relevant window has 4% or less remaining, the next lifecycle hook asks the agent to finish his current unit of work, stop background jobs and subagents, write a handoff note, and end the turn. The daemon then starts the successor in the same tmux pane.

What happens next depends on who has room:

| Available successor | How work continues |
| --- | --- |
| Another account on the same provider | Resume the existing conversation when a resumable transcript is available. |
| An account on the other provider | Start a fresh conversation from the working tree and any available handoff note. |
| No eligible successor | Wait until another account has enough headroom, for example after its quota resets. |

The second row deserves attention. Claude's conversation does not become a Codex conversation. The successor gets the files and any available handoff, so unfinished work, decisions and verification results need to be recorded clearly. If the account becomes blocked before the wrap-up finishes, takeover can happen without a handoff note. Permission bypass carries across in the successor's syntax; other provider-specific flags are dropped.

The supervisor currently looks for a different account when taking over. A pool containing only one account cannot use this mechanism to restart that same account after its reset; the continuation recipe assumes there is another account to move to.

This gives an overnight job a way to continue when quota runs out. It still depends on the agent following the wrap-up instructions, and on the machine, daemon and tmux remaining available. I still need to give him a clear task and a way to check his work.

A few controls are useful from the same workspace:

```bash
aiq long list
aiq long attach
aiq long drain .
aiq long stop .
```

`list` shows the sessions and their state. `attach` gets me back into the pane. `drain .` requests a move for this workspace's session, and `stop .` ends it. Starting `aiq long claude` again in a workspace with an existing long session attaches to that session.

## See why an account was chosen

When I do want to look under the bonnet:

```bash
aiq status --refresh --explain
aiq top
aiq doctor
```

The first refreshes telemetry and explains the account ranking. `top` is a live console view. `doctor` checks the setup. The daemon also serves a local status page at `http://127.0.0.1:7379/`.

Accounts share settings, plugins and session history through overlay homes, while their credentials stay separate. Claude's `.claude.json` is also private per account, which means project trust and user-scoped MCP configuration have some account-specific behaviour. The [README's architecture section](https://github.com/orlenko/aiq#how-it-works) explains the details.

Routing uses stored telemetry, so stale or unknown quota is not a guarantee of capacity. The shims can still route from the last poll if the daemon is down. Claude's quota feed uses an undocumented usage endpoint, which can change; aiq also has status-line updates and worker rejection handling to fall back on. Those are practical limits of the tool.

## Set it up

Start with Git, Go at the version required by the repository's `go.mod` or newer, and the provider CLIs you want to use. Long sessions also need tmux. The [installation instructions](https://github.com/orlenko/aiq#install) give the current setup details; the short version for macOS or Ubuntu is:

```bash
git clone https://github.com/orlenko/aiq.git
cd aiq
./install-or-update.sh
```

Run the script as your regular user. It builds aiq, installs the shims, and installs or restarts the user daemon. Follow its printed instructions to put the shim directory and `~/.local/bin` on `PATH`; it doesn't edit your shell configuration.

Then add the accounts you actually have. These names are arbitrary labels:

```bash
aiq account add claude primary
aiq account add claude secondary
aiq account add codex primary
aiq doctor
```

You don't need this exact combination. `auto` can use the providers available in your pool. Claude account setup has two browser steps, one for the CLI login and one for the quota polling grant; Codex has one. Make sure the browser signs into the intended account each time.

Then add `aip` if you want it, open a fresh shell, and try:

```bash
aiq run auto
```

The biggest payoff comes when there are several subscriptions to route between. aiq doesn't create extra quota. It helps me use the allowance I already have, and removes a surprising amount of account administration from the middle of a thought.

I built it to keep large jobs running. Now I also reach for it when I can't remember a command, want a quick second opinion, or simply want to open a coding session. The small uses have made me at least as happy as the original one.

[Source, README and recipes: github.com/orlenko/aiq](https://github.com/orlenko/aiq).
