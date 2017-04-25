#!/bin/bash

# Usage: slackpost "<webhook_url>" "<channel>" "<message>"

webhook_url=$1
if [[ $webhook_url == "" ]]
then
        echo "No webhook_url!"
        exit 1
fi
shift
channel=$1
if [[ $channel == "" ]]
then
        echo "No channel!"
        exit 1
fi
shift
message=$*

if [[ $message == "" ]]
then
        echo "No message!"
        exit 1
fi
escapedText=$(echo $message | sed 's/"/\"/g' | sed "s/'/\'/g" )
json="{\"channel\": \"$channel\", \"text\": \"$escapedText\"}"

curl -s -d "payload=$json" "$webhook_url"
