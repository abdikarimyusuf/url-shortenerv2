FROM golang:alpine3.24

WORKDIR /worker

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -o /worker .

ENTRYPOINT [ "./worker" ]