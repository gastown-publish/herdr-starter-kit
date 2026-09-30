#!/bin/bash
# Open a master, one liaison, and one example project manager in a Herdr session.
# Uses a named session so the default session is left alone.
# The session server must already be running:
#   herdr session attach herdr-starter
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
session=${1:-${HERDR_STARTER_SESSION:-herdr-starter}}
if ! command -v herdr >/dev/null 2>&1; then
  echo "herdr is not on PATH; run scripts/install-herdr.sh" >&2
  exit 2
fi
if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required to read herdr's JSON" >&2
  exit 2
fi

h() { herdr --session "$session" "$@"; }

if ! h workspace list >/dev/null; then
  echo "no server for session $session" >&2
  echo "in a terminal, run: herdr session attach $session" >&2
  exit 2
fi

cwd=$root
ws=$(h workspace list | python3 -c 'import json,sys; d=json.load(sys.stdin); ws=d["result"]["workspaces"]; print(ws[0]["workspace_id"] if ws else "")')
if [ -z "$ws" ]; then
  h workspace create --label team --cwd "$cwd" --no-focus >/dev/null
  ws=$(h workspace list | python3 -c 'import json,sys; d=json.load(sys.stdin); print(d["result"]["workspaces"][0]["workspace_id"])')
fi

pane_count() {
  h pane list --workspace "$ws" | python3 -c 'import json,sys; print(len(json.load(sys.stdin)["result"]["panes"]))'
}
first_pane() {
  h pane list --workspace "$ws" | python3 -c 'import json,sys; print(json.load(sys.stdin)["result"]["panes"][0]["pane_id"])'
}
while [ "$(pane_count)" -lt 3 ]; do
  h pane split --pane "$(first_pane)" --direction right --cwd "$cwd" --no-focus >/dev/null
done

ids=$(h pane list --workspace "$ws" | python3 -c 'import json,sys; ps=json.load(sys.stdin)["result"]["panes"]; print(" ".join(p["pane_id"] for p in ps[:3]))')
# shellcheck disable=SC2086
set -- $ids
master=$1
liaison=$2
manager=$3

h pane rename "$master" master >/dev/null 2>&1 || true
h pane rename "$liaison" liaison >/dev/null 2>&1 || true
h pane rename "$manager" example-manager >/dev/null 2>&1 || true

start_one() {
  name=$1
  pane=$2
  brief=$3
  h agent start "$name" --kind claude --pane "$pane" --timeout 60000
  h agent prompt "$name" "$brief"
}

start_one master "$master" "You are the master. Read AGENTS.md in this directory. Route work to the liaison or a project manager. Do not do the project work yourself."
start_one liaison "$liaison" "You are the liaison. Read AGENTS.md. Turn each human order into a tracked item and follow it. Bring the master only security, money, production, access, or policy."
start_one example-manager "$manager" "You are example-manager. Read examples/project.md. Own that one project only. Report one result or one blocker."

echo "session $session"
echo "master $master"
echo "liaison $liaison"
echo "example-manager $manager"
