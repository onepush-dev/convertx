# Railway packaging of the official ConvertX v0.20.0 image (unmodified app).
# Adds a start wrapper that creates the owner account from per-deploy
# credentials before the public port opens, so nobody else can claim it.
FROM ghcr.io/c4illin/convertx:v0.20.0@sha256:6259e0c1e063120b1ddbc6937372a83be58182b2c9dc82264f58e100907b3e51
COPY railway-start.sh /railway-start.sh
RUN chmod 0755 /railway-start.sh
ENV PORT=3000 \
    ACCOUNT_REGISTRATION=false \
    ALLOW_UNAUTHENTICATED=false \
    HTTP_ALLOWED=false \
    AUTO_DELETE_EVERY_N_HOURS=24 \
    CONVERTX_ADMIN_EMAIL=admin@example.com \
    TZ=Etc/UTC
ENTRYPOINT ["/railway-start.sh"]
CMD []
