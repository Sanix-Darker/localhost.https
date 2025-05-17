# localhost.https

> ⚠️ **DO NOT USE THIS IN PRODUCTION**
> This is meant for **local testing only**.

`localhost.https` is a simple script to enable HTTPS for your localhost/LAN development environment.

![screenshot](./screenshot.png)

## Why?

While working on a project, I needed to test a webcam over LAN. Modern browsers block webcam access on "untrusted" (non-HTTPS) pages, a fair security measure, but problematic for developers. This script provides a workaround by generating a self-signed certificate using OpenSSL, similar to Let's Encrypt's approach but for local use.

## REQUIREMENTS

- **Docker** (if using the prebuilt image).
- A running app on the target port (`APP_PORT`). The HTTPS server will proxy traffic to it.

### OPTIONAL

- **`MAKE`** (for simplified commands; otherwise, run the commands manually).
- **HOSTS FILE ENTRY** (for custom domains): (if this changes, consider change also when running the docker/make command)
  ```sh
  echo "127.0.0.1 app.local" | sudo tee -a /etc/hosts
  ```

## USAGE

### QUICK START (USING PREBUILT DOCKER IMAGE)
```sh
export APP_PORT="3215"  # your app's HTTP port
export DOMAIN="app.local"
docker run --rm -d --network host \
  -e APP_PORT="$APP_PORT" \
  -e DOMAIN="$DOMAIN" \
  sanixdarker/localhost.https:latest
```

### MANUAL BUILD & RUN
```bash
$ make usage

Usage :
  make build                                        # to docker build the localhost.https image
  make run   APP_PORT=3001 DOMAIN=app.local         # APP_PORT and DOMAIN are optionals, defaults will be use if not provided
  make runc  APP_PORT=3001 DOMAIN=app.local         # for windows and mac
  make set-forward                                  # to set in /etc/hosts app.local
```

## Author
- [sanixdk](https://github.com/sanix-darker)
