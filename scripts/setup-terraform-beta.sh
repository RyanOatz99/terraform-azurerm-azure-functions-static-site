#!/bin/bash
#====================================
# Requires the following commands
# - curl
# - unzip
# - jq
# apt update -qq && apt install curl jq unzip -yqqqq
#====================================

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT_NAME="$( basename "${BASH_SOURCE[0]}")"
VERSION="$1"

PROJECT_TEMP="$SCRIPT_DIR/../.temp"

>&2 echo "Creating project temporary directory if it does not yet exist..."
mkdir -p "$PROJECT_TEMP"

function get-architecture() {
  echo "`uname`" | sed 's/.*/\L&/'
}

function get-platform() {
  case "`uname -m`" in

    x86_64)
      echo "amd64"
      ;;

    i386 | i686)
      echo "386"
      ;;

    aarch64_be | aarch64 | armv8b | armv8l | aarch64_be | aarch64_be)
      echo "arm64"
      ;;

    *)
      >&2 echo "Error Unable to determine platform for 'uname -m' == '`uname -m`'. Exiting script in failure"
      exit 1
      ;;
  esac
}

ARCH="`get-architecture`"
PLATFORM="`get-platform`"

if [ -z "$VERSION" ]
then
  >&2 echo "Terraform version argument was not passed to install-terraform.sh"
  >&2 echo "Checking for latest released version..."
  VERSION="`curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq '.current_version' -r`"
  >&2 echo "VERSION='$VERSION'"
else
  >&2 echo "Terraform version argument passed was '$VERSION'."
fi

ZIP_FILE="$PROJECT_TEMP/tf.zip"
URL="https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_${ARCH}_${PLATFORM}.zip"
>&2 echo "Attempting to download Terraform archive to path '$ZIP_FILE' from '$URL'..."
curl -s "$URL" -o "$ZIP_FILE"

>&2 echo "Unzipping file '$ZIP_FILE' to '$PROJECT_TEMP'..."
unzip -oq "$ZIP_FILE" -d "$PROJECT_TEMP"

>&2 echo "Assigning rx permissions to terraform file..."
chmod 555 "$PROJECT_TEMP/terraform"

>&2 echo "Removing temp zip file..."
rm "$ZIP_FILE"

echo "$PROJECT_TEMP/terraform"