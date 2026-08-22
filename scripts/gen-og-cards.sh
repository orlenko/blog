#!/usr/bin/env bash
# Generate one 1200x630 Open Graph card per post, plus the site home card.
# The composition uses only repository assets and system fonts, so CI does not
# depend on the old untracked background-photo collection.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
POSTS_DIR="$ROOT/_posts"
OUT_DIR="$ROOT/assets/og"
LOGO="$ROOT/assets/images/bjola_logo.png"

if command -v magick >/dev/null 2>&1; then IM="magick"
elif command -v convert >/dev/null 2>&1; then IM="convert"
else echo "ERROR: ImageMagick not found (need 'magick' or 'convert')." >&2; exit 1
fi

FONT_BOLD="${OG_FONT_BOLD:-}"
FONT_MONO="${OG_FONT_MONO:-}"

if [ -z "$FONT_BOLD" ]; then
  for f in \
    /usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf \
    "/System/Library/Fonts/Supplemental/Arial Bold.ttf" \
    "/Library/Fonts/Arial Bold.ttf"; do
    [ -f "$f" ] && FONT_BOLD="$f" && break
  done
fi

if [ -z "$FONT_MONO" ]; then
  for f in \
    /usr/share/fonts/truetype/dejavu/DejaVuSansMono-Bold.ttf \
    "/System/Library/Fonts/Supplemental/Courier New Bold.ttf"; do
    [ -f "$f" ] && FONT_MONO="$f" && break
  done
fi

bold_args=(); [ -n "$FONT_BOLD" ] && bold_args=(-font "$FONT_BOLD")
mono_args=(); [ -n "$FONT_MONO" ] && mono_args=(-font "$FONT_MONO")

mkdir -p "$OUT_DIR"

make_card() { # $1=output $2=section label $3=title
  local out="$1" section="$2" title="$3"

  "$IM" -size 1200x630 xc:'#F3EFE5' \
    -fill '#164A9B' -draw 'rectangle 0,0 86,630' \
    -fill '#171715' -draw 'rectangle 86,0 88,630' \
    -fill '#F2B84B' -draw 'rectangle 88,0 344,24' \
    -stroke '#B8B1A1' -strokewidth 1 -fill none \
      -draw 'line 140,120 1060,120 line 140,516 1060,516' \
    "${mono_args[@]}" \
    \( -background none -fill '#5C5A54' -pointsize 25 -size 760x \
       -gravity northwest caption:"BJOLA SOFTWARE / $section" \) \
       -gravity northwest -geometry +140+68 -compose over -composite \
    "${bold_args[@]}" \
    \( -background none -fill '#171715' -pointsize 63 -size 850x330 \
       -gravity west caption:"$title" \) \
       -gravity northwest -geometry +140+150 -compose over -composite \
    "${mono_args[@]}" \
    \( -background none -fill '#A43F13' -pointsize 22 -size 760x \
       -gravity northwest caption:'BJOLA.ORG / SOURCE + NOTES' \) \
       -gravity northwest -geometry +140+544 -compose over -composite \
    \( "$LOGO" -resize 112x106 \) \
       -gravity northeast -geometry +54+42 -compose over -composite \
    "$out"
}

make_card "$OUT_DIR/home.png" "PROJECT LEDGER" \
  "Tools I needed, then made public."
echo "  wrote assets/og/home.png"

shopt -s nullglob
count=0
for f in "$POSTS_DIR"/*.md; do
  base="$(basename "$f" .md)"
  slug="$(printf '%s' "$base" | sed -E 's/^[0-9]{4}-[0-9]{2}-[0-9]{2}-//')"
  title="$(grep -m1 '^title:' "$f" | sed -E 's/^title:[[:space:]]*//; s/^"//; s/"$//')"
  [ -z "$title" ] && title="$slug"
  make_card "$OUT_DIR/$base.png" "FIELD NOTES" "$title"
  echo "  wrote assets/og/$base.png  <-  $title"
  count=$((count + 1))
done

echo "Generated $count post card(s) + home card into assets/og/"
