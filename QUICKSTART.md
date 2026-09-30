# Quickstart (one Mac)

You need macOS or Linux, Git, curl, and Claude Code. Herdr is installed in step 2.

1. Clone this repo and stay in it.
2. Install Herdr (Apache-2.0, from [herdrdev/herdr](https://github.com/herdrdev/herdr)). Skip if `herdr` is already on your `PATH`:

   ```sh
   bash scripts/install-herdr.sh
   ```

3. Install the rules into an empty project directory:

   ```sh
   bash scripts/install-into-project.sh "$HOME/projects/my-setup"
   ```

4. Start Herdr (`herdr`), open that directory in a Claude Code pane. `AGENTS.md` is the instruction file.
5. In Claude Code settings, set auto mode off:

   ```json
   { "permissions": { "disableAutoMode": "disable" } }
   ```

6. Copy `examples/register.md` into the project and fill one row for the master.
7. Copy `examples/project.md` once per real project. Leave secrets out of every file you commit.
8. In a terminal, start a Herdr session, then open the three starters:

   ```sh
   herdr session attach herdr-starter
   ```

   In another terminal, from this repo:

   ```sh
   bash scripts/start-team.sh
   ```

   That opens a master pane, one liaison, and one example project manager, each with a one-line brief. It uses `herdr --session` and does not touch any other session.

Check the tree before you share it:

```sh
bash scripts/check-kit.sh
```

Herdr itself is `docs/herdr.md`. Optional later: `docs/optional-beads.md`, `docs/optional-relay.md`, `docs/optional-cluster.md`.
