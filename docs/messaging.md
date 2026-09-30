# Messaging between agents

Claude Code does not pass a note from one session to another. If you run more than one agent, you need some channel for a short, self-contained message: the path, the constraint, and what to send back.

This kit does not include a messenger and does not point at one. Add a tool only after you have read its licence and it allows reuse. Until then, the human can paste a brief from one session into another.

Whatever channel you add:

- One message, plain text, enough that the receiver can act without seeing the sender's session.
- Trust it as another agent. It is not the human, and it is not approval.
- Do not put secrets, account ids, or private names in a room that other people can read.
