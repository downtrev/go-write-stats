#!/bin/bash
USAGE='Usage: "post2slack <STAGE|PROD>"'
ENVIRONMENT=${1^^}
if [ "${ENVIRONMENT}" == 'STAGE' ]; then  echo ${ENVIRONMENT};
elif [ "${ENVIRONMENT}" == 'PROD' ]; then  echo ${ENVIRONMENT};
else
    echo $USAGE
    exit 1
fi
PRODUCT="adcenter"
BRANCH=`git rev-parse --abbrev-ref HEAD`
WORK_DIR=`pwd`
AGENT=`echo ${HOSTNAME} |sed 's/\..*//g'`
GO_REVISION=`git log -n 1 --date=short --pretty=format:"%H"`
ARTIFACT=`git log -n 1 --date=short --pretty=format:"%H"`
AUTHOR_NAME=`git log -n 1 --pretty=format:"%cn"`
AUTHOR_NAME=`echo $AUTHOR_NAME |sed 's| |_|g'`
AUTHOR_EMAIL=`git log -n 1 --pretty=format:"%ae"`
COMMIT_DATE=`git log -n 1 --date=short --pretty=format:"%cd"`
COMMIT_MESSAGE=`git log -n 1 --pretty=format:"%s"`
GO_TRIGGER_USER=`echo ${USER}`
GO_PIPELINE_NAME="${PRODUCT}.${ENVIRONMENT}.Deployment"
GO_PIPELINE_COUNTER=1
GO_PIPELINE_LABEL=1
GO_STAGE_COUNTER=1
GO_STAGE_NAME="${PRODUCT}.${ENVIRONMENT}.Install"
GO_JOB_NAME="install.the.code"
EPOCH_TIME=`date +%s%N`
if [[ "${HOSTNAME}" == *q.qa* ]]; then  GO_ENVIRONMENT_NAME="QA_Build_Installs";else  GO_ENVIRONMENT_NAME="Production_Installs"; fi
echo ""
echo ""
echo "======================================="
curl -x http://squid.dfw2.lijit.com:3128 -i -XPOST 'http://build3.dfw2.lijit.com:8086/write?db=go' --data-binary "test,environment=$GO_ENVIRONMENT_NAME,product=$PRODUCT,pipeline_name=$GO_PIPELINE_NAME,stage_name=$GO_STAGE_NAME,job_name=$GO_JOB_NAME,agent=$AGENT,artifact=$ARTIFACT,trigger_user=$GO_TRIGGER_USER,author_name=$AUTHOR_NAME,author_email=$AUTHOR_EMAIL pipeline_counter=$GO_PIPELINE_COUNTER,pipeline_label=\"$GO_PIPELINE_LABEL\",stage_counter=$GO_STAGE_COUNTER,work_dir=\"$WORK_DIR\",revision=\"$GO_REVISION\",commit_date=\"$COMMIT_DATE\",commit_message=\"$COMMIT_MESSAGE\" $EPOCH_TIME"
echo "======================================="
echo ""
echo ""
SLACK_URL="https://hooks.slack.com/services/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"
SLACK_CHANNEL="production-release"
SLACK_MESSAGE="--${PRODUCT} [${BRANCH}] deployed to ${ENVIRONMENT}, with version $GO_PIPELINE_LABEL"
SLACK_MESSAGE=$(echo $SLACK_MESSAGE | sed 's/"/\"/g' | sed "s/'/\'/g" )
JSON="{\"channel\": \"$SLACK_CHANNEL\", \"icon_emoji\":\"robot_face\", \"text\": \"$SLACK_MESSAGE\"}"
curl -s -d "payload=$JSON" "$SLACK_URL"
