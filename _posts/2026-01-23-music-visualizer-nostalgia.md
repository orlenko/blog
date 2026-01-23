---
title: "The Fireplace We Forgot"
date: 2026-01-23
image: /assets/images/visualizer.jpg
---

![Sound Visualizer]({{ site.baseurl }}/assets/images/visualizer.jpg)

I wanted to show my kids what Winamp visualizations looked like.

Back in the late 90s, early 2000s, you'd put on some music and just... watch. The visualizer would dance, the colors would flow, and it was this ambient thing that lived on your desktop. Like a fireplace. You didn't interact with it. You just let it be there while the music played.

I spent a lot of evenings like that. Music on, visualizer running, maybe doing homework or just staring at the screen. Milkdrop doing its psychedelic thing. Geiss pulsing to the bass. It was meditative, in a way. Part of the experience of listening to music on a computer.

That's completely gone now. We've become so stressed out, I guess, that nobody can just sit and look at their music visualization anymore. Everything has to be interactive. Everything demands attention. The passive, ambient beauty of a screensaver that danced to your music—that's been drowned out.

So I vibe-coded a thing: [sound-visualizer](https://github.com/orlenko/sound-visualizer).

It runs entirely in the browser. No server, no native app, just open it and let it listen to whatever's playing through your mic. It picks up the ambient sound and reacts to it. Nine different presets: oscilloscope, spectrum analyzer, particles, starfield, plasma, matrix rain, wireframe terrain, and a recreation of the legendary Geiss visualization.

Browsers are amazing these days. The Web Audio API can capture and analyze audio in real time. Canvas 2D renders fast enough for smooth animations. You can build something that would have required a dedicated Winamp plugin back then, and it just runs in a tab.

I showed it to my kids on a second monitor while music was playing. They watched for a bit, said "cool," and went back to whatever they were doing.

They weren't impressed.

And that's fine. It's not their nostalgia. They didn't grow up with Winamp skins and plugin ecosystems and the thrill of finding a visualizer that really matched your music taste. To them it's just a thing that does some shapes on a screen.

But for me, firing it up and watching the plasma flow while something plays—it takes me back to a simpler time. When you could just sit with your music and watch something beautiful happen.

Try it yourself: [orlenko.github.io/sound-visualizer](https://orlenko.github.io/sound-visualizer/)

Press 1-9 to switch presets. Space for fullscreen. Then just... let it play.

Like a fireplace.
