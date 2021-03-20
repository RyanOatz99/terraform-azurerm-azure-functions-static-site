#!/bin/bash
#====================================
# Requires the following packages
# - dotnet (version ~> 3.1)
#====================================

STATIC_CONTENT_DIR="$1"

echo "Setting up directory paths..."
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TEMP_DIR="$( cd "$SCRIPT_DIR/.." && pwd)/.temp"
TEMP_PACKAGE_CONTENTS_DIR="$TEMP_DIR/package"
TEMP_CONTENT_DIR="$TEMP_PACKAGE_CONTENTS_DIR/www"
AZ_FN_SLN_DIR="$( cd "$SCRIPT_DIR/../function" && pwd)"

echo "   Script directory: '$SCRIPT_DIR'"
echo "   Azure Function solution directory: '$AZ_FN_SLN_DIR'"
echo "   Static content directory: '$STATIC_CONTENT_DIR'"
echo "   Package temporary directory: '$TEMP_DIR'"
echo "   Package temporary content directory: '$TEMP_CONTENT_DIR"

# Test whether the passed arg is a valid directory...
if [ ! -d "$STATIC_CONTENT_DIR" ]
then
  echo "Directory not found at path: $STATIC_CONTENT_DIR. Exiting with failure..."
  exit 1
fi

echo "Clearing out temp directory..."
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_CONTENT_DIR"

echo "Restoring packages for Azure Function project..."
dotnet restore "$AZ_FN_SLN_DIR"

echo "Build Azure Functions app..."
dotnet build "$AZ_FN_SLN_DIR"

echo "Testing Azure Functions app..."
dotnet test "$AZ_FN_SLN_DIR"

echo "Publish Azure Functions app to the $TEMP_PACKAGE_CONTENTS_DIR..."
dotnet publish "$AZ_FN_SLN_DIR" --output "$TEMP_PACKAGE_CONTENTS_DIR"

echo "Copying the static content from '$STATIC_CONTENT_DIR' to '$TEMP_CONTENT_DIR'..."
cp -r "$STATIC_CONTENT_DIR" "$TEMP_CONTENT_DIR"
