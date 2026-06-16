#!/usr/bin/env bash
# Generate 1200x630 Open Graph share cards — one per blog post, plus a home card.
# Each card = an existing background photo + a dark gradient + the post title.
# Runs in CI before the Jekyll build; output lands in assets/og/ (gitignored), so
# every post automatically gets a post-specific social preview with zero effort.
#
# Usage: bash scripts/gen-og-cards.sh
# Requires ImageMagick ('magick' for v7, or 'convert' for v6). Override the title
# font with OG_FONT=/path/to/font.ttf if you want something other than the default.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
POSTS_DIR="$ROOT/_posts"
BG_DIR="$ROOT/assets/backgrounds"
OUT_DIR="$ROOT/assets/og"

# ImageMagick binary: prefer v7 'magick', fall back to v6 'convert'.
if command -v magick >/dev/null 2>&1; then IM="magick"
elif command -v convert >/dev/null 2>&1; then IM="convert"
else echo "ERROR: ImageMagick not found (need 'magick' or 'convert')." >&2; exit 1
fi

# Title font: prefer Inter, then DejaVu / Arial, else ImageMagick's default.
FONT="${OG_FONT:-}"
if [ -z "$FONT" ]; then
  for f in \
    /usr/share/fonts/truetype/inter/Inter-Bold.ttf \
    /usr/share/fonts/opentype/inter/Inter-Bold.otf \
    /usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf \
    "/System/Library/Fonts/Supplemental/Arial Bold.ttf" \
    "/Library/Fonts/Arial.ttf"; do
    [ -f "$f" ] && FONT="$f" && break
  done
fi
font_args=(); [ -n "$FONT" ] && font_args=(-font "$FONT")

mkdir -p "$OUT_DIR"

# Collect background photos (jpg/JPG), sorted so the pick is deterministic.
shopt -s nullglob nocaseglob
bgs=("$BG_DIR"/*.jpg)
shopt -u nocaseglob
IFS=$'\n' bgs=($(printf '%s\n' "${bgs[@]}" | sort)); unset IFS
bg_count=${#bgs[@]}

pick_bg() { # $1 = key -> echoes a deterministic background path (empty if none)
  [ "$bg_count" -eq 0 ] && return 0
  local n; n=$(printf '%s' "$1" | cksum | cut -d' ' -f1)
  echo "${bgs[$(( n % bg_count ))]}"
}

make_card() { # $1=out  $2=bg(may be empty)  $3=title
  local out="$1" bg="$2" title="$3"
  local base
  if [ -n "$bg" ] && [ -f "$bg" ]; then
    base=("$bg" -resize 1200x630^ -gravity center -extent 1200x630)
  else
    base=(-size 1200x630 "xc:#1c1917")
  fi
  "$IM" "${base[@]}" \
    \( -size 1200x630 gradient:'rgba(28,25,23,0.15)'-'rgba(28,25,23,0.88)' \) \
       -compose over -composite \
    "${font_args[@]}" \
    \( -background none -fill 'rgba(255,255,255,0.82)' -pointsize 30 -size 1040x \
       -gravity northwest caption:'Brain Dump Blog' \) \
       -gravity northwest -geometry +80+64 -compose over -composite \
    \( -background none -fill white -pointsize 58 -size 1040x \
       -gravity southwest caption:"$title" \) \
       -gravity southwest -geometry +80+88 -compose over -composite \
    "$out"
}

# Home card.
make_card "$OUT_DIR/home.png" "$(pick_bg home)" \
  "An experimental, zero-friction blog. Dictation to the web."
echo "  wrote assets/og/home.png"

# One card per post.
shopt -s nullglob
count=0
for f in "$POSTS_DIR"/*.md; do
  base="$(basename "$f" .md)"
  slug="$(printf '%s' "$base" | sed -E 's/^[0-9]{4}-[0-9]{2}-[0-9]{2}-//')"
  title="$(grep -m1 '^title:' "$f" | sed -E 's/^title:[[:space:]]*//; s/^"//; s/"$//')"
  [ -z "$title" ] && title="$slug"
  make_card "$OUT_DIR/$slug.png" "$(pick_bg "$slug")" "$title"
  echo "  wrote assets/og/$slug.png  <-  $title"
  count=$((count + 1))
done

echo "Generated $count post card(s) + home card into assets/og/"
