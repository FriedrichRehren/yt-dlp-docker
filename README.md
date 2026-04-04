<div align="center">
  <h1><code>yt-dlp</code> Docker Image</h1>
  <p>Ready-to-use container image for the upstream <code>yt-dlp</code> CLI with <code>ffmpeg</code>, <code>ffprobe</code>, <code>deno</code>, <code>AtomicParsley</code>, and <code>curl_cffi</code> included.</p>
  <p>
    <a href="https://github.com/FriedrichRehren/yt-dlp-docker/actions/workflows/check-upstream-tags.yml"><img alt="Check Upstream Release" src="https://github.com/FriedrichRehren/yt-dlp-docker/actions/workflows/check-upstream-tags.yml/badge.svg?branch=main"></a>
    <a href="https://github.com/FriedrichRehren/yt-dlp-docker/actions/workflows/deploy-tag.yml"><img alt="Deploy Stable Image" src="https://github.com/FriedrichRehren/yt-dlp-docker/actions/workflows/deploy-tag.yml/badge.svg?branch=main"></a>
    <a href="https://github.com/FriedrichRehren/yt-dlp-docker/actions/workflows/deploy-nightly.yml"><img alt="Deploy Nightly Image" src="https://github.com/FriedrichRehren/yt-dlp-docker/actions/workflows/deploy-nightly.yml/badge.svg?branch=main"></a>
  </p>
  <p>
    <a href="https://hub.docker.com/r/friedrichrehren/yt-dlp/tags"><img alt="Current Version" src="https://img.shields.io/docker/v/friedrichrehren/yt-dlp?sort=semver&label=Current%20Version"></a>
    <a href="https://github.com/users/friedrichrehren/packages/container/package/yt-dlp"><img alt="GHCR Pulls" src="https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fghcr-badge.elias.eu.org%2Fapi%2Ffriedrichrehren%2Fyt-dlp&query=downloadCount&label=GHCR%20pulls&color=2ea44f&logo=github"></a>
    <a href="https://hub.docker.com/r/friedrichrehren/yt-dlp"><img alt="Docker Hub Pulls" src="https://img.shields.io/docker/pulls/friedrichrehren/yt-dlp?label=Docker%20Hub%20pulls&logo=docker&logoColor=white"></a>
  </p>
</div>

## Included Tools

| Component | Purpose |
| --- | --- |
| `yt-dlp` | official Linux release binary from `yt-dlp/yt-dlp` |
| `ffmpeg` and `ffprobe` | merging and post-processing |
| `deno` | JavaScript runtime for bundled EJS support |
| `AtomicParsley` | thumbnail embedding fallback for `mp4` and `m4a` |
| `curl_cffi` | browser impersonation support used by some sites |
| non-root user | safer default runtime |
| `linux/amd64` and `linux/arm64` | multi-architecture images |

## Published Images

