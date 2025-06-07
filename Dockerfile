# Global arguments
ARG ALPINE_VERSION=3.22

## Build container

FROM --platform=${BUILDPLATFORM} alpine:${ALPINE_VERSION} AS builder
LABEL org.opencontainers.image.source = https://github.com/Erisa/ts-derp-docker

### Build argument(s)
ARG TAILSCALE_VERSION=v1.84.0

### Build dependancies
RUN apk add git bash curl --no-cache

ARG TARGETOS
ARG TARGETARCH

WORKDIR /build

### Clone the right version of Tailscale
RUN git clone https://github.com/tailscale/tailscale --depth=1 --branch ${TAILSCALE_VERSION} .

### Build all the needed binaries
RUN mkdir binout && GOOS=${TARGETOS} GOARCH=${TARGETARCH} ./tool/go build -o ./binout . ./cmd/tailscale ./cmd/tailscaled ./cmd/derper ./cmd/containerboot 

## Runtime container

FROM alpine:${ALPINE_VERSION}

### Runtime dependancies
RUN apk add curl iptables iproute2

COPY --from=builder /build/binout/* /usr/local/bin/

COPY init.sh /init.sh
RUN chmod +x /init.sh

### Unless changed
EXPOSE 80/tcp
EXPOSE 443/tcp
EXPOSE 3478/udp

ENTRYPOINT ["/init.sh"]
