---
title: "Mindfulness Meditation for Your AI Swarm"
date: 2026-02-08 12:00:00 -0800
---

![Silhouette watching a wall of scrolling colored log lines in a dim room]({{ site.baseurl }}/assets/images/logs.jpg)

I run a lot of Claude instances. Claude Code sessions, sub-agents spawned by those sessions, automation loops that kick off Claude silently in the background. At any given time there might be half a dozen AI conversations happening on my machine, most of them invisible to me.

That's the part that started to bother me. The tools that launch Claude silently — automated loops, orchestration scripts, CI helpers — consume Claude's output and send commands back without showing you anything. You just see a spinner, maybe a progress bar if you're lucky. What's actually being said in those conversations? No idea. It could be doing exactly what you asked, or hallucinating its way through your codebase, or writing poetry instead of fixing your tests, and you wouldn't know.

I wanted to peek behind the curtain. So I wrote [claude-log-tail](https://github.com/orlenko/claude-log-tail).

It's dead simple. You point it at your `~/.claude/projects` directory and it tails every `.jsonl` conversation log it can find, including new ones that appear while it's running. The output is colorized and compact — one terminal window showing every conversation happening on your machine in real time.

```bash
npx claude-log-tail ~/.claude/projects
```

That's it. No installation, no dependencies, no config, no server. If you have Node.js, `npx` just fetches it and runs it. If you only care about one specific project, pipe it through grep:

```bash
npx claude-log-tail ~/.claude/projects | grep "my-specific-project-dir"
```

What you get is a stream of color-coded messages scrolling past: human messages, Claude responses, tool calls, sub-agent conversations, all interleaved. It auto-discovers new log files as new sessions spin up, so you don't have to restart it when you kick off another agent.

Watching it is surprisingly meditative. You know that mindfulness exercise where you sit quietly and observe your thoughts passing by without judgment? This is that, except instead of your own thoughts you're watching the inner dialogue of your AI swarm. The agents think. They call tools, reason through problems, occasionally go down a wrong path and course-correct. You're not intervening, not directing, just watching the stream of consciousness flow by in pretty colors.

It also catches problems early. When one of your background agents starts looping on the same error, going off on a tangent, or having an existential crisis about type definitions, you see it immediately instead of finding out twenty minutes later when it produces garbage output.

If you're running multiple Claude sessions and want to know what's actually happening under the hood, give it a try. It's `tail -f` for all Claude activity on your machine, and it turns out that's a surprisingly pleasant thing to have running in a spare terminal.
