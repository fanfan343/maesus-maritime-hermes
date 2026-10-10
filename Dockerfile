# Pinned upstream Hermes image plus one compatibility fix for Maritime.
# Upstream keeps the `hermes` shim only in /opt/hermes/bin, and the
# s6-overlay default PATH (/command:/usr/bin:/bin) does not include it.
# Maritime's legacy-services start `hermes` by bare name, so expose the
# same shim on /usr/bin, which is on that PATH.
ARG HERMES_TAG=v0.21.6
FROM nousresearch/hermes-agent:${HERMES_TAG}
RUN ln -sf /opt/hermes/bin/hermes /usr/bin/hermes && command -v /usr/bin/hermes
EOF'
cat > README.md <<'EOF'
# maesus-maritime-hermes

Dockerfile for running Hermes Agent on Maritime (`--source github`).

- Base: `nousresearch/hermes-agent:<HERMES_TAG>` (default in Dockerfile).
- Fix: symlink `/usr/bin/hermes` to the upstream shim so Maritime's
  legacy-services can start `hermes` by name.

Update: change `HERMES_TAG` in the Dockerfile, commit, then
`maritime deploy maesus-maritime --source github --repo <this repo> --branch main`.
Roll back by restoring the previous tag, or deploy the Maritime template image.
No secrets live in this repo; keys go through `maritime env set`.
