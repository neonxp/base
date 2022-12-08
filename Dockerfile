FROM alpine:3.17 as dep

LABEL org.opencontainers.image.source=https://github.com/neonxp/base
LABEL org.opencontainers.image.description="NeonXP Base image"
LABEL org.opencontainers.image.licenses=MIT
LABEL org.opencontainers.image.authors="Alexander Kiryukhin <i@neonxp.dev>"

ENV USER=docker
ENV UID=10001 

RUN adduser \    
    --disabled-password \    
    --gecos "" \    
    --home "/nonexistent" \    
    --shell "/sbin/nologin" \    
    --no-create-home \    
    --uid "${UID}" \    
    "${USER}" && \
    apk update && apk add --no-cache ca-certificates tzdata && update-ca-certificates

FROM scratch

COPY --from=dep /usr/share/zoneinfo /usr/share/zoneinfo
COPY --from=dep /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=dep /etc/passwd /etc/passwd
COPY --from=dep /etc/group /etc/group

ENV TZ=Europe/Moscow
USER docker:docker

WORKDIR /app