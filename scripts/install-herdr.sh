#!/bin/bash
# Install Herdr from the upstream stable installer when it is not already on PATH.
# Source and licence: https://github.com/herdrdev/herdr (Apache-2.0).
set -euo pipefail
if command -v herdr >/dev/null 2>&1; then
  herdr --version
  exit 0
fi
os=$(uname -s)
case "$os" in
  Linux|Darwin) ;;
  *)
    echo "install-herdr.sh supports Linux and macOS (this system is $os)" >&2
    exit 2
    ;;
esac
need() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "need $1" >&2
    exit 2
  }
}
need curl
curl -fsSL https://herdr.dev/install.sh | sh
if ! command -v herdr >/dev/null 2>&1; then
  export PATH="$HOME/.local/bin:$PATH"
fi
command -v herdr >/dev/null 2>&1 || {
  echo "herdr is not on PATH after install; add ~/.local/bin to PATH" >&2
  exit 1
}
herdr --version
