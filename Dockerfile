FROM ubuntu:xenial
LABEL maintainer="Shahzaib Rashid <shahzaob.rashid@careem.com>"

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

ENV HOME /home/${user}
RUN groupadd -g ${gid} ${group}
RUN useradd -c "Jenkins user" -d $HOME -u ${uid} -g ${gid} -m ${user}

RUN apt-get update && apt-get install -y --no-install-recommends \
  curl \
  wget \
  ca-certificates \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install -y --no-install-recommends \
  zip \
  unzip \
  build-essential \
  nodejs \
  yarn \
  && wget -q https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.2.0.1227-linux.zip \
  && unzip sonar-scanner-cli-3.2.0.1227-linux.zip \
  && mv sonar-scanner-3.2.0.1227-linux /usr/local/bin/sonar-scanner \
  && rm sonar-scanner-cli-3.2.0.1227-linux.zip

ENV SONAR_RUNNER_HOME=/usr/local/bin/sonar-scanner
ENV PATH=$PATH:/usr/local/bin/sonar-scanner/bin

USER ${user}

RUN mkdir ${HOME}/app

WORKDIR ${HOME}/app