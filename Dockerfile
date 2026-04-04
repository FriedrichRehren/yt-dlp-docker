ARG PYTHON_IMAGE=python:3.14-slim
FROM ${PYTHON_IMAGE}

ARG YTDLP_VERSION=latest
ARG DENO_VERSION=2.6.4

USER root

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends atomicparsley ca-certificates curl ffmpeg unzip; \
    arch="$(dpkg --print-architecture)"; \
    case "${arch}" in \
      amd64) deno_arch='x86_64-unknown-linux-gnu' ;; \
      arm64) deno_arch='aarch64-unknown-linux-gnu' ;; \
      *) echo "Unsupported architecture: ${arch}" >&2; exit 1 ;; \
    esac; \
    case "${YTDLP_VERSION}" in \
      nightly) \
        ytdlp_url='https://github.com/yt-dlp/yt-dlp-nightly-builds/releases/latest/download/yt-dlp' \
        ;; \
      latest) \
        ytdlp_url='https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp' \
        ;; \
      *) \
        ytdlp_url="https://github.com/yt-dlp/yt-dlp/releases/download/${YTDLP_VERSION}/yt-dlp" \
        ;; \
    esac; \
    curl -fL "${ytdlp_url}" -o /usr/local/bin/yt-dlp; \
    chmod 0755 /usr/local/bin/yt-dlp; \
    python -m pip install --no-cache-dir curl_cffi; \
    curl -fL "https://github.com/denoland/deno/releases/download/v${DENO_VERSION}/deno-${deno_arch}.zip" -o /tmp/deno.zip; \
    unzip -q /tmp/deno.zip -d /usr/local/bin; \
    chmod 0755 /usr/local/bin/deno; \
    rm -f /tmp/deno.zip; \
    apt-get purge -y --auto-remove curl unzip; \
    rm -rf /var/lib/apt/lists/*; \
    yt-dlp --version; \
    ffmpeg -version >/dev/null; \
    ffprobe -version >/dev/null; \
    deno --version >/dev/null; \
    AtomicParsley -v >/dev/null; \
    python -c "import curl_cffi"

RUN mkdir -p /downloads \
    && chown 65532:65532 /downloads

USER 65532

WORKDIR /downloads
ENTRYPOINT ["yt-dlp"]
