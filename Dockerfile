FROM golang:latest AS builder

WORKDIR /go

COPY ./app.go .
COPY ./blockchain.html .
COPY ./openapi.yml .

RUN go get -d -v \
	github.com/lib/pq \
	github.com/julienschmidt/httprouter

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o app

FROM scratch

ENV IP=0.0.0.0
ENV PORT=8000
EXPOSE 8000
COPY --from=builder /go/app .
COPY blockchain.html /
CMD ["./app"]
