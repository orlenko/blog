#!/usr/bin/env python3
"""Generate committed previews from indexed assets, never unstaged image edits."""

import argparse
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile

MANIFEST = "_data/thumbnails.json"
OUTPUT = "assets/thumbs/"
EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp", ".avif", ".tif", ".tiff", ".bmp"}
RECIPE = "webp-400x400-fit-no-upscale-auto-orient-srgb-strip-q80-v1"


def git(*args, data=None):
    return subprocess.check_output(["git", *args], input=data)


def digest(data):
    return hashlib.sha256(data).hexdigest()


def index():
    entries = {}
    for record in git("ls-files", "--stage", "-z").split(b"\0"):
        if not record:
            continue
        info, name = record.split(b"\t", 1)
        mode, oid, stage = info.decode().split()
        if stage != "0":
            raise ValueError("Resolve merge conflicts before generating thumbnails.")
        entries[os.fsdecode(name)] = (mode, oid)
    return entries


def blob(entries, path):
    return git("cat-file", "blob", entries[path][1]) if path in entries else None


def generate(data, suffix):
    command = shutil.which("magick") or shutil.which("convert")
    if not command:
        raise ValueError("Install ImageMagick (brew install imagemagick / apt install imagemagick).")
    with tempfile.TemporaryDirectory(prefix="bjola-thumb-") as folder:
        source = Path(folder, "source" + suffix)
        target = Path(folder, "thumb.webp")
        source.write_bytes(data)
        result = subprocess.run(
            [command, str(source) + "[0]", "-auto-orient", "-colorspace", "sRGB",
             "-resize", "400x400>", "-strip", "-quality", "80",
             "-write", str(target), "-format", "%w %h", "info:"],
            check=True, stdout=subprocess.PIPE,
        )
        width, height = map(int, result.stdout.split())
        return target.read_bytes(), width, height


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group()
    mode.add_argument("--stage", action="store_true", help="stage only generated files (pre-commit)")
    mode.add_argument("--check", action="store_true", help="verify committed/staged previews without writes")
    args = parser.parse_args()
    os.chdir(os.fsdecode(git("rev-parse", "--show-toplevel")).strip())
    entries = index()
    sources = sorted(p for p in entries if p.startswith("assets/")
                     and not p.startswith((OUTPUT, "assets/og/"))
                     and Path(p).suffix.lower() in EXTENSIONS)
    old_bytes = blob(entries, MANIFEST)
    old = json.loads(old_bytes) if old_bytes else {}
    images, changes, errors = {}, {}, []
    for source in sources:
        if entries[source][0] not in {"100644", "100755"}:
            raise ValueError(f"Image must be a regular file: {source}")
        data = blob(entries, source)
        url = "/" + source
        output = OUTPUT + source.removeprefix("assets/") + ".webp"
        previous = old.get("images", {}).get(url, {})
        thumbnail = blob(entries, output)
        current = (old.get("recipe") == RECIPE
                   and previous.get("source_sha256") == digest(data)
                   and previous.get("src") == "/" + output
                   and thumbnail is not None
                   and previous.get("sha256") == digest(thumbnail)
                   and 0 < previous.get("width", 0) <= 400
                   and 0 < previous.get("height", 0) <= 400)
        if current:
            images[url] = previous
        elif args.check:
            errors.append(f"Missing or stale thumbnail: {source}")
        else:
            thumbnail, width, height = generate(data, Path(source).suffix)
            images[url] = {"src": "/" + output, "width": width, "height": height,
                           "source_sha256": digest(data), "sha256": digest(thumbnail)}
            changes[output] = thumbnail

    expected = {entry["src"].lstrip("/") for entry in images.values()}
    # In check mode stale entries already have a useful diagnostic above.
    orphaned = {p for p in entries if p.startswith(OUTPUT)} - expected
    manifest = (json.dumps({"recipe": RECIPE, "images": images}, indent=2, sort_keys=True) + "\n").encode()
    if args.check:
        if old_bytes != manifest or orphaned:
            errors.append("Thumbnail manifest or generated file set is out of date.")
        if errors:
            raise ValueError("\n".join(errors) + "\nStage the source images, then run python3 scripts/gen-thumbnails.py --stage.")
        print(f"Verified {len(sources)} indexed thumbnails.")
        return

    changes.update({p: None for p in orphaned})
    if manifest != old_bytes:
        changes[MANIFEST] = manifest
    changes = {p: data for p, data in changes.items() if data != blob(entries, p)}
    # Check every target before writing any, so a partial commit cannot overwrite
    # unrelated work, even if someone has edited a generated file manually.
    for name, data in changes.items():
        path = Path(name)
        if path.is_symlink():
            raise ValueError(f"Refusing to overwrite symlink: {name}")
        if path.exists() and path.read_bytes() not in (blob(entries, name), data):
            raise ValueError(f"Unstaged changes in generated file: {name}; save or revert them first.")
    for name, data in changes.items():
        path = Path(name)
        if data is None:
            path.unlink(missing_ok=True)
        else:
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(data)
        if args.stage:
            git("add", "--", name)
    print(f"Thumbnails: {len(sources)} images, {len(changes)} generated files updated"
          + (" and staged." if args.stage else "."))


if __name__ == "__main__":
    try:
        main()
    except (ValueError, OSError, subprocess.CalledProcessError) as error:
        print(f"thumbnails: {error}", file=sys.stderr)
        sys.exit(1)
