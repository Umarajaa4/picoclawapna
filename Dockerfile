FROM golang:1.23-alpine AS builder
WORKDIR /app
RUN apk add --no-cache git build-base
# Copy the source from the current directory (GitHub repo)
COPY . .
RUN go build -o picoclaw main.go

FROM alpine:latest
WORKDIR /root/
RUN apk add --no-cache ca-certificates
COPY --from=builder /app/picoclaw /usr/local/bin/picoclaw
RUN mkdir -p /root/.picoclaw/workspace

# Start the gateway for Telegram interaction
ENTRYPOINT ["picoclaw", "gateway"]
