FROM docker.io/library/node:14 as build
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install --production

FROM gcr.io/distroless/nodejs:14
COPY --from=build /app /
EXPOSE 8080
CMD ["node_modules/cors-anywhere/server.js"]
