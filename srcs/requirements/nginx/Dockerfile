FROM alpine:3.19

RUN apk update && apk add --no-cache \
    nginx \
    openssl \
    bash \
    && rm -rf /var/cache/apk/*

# creating required repos
RUN mkdir -p /etc/nginx/ssl /run/nginx

# nginx config
COPY conf/default.conf /etc/nginx/nginx.conf

# script init tls
COPY tools/config.sh /config.sh
RUN chmod +x /config.sh

EXPOSE 443

ENTRYPOINT ["/config.sh"]

