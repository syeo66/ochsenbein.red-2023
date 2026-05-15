FROM node:24 AS node
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
WORKDIR /usr/src/app
COPY package.json .
COPY pnpm-lock.yaml .
COPY pnpm-workspace.yaml .
RUN pnpm install --frozen-lockfile
COPY . .
RUN pnpm astro telemetry disable
RUN make build

FROM nginx AS server

EXPOSE 80

COPY --from=node /usr/src/app/dist /usr/share/nginx/html

