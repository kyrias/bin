#!/usr/bin/env bash

set -o errexit

id=$(mktemp /tmp/XXXXXXXXXX).png
host='theos.kyriasis.com'
url="https://$host/~kyrias/s/$(basename $id)"

scrot "$id"
scp -q "$id" "$host":public_html/s/
rm "$id"

printf "URL: %s\n" "$url"
printf "%s\n" "$url" | xclip -selection clipboard
