# Bjola.org

The Bjola open-source project ledger and Notes site. Built with Jekyll and
deployed to GitHub Pages.

## Run locally

```sh
bundle install
bundle exec jekyll serve --livereload
```

Open <http://127.0.0.1:4000>.

## Build

```sh
bash scripts/gen-og-cards.sh
JEKYLL_ENV=production bundle exec jekyll build
```

## Publish a note

Add `_posts/YYYY-MM-DD-slug.md` with title and full timestamp frontmatter, then
commit and push to `main`. See `CLAUDE.md` for the writing and publishing
contract.
