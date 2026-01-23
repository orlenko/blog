---
title: "Zero-Friction Blogging: Talk to Your Terminal, Publish to the Web"
date: 2026-01-23
---

What if I told you that you could publish a blog post by literally talking to your laptop?

No WordPress. No static site generator configuration nightmares. No "I'll set up my blog this weekend" that turns into months of procrastination. Just you, a terminal, and a conversation that becomes a published article.

This is that blog. And this post explains how you can build one too.

## The Problem We All Have

Every developer I know has the same story. We have thoughts worth sharing. Tools we've discovered. Opinions about software architecture, AI, testing strategies, vim vs emacs (it's vim). We *want* to blog. We know it would help our careers, help others, help us think more clearly.

But the activation energy is brutal.

You research static site generators. Jekyll? Hugo? Astro? 11ty? Next.js with MDX? Each rabbit hole leads to another. Then themes. Then plugins. Then "should I self-host or use Vercel?" Then custom domains. Then...

Three weekends later, you have a perfectly configured blog with zero posts and zero motivation left to write.

## The Solution: Make Infrastructure Invisible

What if the entire publishing workflow was just... talking?

Here's what this blog does:

1. I open Claude Code in a Git repository
2. I ramble about whatever's on my mind
3. I say "publish this"
4. Claude formats it into a proper Markdown post
5. Commits and pushes to main
6. GitHub Actions builds and deploys to GitHub Pages

That's it. I never touch a config file. I never think about deployment. I just *talk*, and the web updates.

## How to Build Your Own

The entire setup takes about 10 minutes. Here's everything you need.

### Step 1: Create a GitHub Repository

Make a new repo. Call it `blog` or whatever you want. Initialize it with a README.

### Step 2: Create the Jekyll Structure

You need these files:

**`_config.yml`** - The Jekyll configuration:

```yaml
title: Your Blog Name
description: Your tagline here
baseurl: "/your-repo-name"

markdown: kramdown
highlighter: rouge

defaults:
  - scope:
      path: ""
      type: "posts"
    values:
      layout: "post"
```

**`_layouts/default.html`** - Your theme (here's a clean dark one):

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{% if page.title %}{{ page.title }} | {% endif %}{{ site.title }}</title>
  <style>
    body {
      font-family: -apple-system, BlinkMacSystemFont, sans-serif;
      background: #0d1117;
      color: #c9d1d9;
      max-width: 800px;
      margin: 0 auto;
      padding: 2rem;
      line-height: 1.6;
    }
    a { color: #58a6ff; }
    code { background: #161b22; padding: 0.2rem 0.4rem; border-radius: 4px; }
    pre { background: #161b22; padding: 1rem; border-radius: 6px; overflow-x: auto; }
  </style>
</head>
<body>
  <header><h1><a href="{{ site.baseurl }}/">{{ site.title }}</a></h1></header>
  <main>{{ content }}</main>
</body>
</html>
```

**`_layouts/post.html`** - The post template:

```html
---
layout: default
---
<article>
  <h1>{{ page.title }}</h1>
  <p style="color: #8b949e;">{{ page.date | date: "%B %d, %Y" }}</p>
  {{ content }}
</article>
```

**`index.html`** - The homepage:

```html
---
layout: default
---
<h2>Posts</h2>
<ul>
{% for post in site.posts %}
  <li><a href="{{ site.baseurl }}{{ post.url }}">{{ post.title }}</a></li>
{% endfor %}
</ul>
```

### Step 3: Add the GitHub Action

Create `.github/workflows/pages.yml`:

```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: ["main"]

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: '3.2'
      - uses: actions/configure-pages@v4
      - uses: actions/jekyll-build-pages@v1
      - uses: actions/upload-pages-artifact@v3

  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - uses: actions/deploy-pages@v4
```

### Step 4: Enable GitHub Pages

Go to your repo's Settings → Pages → Set "Source" to "GitHub Actions".

### Step 5: Add Instructions for Claude

Create a `CLAUDE.md` file in your repo root. This tells Claude how to publish:

```markdown
# Blog Publishing Instructions

When the user wants to publish a post:

1. Extract interesting content from the conversation
2. Create `_posts/YYYY-MM-DD-slug-title.md` with frontmatter:
   ---
   title: "Title Here"
   date: YYYY-MM-DD
   ---
3. Commit and push to main
4. Confirm publication
```

### Step 6: Start Talking

Open Claude Code in your repo directory and just... talk. Share your thoughts. Paste screenshots. Ramble. When you're ready, say "publish this" and watch it happen.

## Why This Actually Works

This approach succeeds where others fail because it removes every decision point:

- **No theme decisions** - You set it once and forget it
- **No deployment thoughts** - Push to main, it's live
- **No formatting stress** - Claude handles Markdown structure
- **No editorial friction** - Your raw thoughts become posts

The key insight is that *talking is easier than writing*. When you write, you self-edit. You worry about structure. You question whether this sentence is good enough. When you talk, you just... express.

Claude bridges that gap. It takes your verbal brain dump and applies just enough structure to make it readable, while preserving your voice.

## The Golden Age of Software Development

We're living in an unprecedented moment.

A decade ago, publishing your thoughts meant setting up WordPress, managing hosting, dealing with PHP, fighting spam comments. Five years ago, it meant learning a static site generator and configuring CI/CD pipelines.

Today? You talk to your laptop and your thoughts appear on the internet.

This isn't just about blogging. It's a glimpse of where all software development is heading. The distance between intention and implementation is collapsing. You describe what you want, and it happens.

If you're a developer, you already have the skills to try this. Open Claude Code, point it at a repo, and start a conversation.

If you're not a developer but you're brave enough to use a command line (or even Claude Desktop), you can do this too. The barrier to entry has never been lower.

## The Only Rule

Ship something.

Don't wait until your theme is perfect. Don't wait until you have the ideal first post. Don't wait until you've figured out your "content strategy."

Create the repo. Add the config. Push. Publish something—anything—today.

Your thoughts deserve to exist somewhere other than your head. The infrastructure is now invisible. The only thing left is to start talking.

---

*This post was written at 2 AM, dictated to Claude Code, and published with a single command. Your blog can work the same way.*
