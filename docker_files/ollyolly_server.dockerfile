FROM ruby:latest

RUN apt-get update \
  && apt-get -y install man-db manpages manpages-dev vim mysql-client git less zip gzip build-essential gcc g++ make \
  && rm -rf /var/lib/apt/lists/*

# install node
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && apt-get install -y nodejs
# install yarn
# curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
#     echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
#     apt-get update && apt-get install yarn

RUN mkdir -p /apps/ollyolly_server

WORKDIR /apps/ollyolly_server

ENV GEM_HOME="/gems"
ENV BUNDLE_PATH="/gems"

EXPOSE 3000
EXPOSE 3001

CMD /bin/bash
