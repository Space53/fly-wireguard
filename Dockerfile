FROM alpine:latest

RUN apk update && apk add wireguard-tools iptables bash

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
