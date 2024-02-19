FROM alpine:3.19 AS tools-builder

RUN apk update && apk upgrade \
 && apk add alpine-sdk curl gcc g++ git musl-dev openssl openssl-dev openssl-libs-static unzip

WORKDIR /root/cica

ARG cica_ver=5.0.3
RUN curl -LO https://github.com/miiton/Cica/releases/download/v${cica_ver}/Cica_v${cica_ver}.zip \
 && unzip Cica_v${cica_ver}.zip \
 && mkdir -p /usr/share/fonts/cica \
 && mv Cica-*.ttf /usr/share/fonts/cica \
 && tar rvf /artifacts.tar.gz /usr/share/fonts/cica

WORKDIR /root/src

RUN git clone https://github.com/aristocratos/btop \
 && cd btop \
 && git checkout main \
 && make \
 && cp bin/btop /usr/bin/ \
 && tar rvf /artifacts.tar.gz /usr/bin/btop
