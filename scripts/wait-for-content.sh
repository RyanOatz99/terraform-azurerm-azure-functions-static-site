#!/bin/bash
set -e

function init() {
  >&2 echo "Initializing arguments and path variables..."
  TIMEOUT_SECONDS=120 #Default

  while [ $# -gt 0 ]; do
    case "$1" in
      --url=*)
        URL="`echo "${1#*=}" | sed 's:/*$::'`"
        ;;
      --timeout-seconds=*)
        TIMEOUT_SECONDS="`echo "${1#*=}" | sed 's:/*$::'`"
        ;;
      *)
        >&2 printf "***************************\n"
        >&2 printf "* Error: Invalid argument.*\n"
        >&2 printf "    Argument: '$1'"
        >&2 printf "***************************\n"
        exit 1
    esac
    shift
  done

  if [ -z "$URL" ]
  then
    echo "--url argument not passed. Exiting script with error."
    exit 1
  fi
}
wait-for-url() {
  echo "Waiting up to $TIMEOUT_SECONDS seconds for  $1"
  timeout -s TERM "$TIMEOUT_SECONDS" bash -c \
  'while [[ "$(curl -s -o /dev/null -L -w ''%{http_code}'' ${0})" != "200" ]];\
  do echo "`date` - Waiting for ${0}..." && sleep 5;\
  done' ${1}
  echo "OK!"
  curl -sv $1
}

init "$@"
wait-for-url "$URL"
