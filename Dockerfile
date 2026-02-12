FROM golang:1.26-alpine AS builder
WORKDIR /app
RUN apk add --no-cache git build-base
COPY . .
# We use '.' to build the entire module in the current directory
RUN go build -o picoclaw .

FROM alpine:latest
WORKDIR /root/
RUN apk add --no-cache ca-certificates
COPY --from=builder /app/picoclaw /usr/local/bin/picoclaw
RUN mkdir -p /root/.picoclaw/workspace

# This starts the Telegram bot listener
ENTRYPOINT ["picoclaw", "gateway"]
