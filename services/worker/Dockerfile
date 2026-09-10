# Stage 1: Build Stage

FROM golang:alpine3.24 AS builder

WORKDIR /worker

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -o /worker .

# Stage 2: Runtime Stage

FROM scratch AS runtime

WORKDIR /worker

COPY --from=builder ./worker /worker/

ENTRYPOINT [ "./worker" ]