# syntax=docker/dockerfile:1

FROM docker.io/library/golang:1.25.3-alpine AS builder
ARG VERSION
ARG TARGETOS=linux
ARG TARGETARCH=amd64

ENV \
    CGO_ENABLED=0 \
    GOOS=${TARGETOS} \
    GOARCH=${TARGETARCH}

WORKDIR /src

RUN apk add --no-cache ca-certificates git

RUN git clone --depth 1 --branch "${VERSION}" https://github.com/external-secrets/external-secrets.git .

RUN --mount=type=cache,target=/root/.cache/go-build \
    --mount=type=cache,target=/go/pkg/mod \
    go build -trimpath -ldflags "-s -w" -o /out/external-secrets main.go

FROM gcr.io/distroless/static@sha256:87bce11be0af225e4ca761c40babb06d6d559f5767fbf7dc3c47f0f1a466b92c
COPY --from=builder /out/external-secrets /bin/external-secrets

USER 65534

ENTRYPOINT ["/bin/external-secrets"]
