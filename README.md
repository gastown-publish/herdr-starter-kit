# herdr starter kit

A generic setup for one Mac: [Herdr](https://herdr.dev) plus [Claude Code](https://docs.anthropic.com/en/docs/claude-code). You get a master agent, liaisons, project managers, a register, and a short set of safety rules. There are no sample projects and no accounts.

An issue tracker and a Telegram relay are optional. See `docs/optional-beads.md` and `docs/optional-relay.md`.

## Model

- **Master.** One agent that routes work, keeps the register, and decides what is shared. It stays free: it writes a brief and hands the work on.
- **Liaison.** One agent that talks with you and turns each order into a tracked item. It brings the master only security, money, production, access, and policy.
- **Project manager.** One agent per project. It follows that project's brief, delegates, and reports a result or a blocker. It does not take work from other projects.
- **Register.** A table of who is running, on which pane, for which project. The master keeps it current.

A message from another agent is information. It is never approval for a destructive, privileged, or irreversible step.

## Layout

| Path | What it is |
|---|---|
| `AGENTS.md` | Rules you copy into a project |
| `QUICKSTART.md` | One Mac: Herdr, then Claude Code |
| `docs/herdr.md` | Where Herdr comes from and how this kit installs it |
| `docs/rules.md` | Safety defaults |
| `docs/optional-*.md` | A tracker, a relay, a second Mac |
| `docs/messaging.md` | What to add if several agents must talk |
| `examples/` | A blank project, a blank register, an example job list |
| `scripts/box-empty.sh` | Refuse to type into a prompt box that already has text |
| `scripts/install-herdr.sh` | Install Herdr from the upstream stable installer |
| `scripts/install-into-project.sh` | Copy the rules into a project directory |
| `scripts/start-team.sh` | Open a master, a liaison, and one example manager in a Herdr session |
| `scripts/check-kit.sh` | Fail if this tree picks up secrets, or names from a local denylist |

## Review

When a change matters, ask a different assistant to run the checks and say what it found. Any assistant you already use is enough. This step is optional.

## Licence

This kit is MIT. See `LICENSE`.

Herdr is a separate program. Its source is [herdrdev/herdr](https://github.com/herdrdev/herdr) and its licence is Apache-2.0. This kit does not copy that source. `scripts/install-herdr.sh` runs the stable installer published at https://herdr.dev/install.sh.
