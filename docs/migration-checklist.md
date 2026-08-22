# Bjola.org cutover checklist

Do not push the root-path production configuration as an ordinary content
deployment. Until `bjola.org` is attached, that build would break asset and
navigation URLs on the currently live `orlenko.github.io/blog` project site.

Commit the migration locally, then launch it while the owner is present as one
short, reversible operation: push, wait for the GitHub Actions build, attach
`bjola.org` to `orlenko/blog`, and update DNS immediately. A brief interruption
is possible during propagation; do not start the operation unless the full
cutover and rollback can be completed in the same session.

## Before cutover

- Verify `bjola.org` in the GitHub account's Pages domain settings.
- Confirm the deployment workflow on `orlenko/blog` is green.
- In **that repository's** Pages settings, set the custom domain to `bjola.org`.
  Do not change the custom domain on `orlenko/orlenko.github.io`.
- Do not add a repository `CNAME` file; the custom Actions workflow ignores it.
- Change only the apex and `www` records needed by GitHub Pages. Leave the
  nameservers and registrar unchanged for this launch.

## Legacy URL test set

Each old project-site URL should redirect to the matching dated path on
`bjola.org`, without the `/blog` repository prefix.

| Old URL | Expected destination |
| --- | --- |
| `https://orlenko.github.io/blog/2026/01/23/claude-code-loops.html` | `https://bjola.org/2026/01/23/claude-code-loops.html` |
| `https://orlenko.github.io/blog/2026/01/23/hello-world-from-the-future.html` | `https://bjola.org/2026/01/23/hello-world-from-the-future.html` |
| `https://orlenko.github.io/blog/2026/01/23/music-visualizer-nostalgia.html` | `https://bjola.org/2026/01/23/music-visualizer-nostalgia.html` |
| `https://orlenko.github.io/blog/2026/01/23/tracking-your-ai-powered-chaos.html` | `https://bjola.org/2026/01/23/tracking-your-ai-powered-chaos.html` |
| `https://orlenko.github.io/blog/2026/02/08/meditation-for-your-ai-swarm.html` | `https://bjola.org/2026/02/08/meditation-for-your-ai-swarm.html` |
| `https://orlenko.github.io/blog/2026/02/25/iterm2-window-arrangements.html` | `https://bjola.org/2026/02/25/iterm2-window-arrangements.html` |
| `https://orlenko.github.io/blog/2026/04/22/receipt-scanner.html` | `https://bjola.org/2026/04/22/receipt-scanner.html` |
| `https://orlenko.github.io/blog/2026/05/04/undrudge.html` | `https://bjola.org/2026/05/04/undrudge.html` |
| `https://orlenko.github.io/blog/2026/06/16/claude-tells-me-from-the-next-room.html` | `https://bjola.org/2026/06/16/claude-tells-me-from-the-next-room.html` |
| `https://orlenko.github.io/blog/2026/06/16/scan2speech.html` | `https://bjola.org/2026/06/16/scan2speech.html` |
| `https://orlenko.github.io/blog/2026/06/16/what-was-image-4-again.html` | `https://bjola.org/2026/06/16/what-was-image-4-again.html` |

Also verify the old homepage and feed, `https://bjola.org/notes/`, `www`, HTTPS,
canonicals, share-card images, the sitemap, and at least one unrelated
`orlenko.github.io` project site.

## Rollback

If GitHub does not preserve the legacy paths or another project site changes
host unexpectedly, remove the custom domain from `orlenko/blog`, restore the
previous DNS records, and revert the launch commit together.
