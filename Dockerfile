# syntax=docker/dockerfile:1

# --- build stage: the official Vite+ toolchain image ---
FROM ghcr.io/voidzero-dev/vite-plus:latest AS build
ENV ASTRO_TELEMETRY_DISABLED=1
WORKDIR /app

# Install dependencies first so this layer is cached across source changes.
# vp provisions the Node.js version from .nvmrc automatically.
COPY --chown=vp:vp package.json pnpm-lock.yaml pnpm-workspace.yaml .nvmrc ./
RUN vp install --frozen-lockfile

COPY --chown=vp:vp . .
RUN vp run build

FROM nginx AS server

EXPOSE 80

COPY --from=build /app/dist /usr/share/nginx/html
