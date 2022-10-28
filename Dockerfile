FROM docker.io/library/node:18-bullseye AS build-env
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install

FROM gcr.io/distroless/nodejs-debian11:18
WORKDIR /app
COPY --from=build-env /app/node_modules /app/node_modules
EXPOSE 8080
CMD ["node_modules/cors-anywhere/server.js"]
