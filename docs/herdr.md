# Herdr

Herdr is the workspace this kit runs in. Install it before the project rules.

Source: [herdrdev/herdr](https://github.com/herdrdev/herdr). Licence: Apache-2.0. This kit does not copy that source. It installs the published binary.

On Linux or macOS the kit runs the upstream installer:

```sh
bash scripts/install-herdr.sh
```

That script does nothing if `herdr` is already on `PATH`. Otherwise it runs the official installer from https://herdr.dev/install.sh, which puts the stable-channel binary in `~/.local/bin`. Add that directory to `PATH` if the installer says to.

If you already use Homebrew:

```sh
brew install herdr
```

Check:

```sh
herdr --version
```

Then open a session with `herdr`, put the master and the liaison on the first tab, and put each project manager in its own pane. Name agents `<project>-<role>` in lower case with hyphens. Open a new pane to the right. Before you type into a pane, run `scripts/box-empty.sh <pane>`.

Do not restart the Herdr server, close a pane, or stop an agent that is working, unless the person asked.

A second machine is in `docs/optional-cluster.md`. An issue tracker and a chat relay stay optional.
