# Bjola.org

Bjola's Notes site and open-source project catalogue. Built with Jekyll and
deployed to GitHub Pages.

The homepage lists all notes, newest first. `/notes/` keeps the same view for
existing links; `/projects/` holds the project catalogue.

## Run locally

Install Python 3.9+ and ImageMagick (`brew install imagemagick` on macOS,
`sudo apt install imagemagick` on Ubuntu), then enable the repo's commit hook
once per checkout:

```sh
sh scripts/install-hooks.sh
```

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

## Image thumbnails

Keep `thumbnail:` frontmatter pointing to the original image in `assets/`.
The Notes homepage and `/notes/` resolve it through `_data/thumbnails.json`
and serve the generated WebP in `assets/thumbs/`. Article images and social
previews keep their original URLs.

The pre-commit hook creates previews for every tracked raster image under
`assets/` (including existing backgrounds), excluding generated thumbs and
OG cards. Previews fit within 400 × 400 pixels without upscaling, preserve
aspect ratio and transparency, correct orientation, and strip metadata.
Animated images use their first frame; SVGs are left as vectors.

Stage new or changed originals normally. The hook reads **the Git index**,
generates only missing or stale previews, removes obsolete previews, and stages
only its generated files and manifest. Unstaged source edits and untracked
uploads are not included. It refuses to overwrite manual edits to generated
files. Existing hooks are not silently replaced by the installer.

To regenerate or check manually:

```sh
python3 scripts/gen-thumbnails.py --stage
python3 scripts/gen-thumbnails.py --check
python3 -m unittest discover -s scripts -p 'test_thumbnails.py'
```

CI checks source and thumbnail hashes, so commits made without the hook cannot
deploy missing or stale previews. Commit the generated files along with their
source images; image conversion is not required when serving the site.

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
