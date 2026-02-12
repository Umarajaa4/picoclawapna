# Use Go 1.26 to meet the version requirement
FROM golang:1.26-alpine AS builder
WORKDIR /app

# Install build tools
RUN apk add --no-cache git build-base

# Manually clone your repo into the current directory
# This ensures we have the Go files regardless of Dokploy's context
RUN git clone https://github.com/Umarajaa4/picoclawapna.git .

# Build the binary
RUN go build -o picoclaw .

FROM alpine:latest
WORKDIR /root/
RUN apk add --no-cache ca-certificates

# Copy the binary from the builder stage
COPY --from=builder /app/picoclaw /usr/local/bin/picoclaw

# Ensure workspace exists
RUN mkdir -p /root/.picoclaw/workspace

# Start the bot
ENTRYPOINT ["picoclaw", "gateway"]
