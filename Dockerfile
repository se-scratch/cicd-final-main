FROM golang:1.22 AS builder

ARG CGO_ENABLED=0 
ARG GOOS=linux 
ARG GOARCH=amd64

WORKDIR /src

COPY go.mod go.sum *.go *.db ./

RUN go mod download

COPY  *.go *.db ./

RUN CGO_ENABLED=$CGO_ENABLED GOOS=$GOOS GOARCH=$GOARCH go build -o ./my_app

FROM alpine:3.20

WORKDIR /app

COPY --from=builder /src/my_app ./
COPY *.db ./

CMD ["/app/my_app"]