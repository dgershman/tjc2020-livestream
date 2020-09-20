#!/bin/bash

if [ "${1}" == "start" ] || [ "${1}" == "stop" ]; then
  echo "${1} triggered on streaming channel ${2}."
  aws medialive ${1}-channel --channel-id=${2} --output table
  echo "Clearing CDN cache for distribution ${3}"
  aws cloudfront create-invalidation --distribution-id=${3} --paths "/"
fi
