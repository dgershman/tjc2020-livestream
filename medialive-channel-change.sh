#!/bin/bash

if [ "$1" == "start" ] | [ "$1" == "stop" ]; then
  aws medialive $1-channel --channel-id $2 --output table
fi
