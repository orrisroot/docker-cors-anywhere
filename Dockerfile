# Keep the Node.js major version in sync with the distroless runtime image below.
FROM docker.io/library/node:26-trixie@sha256:f8e5d4bb28fa55c74f1345166a082a10b7c68f22304350c1ce0d18358ae94996 AS build-env
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev \
    && test ! -d node_modules/cors-anywhere/node_modules/http-proxy \
    && node -e "const pkg = require('./package.json'); const ca = require('./node_modules/cors-anywhere/package.json'); if (ca.version !== pkg.dependencies['cors-anywhere']) throw new Error('cors-anywhere version mismatch: ' + ca.version);"

FROM gcr.io/distroless/nodejs26-debian13:latest@sha256:13e3ac17e2911d238622fea7808a7a161ba6b33a41e542ded6e399387e1dbc84
WORKDIR /app
COPY --from=build-env /app/node_modules /app/node_modules
EXPOSE 8080
CMD ["node_modules/cors-anywhere/server.js"]
