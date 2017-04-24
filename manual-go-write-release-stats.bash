#!/bin/bash
PRODUCT="adcenter"
BRANCH=`git rev-parse --abbrev-ref HEAD`
WORK_DIR=`pwd`
AGENT=`echo ${HOSTNAME} |sed 's/\..*//g'`
GO_REVISION=`git log -n 1 --date=short --pretty=format:"%H"`
ARTIFACT=`git log -n 1 --date=short --pretty=format:"%h"`
AUTHOR_NAME=`git log -n 1 --pretty=format:"%cn"`
AUTHOR_NAME=`echo $AUTHOR_NAME |sed 's| |_|g'`
AUTHOR_EMAIL=`git log -n 1 --pretty=format:"%ae"`
COMMIT_DATE=`git log -n 1 --date=short --pretty=format:"%cd"`
COMMIT_MESSAGE=`git log -n 1 --pretty=format:"%s"`
GO_TRIGGER_USER=`echo ${USER}`
GO_PIPELINE_NAME="${PRODUCT}.${BRANCH}.Deployment"
GO_PIPELINE_COUNTER=1
GO_PIPELINE_LABEL=1
GO_STAGE_COUNTER=1
GO_STAGE_NAME="${PRODUCT}.${BRANCH}.Install"
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
