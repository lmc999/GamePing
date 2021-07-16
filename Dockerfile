FROM alpine:latest

COPY GamePing.sh /GamePing.sh

RUN chmod +x /GamePing.sh && \
    apk add --no-cache --virtual .build-deps linux-headers musl-dev bash sed curl bc fping

ENTRYPOINT ["/bin/bash", "-l", "-c", "/GamePing.sh"]
