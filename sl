#!/usr/bin/env bash

##
# Create a screenshot using maim, optipng it, then dump it in ~/dumpdir for
# dumpwatch to upload it to the appropriate server.
#
# This script requires dumpwatch to already be running.
#

set -o errexit

if [[ -z "$TMPDIR" ]]; then
	TMPDIR=/tmp
fi

file=$(mktemp -u XXXXXXXXXX.png)

maim "$TMPDIR"/"$file"
optipng "$TMPDIR"/"$file"

mv "$TMPDIR"/"$file" "$HOME"/dumpdir/"$file"
