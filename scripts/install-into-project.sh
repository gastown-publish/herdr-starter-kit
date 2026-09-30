#!/bin/bash
# Copy the starter rules into a project directory. Refuses to overwrite AGENTS.md.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
dest=${1:-}
if [ -z "$dest" ]; then
  echo "usage: install-into-project.sh DEST_DIR" >&2
  exit 2
fi
mkdir -p "$dest/docs" "$dest/examples" "$dest/scripts"
if [ -e "$dest/AGENTS.md" ]; then
  echo "AGENTS.md already exists in $dest; leave it in place" >&2
  exit 1
fi
cp "$root/AGENTS.md" "$dest/AGENTS.md"
cp "$root/docs/rules.md" "$dest/docs/rules.md"
cp "$root/examples/register.md" "$dest/examples/register.md"
cp "$root/examples/project.md" "$dest/examples/project.md"
cp "$root/scripts/box-empty.sh" "$dest/scripts/box-empty.sh"
chmod +x "$dest/scripts/box-empty.sh"
echo "installed into $dest"
echo "next: open that directory in Claude Code and set permissions.disableAutoMode to disable"
