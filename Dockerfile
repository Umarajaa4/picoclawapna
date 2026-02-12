# Use Go 1.26 (the 2026 standard) to satisfy the >= 1.25.7 requirement
FROM golang:1.26-alpine AS builder
WORKDIR /app
RUN apk add --no-cache git build-base
COPY . .
RUN go build -o picoclaw main.go

FROM alpine:latest
WORKDIR /root/
RUN apk add --no-cache ca-certificates
COPY --from=builder /app/picoclaw /usr/local/bin/picoclaw
RUN mkdir -p /root/.picoclaw/workspace

# Start the gateway for Telegram interaction
ENTRYPOINT ["picoclaw", "gateway"]
