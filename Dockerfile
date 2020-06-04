FROM ubuntu:20.10
MAINTAINER thomfab

ARG VOLUME=volume

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends rsync && \
  apt-get clean autoclean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/

EXPOSE 873
VOLUME /${VOLUME}
COPY ./run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh
ENTRYPOINT ["/usr/local/bin/run.sh"]
