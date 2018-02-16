FROM arm32v7/debian:9-slim

ENV JENKINS_VERSION="2.107" \
    JENKINS_UC=https://updates.jenkins.io \
    JENKINS_HOME=/var/jenkins_home \
    JENKINS_SLAVE_AGENT_PORT=50000 \
    JENKINS_USER=jenkins \
    JENKINS_GROUP=jenkins \
    JENKINS_UID=1000 \
    JENKINS_GID=1000 \
    COPY_REFERENCE_FILE_LOG=/var/jenkins_home/copy_reference_file.log \
    JAVA_OPTS="-server"

RUN apt-get update \
  && apt-get install -y bash git curl gpg gnupg-agent apt-transport-https ca-certificates software-properties-common \
  && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
  && add-apt-repository -y ppa:webupd8team/java \
  && apt-get update \
  && apt-get install -y oracle-java8-installer --allow-unauthenticated \
  && curl -sSL "https://get.docker.com/" | sh \
  && groupdel docker \
  && mkdir -p /usr/share/jenkins/ref/init.groovy.d \
  && curl -fsSL http://repo.jenkins-ci.org/public/org/jenkins-ci/main/jenkins-war/${JENKINS_VERSION}/jenkins-war-${JENKINS_VERSION}.war -o /usr/share/jenkins/jenkins.war \
  && curl -fsSL https://raw.githubusercontent.com/jenkinsci/docker/master/init.groovy -o /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy \
  && curl -fsSL https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins.sh -o /usr/local/bin/jenkins.sh \
  && curl -fsSL https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins-support -o /usr/local/bin/jenkins-support \
  && curl -fsSL https://github.com/krallin/tini/releases/download/v0.16.1/tini-static-armhf -o  /bin/tini \
  && chmod +x /bin/tini /usr/share/jenkins/ref/init.groovy.d/tcp-slave-agent-port.groovy /usr/local/bin/jenkins* \
  && apt-get purge -y gpg gnupg-agent apt-transport-https ca-certificates software-properties-common \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/* /usr/lib/jvm/java-8-oracle/src.zip

VOLUME /var/jenkins_home

EXPOSE 8080
EXPOSE 50000


COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/bin/tini", "--", "/entrypoint.sh"]
