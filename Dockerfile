FROM alpine:edge as BUILD
RUN apk add --no-cache netcat-openbsd=1.219-r0
ENTRYPOINT [ "nc" ]
