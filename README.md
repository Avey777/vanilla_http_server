# vanilla_http_server

- Fast (Multi-threaded, non-blocking i/o, lock-free, copy-free, epoll, SO_REUSEPORT)
- Thread affinity (W.I.P.)
- Modular (can use any HTTP parser)
- Etag header by default (W.I.P.)
- time header by default (W.I.P.)
- Memory safety, No race condition
- No magic
- Allow e2e test and scripting without needs running the server, you only needs pass the raw requist to handle_request ()
- SSE (Server-Sent Events) Friendly (W.I.P.)
- Graceful shutdown (W.I.P.)

## Install

### Installation

#### From Root Directory

To install the `vanilla_http_server` module, follow these steps:

1. Create the necessary directories:

```bash
mkdir -p ~/.vmodules/enghitalo/vanilla
```

2. Copy the `vanilla_http_server` directory to the target location:

```bash
cp -r ./ ~/.vmodules/enghitalo/vanilla
# run
v -prod crun examples/simple
```

This will set up the module in your `~/.vmodules` directory for use.

#### From repository

```sh
v install https://github.com/enghitalo/vanilla_http_server
```

## Benchmarking

```sh
curl -v http://localhost:3001
wrk  -H 'Connection: "keep-alive"' --connection 512 --threads 16 --duration 60s http://localhost:3001
```

```sh
Running 1m test @ http://localhost:3001
  16 threads and 512 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     1.25ms    1.46ms  35.70ms   84.67%
    Req/Sec    32.08k     2.47k   57.85k    71.47%
  30662010 requests in 1.00m, 2.68GB read
Requests/sec: 510197.97
Transfer/sec:     45.74MB
```
