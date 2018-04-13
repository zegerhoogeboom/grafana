FROM golang:1.10.1

ARG GF_UID="472"
ARG GF_GID="472"

WORKDIR /go/src/github.com/grafana/grafana

ENV PATH=/go/src/github.com/grafana/grafana/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH \
    GF_PATHS_CONFIG="/go/src/github.com/grafana/grafana/conf/defaults.ini" \
    GF_PATHS_DATA="/var/lib/grafana" \
    GF_PATHS_HOME="/go/src/github.com/grafana/grafana" \
    GF_PATHS_LOGS="/var/log/grafana" \
    GF_PATHS_PLUGINS="/var/lib/grafana/plugins" \
    GF_PATHS_PROVISIONING="/etc/grafana/provisioning"


COPY package.json .

RUN apt-get update \
  && apt-get install bzip2 \
  && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
  && apt-get install -y nodejs --fix-missing \
  && npm install -g yarn

RUN yarn install --pure-lockfile

VOLUME ["/var/lib/grafana", "/var/log/grafana", "/etc/grafana"]
EXPOSE 3000

COPY . .
RUN go run build.go setup
RUN go run build.go build
RUN npm run dev


COPY ./run.sh /run.sh

ENTRYPOINT [ "/run.sh" ]
