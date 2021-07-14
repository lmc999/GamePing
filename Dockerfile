FROM alpine:latest

COPY GamePing.sh /GamePing.sh

RUN apk add --no-cache --virtual .build-deps linux-headers musl-dev bash sed curl bc fping

RUN chmod +x /GamePing.sh

ENTRYPOINT ["/bin/bash","/GamePing.sh"]
