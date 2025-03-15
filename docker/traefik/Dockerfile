FROM traefik:latest

RUN apk update && apk add curl

COPY ./docker/traefik/dynamic.yml /etc/traefik/dynamic.yml
COPY ./docker/traefik/traefik.yml /etc/traefik/traefik.yml

VOLUME ["/var/run/docker.sock"]
