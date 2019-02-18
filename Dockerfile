FROM openjdk:latest
LABEL maintainer="Shahzaib Rashid <shehzaib.rashid@gmail.com>"

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install -y --no-install-recommends \
  libltdl7 \
  zip \
  unzip \
  build-essential \
  python-dev \
  dnsutils \
  jq \
  groff \
  nodejs \
  yarn \
  && wget -q https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip \
  && unzip terraform_0.11.7_linux_amd64.zip \
  && mv terraform /usr/local/bin/ \
  && curl -O https://bootstrap.pypa.io/get-pip.py \
  && python get-pip.py \
  && pip install awscli \
  && rm terraform_0.11.7_linux_amd64.zip \
  && wget -q https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.2.0.1227-linux.zip \
  && unzip sonar-scanner-cli-3.2.0.1227-linux.zip \
  && mv sonar-scanner-3.2.0.1227-linux /usr/local/bin/sonar-scanner \
  && rm sonar-scanner-cli-3.2.0.1227-linux.zip

ENV SONAR_RUNNER_HOME=/usr/local/bin/sonar-scanner
ENV PATH=$PATH:/usr/local/bin/sonar-scanner/bin

ENV HOME /home/${user}
RUN groupadd -g ${gid} ${group}
RUN useradd -c "EC2 user" -d /home/ec2-user -u ${uid} -g ${gid} -m ec2-user
RUN useradd -c "Jenkins user" -d $HOME -g ${gid} -m ${user}

WORKDIR /app