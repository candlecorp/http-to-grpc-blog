# http-to-grpc-blog
Code for HTTP to GRPC blog


## How to use
Run `docker-compose up`

Open your web browser to `localhost:9090` to view the prometheus metrics.  There will be a background app that will be sending traffic to the server and Prometheus will begin to populate the following metrics:

- `wasmflow_requests_total`
- `wasmflow_requests_time_total`
- `wasmflow_requests_errors_total`

## Details
- `server` container is running a `Wasmflow` application.  `Wasmflow` exposes a `Stats` method via GRPC.
- `client` container is continually calling the `wasmflow` application through `envoy` reverse proxy.
- `envoy` container is acting as a reverse proxy for the `wasmflow` application.  It passes through the `client` calls directly without any modification.  It. It is dynamically transforming the GRPC `Stats` response to `application/json` using GRPC to JSON transcoding.  It is then converting from `JSON` to `text/plain` using Lua.
- `prometheus` container is scraping the `/metrics` endpoint that is sent to the `wasmflow` container's GRPC interface through `envoy`.
