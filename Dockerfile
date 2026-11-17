FROM docker.io/library/node:24-trixie@sha256:6e5d4c38403930b420404f190be8563396dca2bd156a6cb4722707b0efcf6fc1 AS build-env
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev \
    && test ! -d node_modules/cors-anywhere/node_modules/http-proxy \
    && node -e "const pkg = require('./package.json'); const ca = require('./node_modules/cors-anywhere/package.json'); if (ca.version !== pkg.dependencies['cors-anywhere']) throw new Error('cors-anywhere version mismatch: ' + ca.version);"

FROM gcr.io/distroless/nodejs24-debian13:latest@sha256:24bc0fe0225c7518f202a822587dad74fe143b96326b81fe5cc08c1df8bed03e
WORKDIR /app
COPY --from=build-env /app/node_modules /app/node_modules
EXPOSE 8080
CMD ["node_modules/cors-anywhere/server.js"]
