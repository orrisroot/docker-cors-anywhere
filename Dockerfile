FROM docker.io/library/node:26-trixie@sha256:e18c3ccdf7d71619990b0e85639f506e2028a95410999cab24cc373cbd10e0ac AS build-env
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
