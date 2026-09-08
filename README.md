# Bjola.org

Bjola's Notes site and open-source project catalogue. Built with Jekyll and
deployed to GitHub Pages.

The homepage lists all notes, newest first. `/notes/` keeps the same view for
existing links; `/projects/` holds the project catalogue.

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

Tool posts include a `project:` mapping in their frontmatter. Jekyll features
the newest published tool post on `/projects/`, links to its generated URL,
and keeps earlier tools in the project list. It uses the newest post for each
project ID and avoids duplicates with `_data/projects.yml`. Ordinary notes and
drafts do not change the lead project.

Use `_posts/2026-09-08-the-show-must-go-on.md` as the metadata example. No
separate homepage or catalogue edit is needed. The normal Pages CI build
updates both pages and tests the Notes homepage, project promotion, ordering,
duplicate handling, and draft exclusion first. Run those checks locally with:

```sh
bundle exec ruby scripts/test-homepage.rb
```
