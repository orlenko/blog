# Brain Dump Blog - Claude Instructions

This is a zero-friction blog powered by Claude Code and GitHub Pages.

## How to Publish a New Post

When the user wants to publish a blog post (says "publish this", "make this a post", "blog this", etc.):

1. **Extract the content** - Take the interesting parts of the conversation. Don't include meta-discussion about publishing itself.

2. **Create the post file** - Save to `_posts/YYYY-MM-DD-slug-title.md` with frontmatter:
   ```markdown
   ---
   title: "Your Title Here"
   date: YYYY-MM-DD
   ---

   Content here...
   ```

3. **Handle images** - If the user pastes screenshots:
   - Save to `assets/images/YYYY-MM-DD-descriptive-name.png`
   - Reference in post as `![description]({{ site.baseurl }}/assets/images/filename.png)`

4. **Commit and push**:
   ```bash
   git add -A
   git commit -m "New post: Title of the post"
   git push origin main
   ```

5. **Confirm** - Tell the user the post is live (after ~1-2 min for GitHub Actions to deploy)

## Post Guidelines

- Keep the author's voice and style
- Add structure (headers, lists) where it helps readability
- Format code blocks with appropriate language tags
- Don't over-edit - this is meant to be raw and authentic
- Include personality and humor if present in the conversation

## Site Info

- **URL**: Will be `https://[username].github.io/blog/` once Pages is enabled
- **Theme**: Custom dark theme (GitHub-inspired)
- **Build**: Jekyll via GitHub Actions

## Troubleshooting

If the build fails, check:
- Frontmatter syntax (must have `---` delimiters)
- Image paths (must start with `{{ site.baseurl }}`)
- No liquid syntax errors in content
