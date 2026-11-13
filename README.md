# Railway Session Generator Diagnostic

Tests whether the known `nodriver.start` root/sandbox configuration causes token-generation failures.

## Deploy

1. Unzip and create a **new private GitHub repo**, e.g. `session-generator-test`; upload the `Dockerfile` at the repository root.
2. On Railway `sublime-optimism` -> Settings -> Source, change source from Docker Image to that GitHub repo. Railway should auto-detect `Dockerfile`. Leave the listening port at 8080.
3. Keep the original Cobalt and MuzikaPlay deployments unchanged. In Cobalt, `YOUTUBE_SESSION_SERVER` should use `http://sublime-optimism.railway.internal:8080/` (base URL, not `/token`).
4. Deploy and check logs for `update was successful` and `/token` returns HTTP 200. If token generation still times out, this hypothesis was not sufficient.
5. Remove the public domain from the session generator after testing; the token endpoint should remain private.

## Security

This is a *diagnostic* because `no_sandbox=True` disables Chromium's process sandbox. Only use inside an isolated container with no secrets and no public API access. Prefer running Chromium as non-root with a supported sandbox for a production service.

## Rollback

Change the `sublime-optimism` Railway source back to Docker Image: `ghcr.io/imputnet/yt-session-generator:webserver`.
