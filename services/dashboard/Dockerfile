# Stage 1: Build Stage

FROM golang:alpine3.24 AS builder

WORKDIR /dashboard

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -o /dashboard .

RUN addgroup -S nonrootgroup && \
    adduser -S nonrootuser -G nonrootgroup

# Stage 2: Runtime Stage

FROM scratch AS runtime

WORKDIR /dashboard

COPY --from=builder ./dashboard /dashboard/
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group

USER nonrootuser

EXPOSE 8081

ENTRYPOINT [ "./dashboard" ]