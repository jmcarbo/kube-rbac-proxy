# Build the manager binary
FROM golang:1.15.6 as builder

ARG BUILD_VERSION
ARG TARGETARCH

# Copy the Go Modules manifests
COPY . /app

# Build
RUN cd /app && CGO_ENABLED=0 go build -a -tags netgo -ldflags '-w -extldflags "-static"' -o kube-rbac-proxy .


FROM gcr.io/distroless/static:nonroot as final

COPY --from=builder /app/kube-rbac-proxy /usr/local/bin/kube-rbac-proxy
EXPOSE 8080
USER 65532:65532

ENTRYPOINT ["/usr/local/bin/kube-rbac-proxy"]
