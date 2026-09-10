FROM golang:alpine3.24

WORKDIR /dashboard

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -o /dashboard .

EXPOSE 8081

ENTRYPOINT [ "./dashboard" ]