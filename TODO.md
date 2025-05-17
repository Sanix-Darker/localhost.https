## TODO

- Maybe use mkcert ?.
- Fix the Security Reminder : Self-signed certificates trigger browser warnings.. so it need to manually trust the certificate (steps vary by OS/browser).
- Certificate Persistence: To avoid re-generating certs on each run, mount a volume for `/certs` in Docker.
