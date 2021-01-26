FROM node:latest
MAINTAINER Ji-Hyeon Gim <potatogim@potatogim.net>

SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

EXPOSE 10044

RUN apt-get update
RUN apt-get install --no-install-recommends -y -o Dpkg::Options::="--force-confold" librsvg2-dev mocha
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/wikimedia/mathoid
RUN cd mathoid && npm install && cp config.prod.yaml config.yaml
RUN useradd --home=/var/lib/mathoid -M --user-group --system --shell=/usr/sbin/nologin -c "Mathoid for MediaWiki" mathoid
RUN mkdir -p /var/lib/mathoid
RUN chown mathoid:mathoid /var/lib/mathoid
RUN mv mathoid /usr/local/lib/mathoid
RUN chown -R root.root /usr/local/lib/mathoid

WORKDIR /usr/local/lib/mathoid
CMD /usr/local/bin/node /usr/local/lib/mathoid/server.js
