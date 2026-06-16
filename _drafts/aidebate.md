---
title: "I Made the AI Models Debate Each Other. Then I Hired a Clown."
date: 2026-05-DD HH:MM:SS -0500
---

I keep ending up in the same situation: I have a non-trivial question, I want a second opinion, and I'd really like a third. So I open Claude, then Codex, then Gemini, paste the same prompt into all three, and sit there comparing answers like I'm running a small unpaid focus group.

So I built [aidebate](https://github.com/orlenko/aidebate). It puts Claude, Codex, and Gemini on the same stage, gives them a topic, and runs them through opening statements, rebuttals, the works. The output is a clean transcript I can scan. That's the actually useful part: you get the diversity of model perspectives without playing moderator.

The next part is less useful and entirely optional.

There is, if you want one, a clown. After the debate ends, a Claude-driven roastmaster can step out from behind the curtain and mock the participants — their arguments, their phrasings, their tics, their epistemic posture. The roast is, by default, very foul-mouthed. You can turn that off. Most people should turn that off. I leave it on, because there is something genuinely funny about an LLM noticing that another LLM keeps starting paragraphs with "Certainly," or has a soft spot for the phrase "deeply considered."

The roast is also, oddly, the part that proves the models are actually different. When the roastmaster lands a specific, observational shot about Gemini's particular rhetorical mannerisms, you stop thinking of these systems as interchangeable text faucets.

MIT licensed, configurable, foul-mouth mode togglable. Use with caution. Or don't — that's between you and your speakers.

[github.com/orlenko/aidebate](https://github.com/orlenko/aidebate)
