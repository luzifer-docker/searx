FROM python:3.7-alpine

ENV INSTALL_DIR=/opt/searx \
    VERSION=v0.15.0

COPY build.sh /usr/local/bin

RUN set -ex \
 && apk --no-cache add \
      bash \
 && bash /usr/local/bin/build.sh

COPY run.sh /usr/local/bin

WORKDIR /opt/searx
EXPOSE 8888

ENTRYPOINT ["bash"]
CMD ["/usr/local/bin/run.sh"]
