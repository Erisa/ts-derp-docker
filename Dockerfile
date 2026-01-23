# Global arguments
ARG ALPINE_VERSION=3.23

## Build container
FROM --platform=${BUILDPLATFORM} alpine:${ALPINE_VERSION} AS builder

### Build argument(s)
ARG TARGETOS TARGETARCH
ARG TAILSCALE_VERSION=v1.92.2

WORKDIR /build

### Install build dependancies
RUN apk add --no-cache git bash curl

### Clone the right version of Tailscale
RUN git clone https://github.com/tailscale/tailscale --depth=1 --branch ${TAILSCALE_VERSION} .

### Build all the needed binaries
RUN mkdir binout && GOOS=${TARGETOS} GOARCH=${TARGETARCH} ./tool/go build -o ./binout . ./cmd/tailscale ./cmd/tailscaled ./cmd/derper ./cmd/containerboot 

## Runtime container
FROM alpine:${ALPINE_VERSION}

### Runtime dependancies
RUN apk add --no-cache curl iptables iproute2

COPY --from=builder /build/binout/* /usr/local/bin/
COPY --chmod=755 init.sh /init.sh

### Unless changed
EXPOSE 80/tcp
EXPOSE 443/tcp
EXPOSE 3478/udp

ENTRYPOINT ["/init.sh"]

LABEL org.opencontainers.image.source=https://github.com/Erisa/ts-derp-docker