| Registry | Image |
| --- | --- |
| GHCR | [`ghcr.io/friedrichrehren/yt-dlp`](https://github.com/users/friedrichrehren/packages/container/package/yt-dlp) |
| Docker Hub | [`friedrichrehren/yt-dlp`](https://hub.docker.com/r/friedrichrehren/yt-dlp) |

The `latest` image follows the newest upstream `yt-dlp` release. Versioned image
tags match upstream release tags such as `2026.03.17`. A separate `nightly` tag
is rebuilt from the upstream `nightly` channel on each scheduled run and
replaces the previous `nightly` image.

## What This Project Does

This project watches upstream `yt-dlp` releases and republishes them as Docker
images.

The repository automation:

1. checks `yt-dlp/yt-dlp` once an hour
2. compares the latest upstream release to the image version currently carrying
   the `latest` tag on GHCR
3. triggers a new container build when upstream has moved
4. pushes the resulting release image to GHCR and Docker Hub
5. rebuilds the `nightly` image once per day from the upstream `nightly`
   channel and replaces the previous `nightly` tag

The container itself is intentionally simple. Its entrypoint is `yt-dlp`, so the
image behaves like a containerized `yt-dlp` CLI with the upstream recommended
runtime pieces already present.

## Quick Start

Both registries publish the same tags and multi-arch images. Choose the one you
prefer:

### GHCR

Image: `ghcr.io/friedrichrehren/yt-dlp`

Pull the image from GHCR:

```bash
docker pull ghcr.io/friedrichrehren/yt-dlp:latest
```

Or use the upstream nightly channel tag:

```bash
docker pull ghcr.io/friedrichrehren/yt-dlp:nightly
```

Check the installed version:

```bash
docker run --rm ghcr.io/friedrichrehren/yt-dlp:latest --version
```

### Docker Hub

Image: `friedrichrehren/yt-dlp`

Pull the image from Docker Hub:

```bash
docker pull friedrichrehren/yt-dlp:latest
```

Or use the upstream nightly channel tag:

```bash
docker pull friedrichrehren/yt-dlp:nightly
```

Check the installed version:

```bash
docker run --rm friedrichrehren/yt-dlp:latest --version
```

## How To Use The Image

Because the container entrypoint is already `yt-dlp`, everything after the image
name is passed directly to `yt-dlp`.

### GHCR

Image: `ghcr.io/friedrichrehren/yt-dlp`

Download into a host directory:

```bash
docker run --rm \
  -v /path/to/downloads:/downloads \
  ghcr.io/friedrichrehren/yt-dlp:latest \
  https://www.youtube.com/watch?v=example
```

Use a pinned `yt-dlp` version:

```bash
docker run --rm \
  -v /path/to/downloads:/downloads \
  ghcr.io/friedrichrehren/yt-dlp:2026.03.17 \
  --version
```

Merge audio and video with the bundled `ffmpeg`:

```bash
docker run --rm \
  -v /path/to/downloads:/downloads \
  ghcr.io/friedrichrehren/yt-dlp:latest \
  --format "bv*+ba/b" \
  --merge-output-format mp4 \
  https://www.youtube.com/watch?v=example
```

Extract audio:

```bash
docker run --rm \
  -v /path/to/downloads:/downloads \
  ghcr.io/friedrichrehren/yt-dlp:latest \
  --extract-audio \
  --audio-format mp3 \
  https://www.youtube.com/watch?v=example
```

### Docker Hub

Image: `friedrichrehren/yt-dlp`

Download into a host directory:

```bash
docker run --rm \
  -v /path/to/downloads:/downloads \
  friedrichrehren/yt-dlp:latest \
  https://www.youtube.com/watch?v=example
```

Use a pinned `yt-dlp` version:

```bash
docker run --rm \
  -v /path/to/downloads:/downloads \
  friedrichrehren/yt-dlp:2026.03.17 \
  --version
```

Merge audio and video with the bundled `ffmpeg`:

```bash
docker run --rm \
  -v /path/to/downloads:/downloads \
  friedrichrehren/yt-dlp:latest \
  --format "bv*+ba/b" \
  --merge-output-format mp4 \
  https://www.youtube.com/watch?v=example
```

Extract audio:

```bash
docker run --rm \
  -v /path/to/downloads:/downloads \
  friedrichrehren/yt-dlp:latest \
  --extract-audio \
  --audio-format mp3 \
  https://www.youtube.com/watch?v=example
```

## Build Locally

Build the latest upstream `yt-dlp` release:

```bash
docker build -t yt-dlp:latest .
```

Build a specific upstream release:

```bash
docker build \
  --build-arg YTDLP_VERSION=2026.03.17 \
  -t yt-dlp:2026.03.17 .
```

## Build Arguments

- `YTDLP_VERSION`: upstream `yt-dlp` release tag to download. Defaults to
  `latest`. Set it to `nightly` to download the upstream nightly build channel
  instead of a tagged stable release.
- `PYTHON_IMAGE`: base image to build from. Defaults to `python:3.14-slim`.
- `DENO_VERSION`: Deno release to install for JavaScript execution. Defaults to
  `2.6.4`.

Example with an explicit base image:

```bash
docker build \
  --build-arg PYTHON_IMAGE=python:3.14-slim \
  --build-arg YTDLP_VERSION=latest \
  -t yt-dlp:custom .
```

## Image Behavior

The image:

- installs `ffmpeg` from Debian packages
- installs `ffprobe` from the same Debian package set
- installs `AtomicParsley`
- installs `deno` for JavaScript execution
- installs the Python package `curl_cffi`
- downloads the upstream `yt-dlp` binary during build
- runs as UID `65532`
- uses `/downloads` as the working directory

That means mounted download paths should normally target `/downloads`.
