# vanilla_http_server

- Fast (Multi-threaded, non-blocking i/o, lock-free, copy-free, epoll, SO_REUSEPORT)
- Thread affinity (W.I.P.)
- Modular (can use any HTTP parser)
- Etag header by default
- time header by default
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
   mkdir -p ~/.vmodules/enghitalo/vanilla_http_server
   ```

2. Copy the `vanilla_http_server` directory to the target location:
   ```bash
   cp -r ./ ~/.vmodules/enghitalo/vanilla_http_server
   ```

This will set up the module in your `~/.vmodules` directory for use.

#### From repository

```sh
v install https://github.com/enghitalo/vanilla_http_server
```
