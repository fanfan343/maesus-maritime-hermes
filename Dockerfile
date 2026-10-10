FROM nousresearch/hermes-agent:v0.21.6

# Upstream keeps the `hermes` shim only in /opt/hermes/bin, and the
# s6-overlay default PATH (/command:/usr/bin:/bin) does not include it.
# Maritime's legacy-services start `hermes` by bare name, so expose the
# same shim on /usr/bin, which is on that PATH.
RUN ln -sf /opt/hermes/bin/hermes /usr/bin/hermes && command -v hermes

# Maritime's public URL strips the /a/<id> prefix before forwarding, but Hermes
# binds its Telegram webhook listener to the full webhook URL path, so every
# update gets a 404. TELEGRAM_WEBHOOK_PATH overrides the listener path, and the
# Telegram-registered URL stays the public one. Also keep queued updates when
# the VM wakes from sleep. Each substitution is asserted to match.
RUN set -e; f=/opt/hermes/plugins/platforms/telegram/adapter.py; \
    sed -i 's|webhook_path = urlparse(webhook_url).path or "/telegram"|webhook_path = os.environ.get("TELEGRAM_WEBHOOK_PATH") or urlparse(webhook_url).path or "/telegram"|' "$f"; \
    sed -i 's|self._coerce_bool_extra("drop_pending_on_cold_boot", True)|self._coerce_bool_extra("drop_pending_on_cold_boot", False)|' "$f"; \
    grep -q 'TELEGRAM_WEBHOOK_PATH' "$f"; \
    grep -q '"drop_pending_on_cold_boot", False' "$f"
