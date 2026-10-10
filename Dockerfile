FROM nousresearch/hermes-agent:v0.21.6

# Upstream keeps the `hermes` shim only in /opt/hermes/bin, and the
# s6-overlay default PATH (/command:/usr/bin:/bin) does not include it.
# Maritime's legacy-services start `hermes` by bare name, so expose the
# same shim on /usr/bin, which is on that PATH.
RUN ln -sf /opt/hermes/bin/hermes /usr/bin/hermes && command -v hermes
