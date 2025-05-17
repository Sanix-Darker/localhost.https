FROM alpine:latest

# install openssl (for certs) and socat (for the TLS→TCP proxy)
RUN apk add --no-cache openssl socat

# copy our startup script
COPY s.sh /s.sh
RUN chmod +x /s.sh

ENTRYPOINT ["/s.sh"]
