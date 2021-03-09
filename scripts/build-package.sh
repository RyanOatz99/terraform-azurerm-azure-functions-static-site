#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
TEMP_DIR="$( cd "$SCRIPT_DIR/.." && pwd)/.temp"

# Clean up directory for package
rm -rf "$TEMP_DIR"
mkdir -p "$TEMP_DIR"





