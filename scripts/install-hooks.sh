#!/bin/sh
set -eu
cd "$(git rev-parse --show-toplevel)"
current=$(git config --get core.hooksPath || true)
if [ -n "$current" ] && [ "$current" != ".githooks" ]; then
  echo "Existing core.hooksPath=$current; add the thumbnail hook to that setup instead of replacing it." >&2
  exit 1
fi
if [ -f .git/hooks/pre-commit ]; then
  echo "Existing .git/hooks/pre-commit; integrate it with .githooks/pre-commit first." >&2
  exit 1
fi
git config --local core.hooksPath .githooks
echo "Installed thumbnail pre-commit hook for this checkout."
