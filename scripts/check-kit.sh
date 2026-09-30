#!/bin/bash
# Fail when this tree contains secret shapes, or names from a local denylist.
# The denylist is not in this repo. Point CHECK_KIT_DENYLIST at a file, or use
# ~/.config/herdr-starter-kit/denylist. One word per line. Lines starting with # are ignored.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"
missing=0
for f in LICENSE README.md QUICKSTART.md AGENTS.md docs/rules.md docs/messaging.md \
  docs/herdr.md docs/optional-beads.md docs/optional-relay.md docs/optional-cluster.md \
  examples/register.md examples/project.md examples/jobs.json scripts/box-empty.sh \
  scripts/install-herdr.sh scripts/install-into-project.sh scripts/start-team.sh; do
  if [ ! -f "$f" ]; then
    echo "missing $f" >&2
    missing=1
  fi
done
[ "$missing" = 0 ] || exit 1

scan() {
  pattern=$1
  label=$2
  skip=${3:-}
  found=0
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    [ "$f" = "$skip" ] && continue
    set +e
    grep -n -E -i -e "$pattern" "$f"
    status=$?
    set -e
    if [ "$status" -eq 0 ]; then
      found=1
    elif [ "$status" -gt 1 ]; then
      echo "grep failed on $f" >&2
      exit 1
    fi
  done <<EOF
$(find . -path ./.git -prune -o -type f -print)
EOF
  if [ "$found" -ne 0 ]; then
    echo "$label" >&2
    exit 1
  fi
}

# Skip this file: the pattern line contains the markers it searches for.
scan 'AKIA[0-9A-Z]{16}|-----BEGIN |xox[baprs]-|ghp_[A-Za-z0-9]{20,}|github_pat_|sk-[A-Za-z0-9]{20,}|hm-[a-z0-9]{4,}' \
  'secret-shaped text found' \
  ./scripts/check-kit.sh

deny=${CHECK_KIT_DENYLIST:-}
if [ -z "$deny" ] && [ -f "${HOME}/.config/herdr-starter-kit/denylist" ]; then
  deny="${HOME}/.config/herdr-starter-kit/denylist"
fi
if [ -n "$deny" ]; then
  if [ ! -f "$deny" ]; then
    echo "denylist not found: $deny" >&2
    exit 1
  fi
  words=$(grep -v '^[[:space:]]*#' "$deny" | grep -v '^[[:space:]]*$' | tr '\n' '|' | sed 's/|$//')
  if [ -z "$words" ]; then
    echo "denylist is empty: $deny" >&2
    exit 1
  fi
  scan "([^[:alnum:]_]|^)(${words})([^[:alnum:]_]|$)" 'blocked name found'
  echo "check-kit: ok (denylist $(basename "$deny"))"
else
  echo "check-kit: ok (no denylist; secret scan only)"
fi
