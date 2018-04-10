FROM golang:1.10.1

WORKDIR /go/src/github.com/grafana/grafana

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
CMD ./bin/grafana-server
