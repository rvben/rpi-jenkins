#!/bin/sh
# Adapted from: https://github.com/SvenDowideit/docs-automation/blob/master/jenkins/setup-docker-and-start-jenkins.sh

set -e

DOCKER_GID=$(ls -aln /var/run/docker.sock  | awk '{print $4}')

if ! getent group $DOCKER_GID; then
	echo creating docker group $DOCKER_GID
	addgroup --gid $DOCKER_GID docker
fi

if ! getent group $JENKINS_GID; then
	echo creating $JENKINS_USER group $JENKINS_GID
	addgroup --gid $JENKINS_GID $JENKINS_USER
fi

if ! getent passwd $JENKINS_USER; then
	echo useradd -N --gid $JENKINS_GID -u $JENKINS_UID $JENKINS_USER
	useradd -N --gid $JENKINS_GID -u $JENKINS_UID $JENKINS_USER
fi

DOCKER_GROUP=$(ls -al /var/run/docker.sock  | awk '{print $4}')
if ! id -nG "$JENKINS_USER" | grep -qw "$DOCKER_GROUP"; then
	adduser $JENKINS_USER $DOCKER_GROUP
fi

chown -R $JENKINS_USER:$JENKINS_USER $JENKINS_HOME /usr/share/jenkins/ref

exec su $JENKINS_USER -c "/usr/local/bin/jenkins.sh"
