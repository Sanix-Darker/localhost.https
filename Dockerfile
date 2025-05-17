FROM alpine:latest

# install openssl (for certs) and socat (for the TLS→TCP proxy)
RUN apk add --no-cache openssl socat

# copy our startup script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
