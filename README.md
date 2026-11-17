# cors-anywhere docker image

This image provides [cors-anywhere](https://www.npmjs.com/package/cors-anywhere) service.

- Docker Hub: [`orrisroot/cors-anywhere`](https://hub.docker.com/r/orrisroot/cors-anywhere)
- Base image: `gcr.io/distroless/nodejs24-debian13`
- Platform: `linux/amd64`

## Tags

| Tag | Description |
|---|---|
| `latest` | Latest cors-anywhere release on the latest base image |
| `<version>` (e.g. `0.4.4`) | Specific cors-anywhere release |

Images are rebuilt automatically when a new cors-anywhere version, an updated dependency, or an updated base image is released. Both tags are overwritten on rebuild, so pulling the same tag again picks up base image and dependency security fixes.

## Security

> [!WARNING]
> `cors-anywhere` (`<= 0.4.4`) is affected by [GHSA-r3jv-xfgx-gj24](https://github.com/advisories/GHSA-r3jv-xfgx-gj24) (`CVE-2020-36851`, Critical: Server-Side Request Forgery / SSRF), and no patched upstream release is available.

By default (`CORSANYWHERE_WHITELIST` unset), `cors-anywhere` acts as an open proxy that forwards arbitrary HTTP methods and headers (including `PUT`) to arbitrary target URLs. If exposed to untrusted clients, attackers can reach internal services, private networks, and cloud instance metadata endpoints (such as `169.254.169.254`, including IMDSv2 token workflows).

Recommended mitigations:

- **Do not expose directly to untrusted networks**: Bind only to localhost (`-p 127.0.0.1:8080:8080`), run inside an isolated/private network, or place behind a reverse proxy enforcing authentication or IP allowlisting.
- **Do not rely solely on `CORSANYWHERE_WHITELIST`**: While `CORSANYWHERE_WHITELIST` restricts browser origins and `CORSANYWHERE_RATELIMIT` throttles abuse, direct non-browser HTTP clients can freely spoof the `Origin` header.
- **Restrict outbound traffic (egress)**: Because `cors-anywhere` has no built-in target host allowlist or private/link-local IP filter, block container egress to private/loopback networks (`127.0.0.0/8`, `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`) and link-local/metadata endpoints (`169.254.0.0/16`) at the host firewall, container network policy, or egress proxy level, and apply cloud-provider IMDS protections (e.g., disable IMDS or enforce IMDSv2 with hop limit `1` when containers cannot reach metadata).
- **Prefer fixed-upstream proxies when targets are known**: If you only need CORS headers for specific known upstreams, configure a reverse proxy (such as Nginx or Caddy) for those fixed targets instead of an arbitrary-URL proxy.

## Example

### Run

```sh
docker run --restart always -d --name cors-anywhere -p 127.0.0.1:8080:8080 orrisroot/cors-anywhere
```

### Request

```sh
curl --request GET \
  --url http://localhost:8080/http://example.com \
  --header 'origin: *'
```

## Configuration

The container listens on port `8080` by default and runs `node_modules/cors-anywhere/server.js`. Upstream environment variables supported by `server.js`:

| Variable | Default | Description |
|---|---|---|
| `HOST` | `0.0.0.0` | Host address to bind |
| `PORT` | `8080` | Listening port |
| `CORSANYWHERE_BLACKLIST` | _(unset)_ | Comma-separated list of blocked origins |
| `CORSANYWHERE_WHITELIST` | _(unset)_ | Comma-separated list of allowed origins |
| `CORSANYWHERE_RATELIMIT` | _(unset)_ | Rate limit configuration passed to cors-anywhere |

## Build

Build the image locally with `build.sh`. The cors-anywhere version is read from `dependencies.cors-anywhere` in `package.json`.

```sh
./build.sh
```

The script tags the image as `orrisroot/cors-anywhere:latest` and `orrisroot/cors-anywhere:<version>`.
