#!/bin/bash

VERSION=$1
RELEASE=$2
AGENT_NAME=upstart
URL=https://github.com/thanandorn/mcollective-upstart-agent
MAINTAINER=thanandorn@gmail.com
CATEGORY="System Tools"
LICENSE=MIT
DESC="MCollective Agent to manage the Upstart Services."

if [ $# != 2 ]; then
  echo "Usage: rpmbuild.sh <version> <release>"
  exit 1
else
  fpm -s dir -t rpm -n mcollective-${AGENT_NAME}-common -v $VERSION -a noarch -m $MAINTAINER --license $LICENSE --url $URL --epoch 0 --iteration $RELEASE --category "${CATEGORY}" --description "${DESC}" -d mcollective-common agent/${AGENT_NAME}.ddl=/usr/libexec/mcollective/mcollective/agent/
  fpm -s dir -t rpm -n mcollective-${AGENT_NAME}-agent -v $VERSION -a noarch -m $MAINTAINER --license $LICENSE --url $URL --epoch 0 --iteration $RELEASE --category "${CATEGORY}" --description "${DESC}" -d mcollective-common -d mcollective-${AGENT_NAME}-common agent/${AGENT_NAME}.rb=/usr/libexec/mcollective/mcollective/agent/
  fpm -s dir -t rpm -n mcollective-${AGENT_NAME}-client -v $VERSION -a noarch -m $MAINTAINER --license $LICENSE --url $URL --epoch 0 --iteration $RELEASE --category "${CATEGORY}" --description "${DESC}" -d mcollective-common -d mcollective-${AGENT_NAME}-common application/${AGENT_NAME}.rb=/usr/libexec/mcollective/mcollective/application/
fi
