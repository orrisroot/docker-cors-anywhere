FROM docker.io/library/node:22-bookworm AS build-env
WORKDIR /app
COPY package.json ./
RUN npm install

FROM gcr.io/distroless/nodejs22-debian12:latest
WORKDIR /app
COPY --from=build-env /app/node_modules /app/node_modules
EXPOSE 8080
CMD ["node_modules/cors-anywhere/server.js"]
