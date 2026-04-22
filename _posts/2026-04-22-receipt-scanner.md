---
title: "I Built a Receipt Scanner Instead of Paying $99/Month"
date: 2026-04-22 14:00:00 -0500
---

Tax season rolled around and I had a few hundred receipts to deal with. The kind of stack that you know, intellectually, needs to end up as rows in a spreadsheet, but every cell of your body refuses to start typing.

So I looked at what's out there. Most of the online tools want you to upload one receipt at a time, which, no. Not when I've got hundreds. The ones that do batch processing want $99/month. I don't need this thing for a month. I need it for an afternoon. I need it right now. And meanwhile the OpenAI API can process a single receipt image for less than half a cent. Half a cent! Why am I being asked for a hundred dollars?

So I wrote a quick-and-dirty Python script. Point it at a folder of photos, it calls the API, pulls out the vendor, the date, the amount. Dumps the whole thing into a spreadsheet. It also straightens and crops the photos, because receipts photographed on a kitchen counter tend to look like they were taken during an earthquake.

Worked great. Did my taxes. Moved on.

Then I figured other people are probably dealing with the same thing right now, and asking regular humans to run a Python script from a terminal feels a little rude. So I rebuilt it as something that runs entirely in your browser.

It's at [receipts.clickable.one](https://receipts.clickable.one). You bring your own OpenAI key, or use OpenRouter if that's your thing. The key never leaves your browser. It's not stored on any server, because there is no server. The whole thing is a static page that talks to the API directly from your machine. If you don't trust that, the code is on [GitHub](https://github.com/orlenko/receipts) and you can clone it and run it locally with `python3 -m http.server 8000`.

It's free. It's open source. It's non-commercial. I'm not selling you anything, there's no account to create, no newsletter to dodge, no upsell for a "pro" tier. I needed this tool for myself, and since I already built it, you might as well have it too.

Tax season is miserable enough without paying a subscription to fight your own receipts.
