# Stage 1: Build Stage

FROM golang:alpine3.24 AS builder

WORKDIR /worker

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -o /worker .

RUN addgroup -S nonrootgroup && \
    adduser -S nonrootuser -G nonrootgroup

# Stage 2: Runtime Stage

FROM scratch AS runtime

WORKDIR /worker

COPY --from=builder ./worker /worker/
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

USER nonrootuser

ENTRYPOINT [ "./worker" ]