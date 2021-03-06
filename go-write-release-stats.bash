WORK_DIR=`pwd`
AGENT=`echo $WORK_DIR |sed 's|\/|\n|g' |grep agent`
GIT_REV=`echo $GO_REVISION |sed 's/.//8g'`
ENV_FLAG=`echo $GO_ENVIRONMENT_NAME |cut -c 1`
PATTERN="*${GIT_REV}*${ENV_FLAG}*.deb"
ARTIFACT=`find . -name $PATTERN |sed 's!.*\/!!g'`
AUTHOR_NAME=`git log -n 1 --pretty=format:"%an"`
AUTHOR_NAME=`echo $AUTHOR_NAME |sed 's| |_|g'` 
AUTHOR_EMAIL=`git log -n 1 --pretty=format:"%ae"`
COMMIT_DATE=`git log -n 1 --date=short --pretty=format:"%cd"`
COMMIT_MESSAGE=`git log -n 1 --pretty=format:"%s"`
EPOCH_TIME=`date +%s%N`
echo ""
echo ""
echo "======================================="
curl -x http://squid.dfw2.lijit.com:3128 -i -XPOST 'http://build3.dfw2.lijit.com:8086/write?db=go' --data-binary "test,environment=$GO_ENVIRONMENT_NAME,product=#{COMPONENT},pipeline_name=$GO_PIPELINE_NAME,stage_name=$GO_STAGE_NAME,job_name=$GO_JOB_NAME,agent=$AGENT,artifact=$ARTIFACT,trigger_user=$GO_TRIGGER_USER,author_name=$AUTHOR_NAME,author_email=$AUTHOR_EMAIL pipeline_counter=$GO_PIPELINE_COUNTER,pipeline_label=\"$GO_PIPELINE_LABEL\",stage_counter=$GO_STAGE_COUNTER,work_dir=\"$WORK_DIR\",revision=\"$GO_REVISION\",commit_date=\"$COMMIT_DATE\",commit_message=\"$COMMIT_MESSAGE\" $EPOCH_TIME"
echo "======================================="
echo ""
echo ""
