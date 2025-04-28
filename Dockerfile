FROM golang:1.23.2 AS builder

LABEL maintainer="Jennings Liu <jenningsloy318@gmail.com>"

# ENV GOROOT /usr/local/go
# ENV GOPATH /go
# ENV PATH "$GOROOT/bin:$GOPATH/bin:$PATH"

COPY . /usr/src/redfish_exporter
WORKDIR /usr/src/redfish_exporter

RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o build/redfish_exporter .

FROM golang:1.23.2 

COPY --from=builder /usr/src/redfish_exporter/build/redfish_exporter /usr/local/bin/redfish_exporter
RUN mkdir /etc/prometheus
COPY config.yml.example /etc/prometheus/redfish_exporter.yml
CMD ["/usr/local/bin/redfish_exporter","--config.file","/etc/prometheus/redfish_exporter.yml"]

EXPOSE 9610