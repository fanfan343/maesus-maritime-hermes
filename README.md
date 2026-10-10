# maesus-maritime-hermes

Dockerfile for running Hermes Agent on Maritime (`--source github`).

- Base: `nousresearch/hermes-agent:v0.21.6` (pinned in the Dockerfile `FROM` line).
- Fix: symlink `/usr/bin/hermes` to the upstream shim so Maritime's
  legacy-services can start `hermes` by name.

Update: change the tag in the `FROM` line, commit, then run
`maritime deploy maesus-maritime --source github --repo https://github.com/fanfan343/maesus-maritime-hermes --branch main`.
Roll back by restoring the previous tag, or deploy the Maritime template image.
No secrets live in this repo; keys go through `maritime env set`.
