# Stage 1: Build Stage

FROM golang:alpine3.24 AS builder

WORKDIR /worker

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -o /worker .


# Stage 2: Runtime Stage

FROM alpine:3.24 AS runtime

WORKDIR /worker

RUN addgroup -S nonrootgroup && \
    adduser -S nonrootuser -G nonrootgroup

COPY --from=builder ./worker /worker

USER nonrootuser

CMD ["./worker"]