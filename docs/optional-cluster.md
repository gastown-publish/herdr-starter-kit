# Optional: more than one Mac

Start with one Mac. Add another only when the first setup is boring and backed up.

Shape, when you are ready:

- One machine holds the active master. A second machine can take over if you write that down and test it.
- A deploy copies agent settings outward. It does not copy secrets. Keep the list of machines in a local file that is gitignored (`hosts` is already ignored).
- Change the template first, then the other machines.
- Do not restart a remote Mac until you have proved it comes back by itself: disk unlock, network, remote login, and the agent tools starting at login.

`examples/jobs.json` shows two harmless recurring jobs: a disk warning and a reminder to push the tracker. Replace the commands with ones that exist on your machine. Do not commit a job that calls a private host.
