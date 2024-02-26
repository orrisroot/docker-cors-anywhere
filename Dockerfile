FROM docker.io/library/node:20-bullseye AS build-env
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install

FROM gcr.io/distroless/nodejs20-debian11:latest
WORKDIR /app
COPY --from=build-env /app/node_modules /app/node_modules
EXPOSE 8080
CMD ["node_modules/cors-anywhere/server.js"]
