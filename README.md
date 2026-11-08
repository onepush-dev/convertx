# ConvertX on Railway — self-hosted file converter, owner account pre-created

ConvertX converts 1000+ file formats (images, video, audio, documents, ebooks, 3D, vector) in the browser, using FFmpeg, ImageMagick, LibreOffice, Pandoc, Calibre, Inkscape and more. Deploy on Railway with one click.

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/g7chIc)

Built from the official image `ghcr.io/c4illin/convertx:v0.20.0` (app unmodified). Upstream: https://github.com/C4illin/ConvertX

## Why this template

Upstream ConvertX lets **the first visitor register** an account even with `ACCOUNT_REGISTRATION=false`. On a public Railway domain that is a race. This packaging creates the owner account from a per-deploy generated password on a private port **before** the public port opens, so the instance is never claimable. Registration stays closed and unauthenticated use stays off.

## After deploy

1. Open the service's **Variables** tab and copy `CONVERTX_ADMIN_PASSWORD`.
2. Sign in at your Railway domain with `admin@example.com` and that password.
3. Change the email/password in **Account**.

## Variables

| Variable | Default | Purpose |
|---|---|---|
| `JWT_SECRET` | generated (`secret(64)`) | Signs login session tokens; keep it stable so sessions survive redeploys. |
| `CONVERTX_ADMIN_PASSWORD` | generated | Password of the owner account created on first boot. |
| `CONVERTX_ADMIN_EMAIL` | `admin@example.com` (image default) | Email/login of the owner account. |
| `ACCOUNT_REGISTRATION` | `false` (image default) | Keep false on a public URL. |
| `ALLOW_UNAUTHENTICATED` | `false` (image default) | Keep false on a public URL. |
| `AUTO_DELETE_EVERY_N_HOURS` | `24` (image default) | Deletes converted files older than N hours. |

Data (SQLite database, uploads, outputs) lives on the Railway volume at `/app/data`.

## License

ConvertX is AGPL-3.0. This repository only adds a Dockerfile and `railway-start.sh`.
