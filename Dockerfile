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

EXPOSE 8000
COPY --from=builder /go .
COPY blockchain.html /
CMD /go/app
