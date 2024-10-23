# -- multistage docker build: stage #1: build stage
#FROM golang:1.22.0-alpine AS build

#RUN mkdir -p /go/src/github.com/theretromike/bricsd

#WORKDIR /go/src/github.com/theretromike/bricsd

#RUN apk add --no-cache curl git openssh binutils gcc musl-dev

#COPY go.mod .
#COPY go.sum .


# Cache bugnad dependencies
#RUN go mod download

#COPY . .
#RUN mkdir -p /brics/bin/
#RUN go build $FLAGS -o /brics/bin/ .

# --- multistage docker build: stage #2: runtime image
#FROM alpine
#WORKDIR /root/

#RUN apk add --no-cache ca-certificates tini

#COPY --from=build /brics/bin/* /usr/bin/

#ENTRYPOINT [ "/usr/bin/bricsd", "--utxoindex" ]

FROM ubuntu:jammy
RUN apt-get update -y
RUN apt-get install wget unzip -y
WORKDIR /opt/
RUN wget https://github.com/brics18/bricsd/releases/download/v1.0.0/bricsd
RUN chmod +x bricsd
#RUN unzip Linux.-.waglayalad-rusty.zip
#RUN chmod +x 'Linux - waglayalad-rusty'/*
RUN mv bricsd /usr/bin/
CMD /usr/bin/bricsdd --utxoindex
