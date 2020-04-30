#!/bin/bash

set -o pipefail

if test -f "myvars.sh"; then
    source myvars.sh
fi

if [ -z "$CLUSTER" ]
then
   echo "You need a \$CLUSTER to connect to"
   echo "export CLUSTER=yourcluster.example.com"
   exit 1
fi
if [ -z "$APIKEY" ]
then
   echo "You need a \$APIKEY to connect to"
   echo "export APIKEY=yourcluster.example.com"
   exit 1
fi
PROJECT=temp-hello-world
EPOCH=`date +%s`
DOCKERIMAGE=node:10
APPNAME=hello-world

if ! [ -x "$(command -v awk)" ]; then
  echo 'Error: awk is not installed, or not in path.' >&2
  exit 1
fi
if ! [ -x "$(command -v curl)" ]; then
  echo 'Error: curl is not installed, or not in path.' >&2
  exit 1
fi
if ! [ -x "$(command -v grep)" ]; then
  echo 'Error: grep is not installed, or not in path.' >&2
  exit 1
fi
if ! [ -x "$(command -v jq)" ]; then
  echo 'Error: jq is not installed, or not in path.' >&2
  exit 1
fi
if ! [ -x "$(command -v ibmcloud)" ]; then
  echo 'Error: ibmcloud is not installed, or not in path.' >&2
  exit 1
fi
if ! [ -x "$(command -v oc)" ]; then
  echo 'Error: oc is not installed, or not in path.' >&2
  exit 1
fi

ibmcloud login --apikey ${APIKEY}

SERVER_URL=$(ibmcloud ks cluster get --cluster $CLUSTER --json | jq ".serverURL")

oc login -u apikey -p ${APIKEY} --server=${SERVER_URL//\"} --insecure-skip-tls-verify=true

oc new-project ${PROJECT}-${EPOCH}

oc new-build --strategy docker --binary --docker-image ${DOCKERIMAGE} --name ${APPNAME}

oc start-build ${APPNAME} --from-dir . --follow

oc new-app ${PROJECT}-${EPOCH}/${APPNAME}:latest

oc expose svc/"${APPNAME}"

TEST="$(oc status | grep "appdomain.cloud" | awk {'print $1'})"

curl --silent ${TEST} | grep Webhook > /dev/null 2>&1
if [ $? -ne 1 ]
then
  echo "It seems that the app didnt tell you Webhook, something is broken."
  exit 1
fi

oc delete project ${PROJECT}-${EPOCH}
