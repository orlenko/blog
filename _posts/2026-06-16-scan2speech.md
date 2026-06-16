---
title: "How I Finished a Paper Book Without Reading It"
date: 2026-06-16 17:00:00 -0400
description: "For the paper book you keep meaning to finish — photograph the next twenty pages and let the car read them aloud."
---

![Open paper book on a wooden table, sunlit window, vase of flowers nearby]({{ site.baseurl }}/assets/images/openbook.png)

I have a paper book I want to read. I do not have the kind of life where I can sit down with a paper book and read it. These two facts have been in unresolved standoff for months, the book on the nightstand, me on my way somewhere else.

The walk to the car is short. The drive is long. So I built [scan2speech](https://github.com/orlenko/scan2speech).

The workflow is the simplest version that works. I open the book to wherever I left off, take photos of the next ten or twenty pages on my phone, and upload them in the browser on the way to the car. By the time I'm sitting in the driver's seat, the pages are transcribed and queued up to be spoken back to me. I press play, I drive, the book reads itself. By the time I'm home, I've made it through another chapter and the book has moved a little closer to its end.

Most of the engineering work was finding a model that could actually read book pages. I tried a lot of OCR approaches before settling, and the commit history has the full trail of failed experiments. What ended up working reliably was gpt-5.5. Book pages turn out to be unkind to traditional OCR — curve from the spine, kerning artifacts, footnotes, italicized fragments, sometimes a hand-pencilled note from a previous owner — and a model that can read them the way a human eye reads them is the part where this stopped being a toy.

The philosophy is the same as my [receipts tool]({{ site.baseurl }}/2026/04/22/receipt-scanner.html): no accounts, no backend, bring your own API key. The whole thing is a static page that talks to the API directly from your machine. The book never leaves your browser. The key never leaves your browser. There is no server to compromise, because there is no server.

MIT licensed, free, [github.com/orlenko/scan2speech](https://github.com/orlenko/scan2speech).

I'm not going to argue this is a substitute for sitting on the couch with a book. It isn't. But the realistic alternative for me was the book staying on the nightstand for another year, and the book wasn't going to wait that long.
