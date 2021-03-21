#!/bin/bash
#====================================
# Requires the following packages
# - dotnet (version ~> 3.1)
#====================================

function init() {
  >&2 echo "Initializing arguments and path variables..."

  while [ $# -gt 0 ]; do
    case "$1" in
      --static-content-dir=*)
        #STATIC_CONTENT_DIR="`strip-trailing-slashes "${1#*=}"`"
        STATIC_CONTENT_DIR="`echo "${1#*=}" | sed 's:/*$::'`"
        ;;
      --temp-dir=*)
        # TEMP_DIR="`strip-trailing-slashes "${1#*=}"`"
        TEMP_DIR="`echo "${1#*=}" | sed 's:/*$::'`"
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

  # Check for required args...
  FAIL_MESSAGE=""
  if [ -z "$TEMP_DIR" ]
  then
    FAIL_MESSAGE="Argument 'temp-dir' must be passed\n"
  fi

  if [ -z "$STATIC_CONTENT_DIR" ]
  then
    FAIL_MESSAGE="${FAIL_MESSAGE}Argument 'static-content-dir' must be passed\n"
  fi

  if [ ! -z "$FAIL_MESSAGE" ]
  then
    >&2 printf "$FAIL_MESSAGE"
    exit 1
  fi

  SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
  TEMP_PACKAGE_CONTENTS_DIR="$TEMP_DIR/package"
  TEMP_CONTENT_DIR="$TEMP_PACKAGE_CONTENTS_DIR/www"
  AZ_FN_SLN_DIR="$( cd "$SCRIPT_DIR/../function" && pwd)"

  >&2 echo "   This script's dir:             '$SCRIPT_DIR'"
  >&2 echo "   Static content dir:            '$STATIC_CONTENT_DIR'"
  >&2 echo "   Package temporary dir:         '$TEMP_DIR'"
  >&2 echo "   Azure Function solution dir:   '$AZ_FN_SLN_DIR'"
  >&2 echo "   Package temporary content dir: '$TEMP_CONTENT_DIR"

  # Static content directory doesn't exist
  if [ ! -d "$STATIC_CONTENT_DIR" ]
  then
    >&2 echo "Directory not found at path: $STATIC_CONTENT_DIR. Exiting with failure..."
    exit 1
  fi

  # Static content directory doesn't exist
  if [ ! -d "$TEMP_DIR" ]
  then
    >&2 echo "Directory not found at path: $TEMP_DIR. Exiting with failure..."
    exit 1
  fi

  >&2 echo "Clearing out temp directory..."
  rm -rf "$TEMP_DIR"
  mkdir -p "$TEMP_CONTENT_DIR"

}

function publish-function-project() {
  >&2 echo "Restoring packages for Azure Function project..."
  dotnet restore "$AZ_FN_SLN_DIR"

  >&2 echo "Build Azure Functions app..."
  dotnet build "$AZ_FN_SLN_DIR"

  >&2 echo "Testing Azure Functions app..."
  dotnet test "$AZ_FN_SLN_DIR"

  >&2 echo "Publish Azure Functions app to the $TEMP_PACKAGE_CONTENTS_DIR..."
  dotnet publish "$AZ_FN_SLN_DIR" --output "$TEMP_PACKAGE_CONTENTS_DIR"
}

init "$@"

publish-function-project

>&2 echo "Copying the static content from '$STATIC_CONTENT_DIR' to '$TEMP_CONTENT_DIR'..."
cp -r "$STATIC_CONTENT_DIR/"* "$TEMP_CONTENT_DIR"
