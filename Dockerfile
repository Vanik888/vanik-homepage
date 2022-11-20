FROM alpine:3.12@sha256:074d3636ebda6dd446d0d00304c4454f468237fdacf08fb0eeac90bdbfa1bac7

ENV HUGO_VERSION=0.79.1
ENV HUGO_ID=hugo${HUGO_TYPE}_${HUGO_VERSION}
RUN wget -O - https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_ID}_Linux-64bit.tar.gz | tar -xz -C /tmp \
    && mkdir -p /usr/local/sbin \
    && mv /tmp/hugo /usr/local/sbin/hugo \
    && rm -rf /tmp/${HUGO_ID}_linux_amd64 \
    && rm -rf /tmp/LICENSE.md \
    && rm -rf /tmp/README.md

RUN apk add --update git asciidoctor libc6-compat libstdc++ \
    && apk upgrade \
    && apk add --no-cache ca-certificates

RUN mkdir -p /src
VOLUME ["/src"]
WORKDIR /src
COPY . /src

ENTRYPOINT ["hugo"]
CMD ["--help"]
