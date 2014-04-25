#!/usr/bin/env bash

SCROTARGS=()
while (( "$#" )); do
	SCROTARGS+=($1)
	shift
done

# take the shot
FILE="$(scrot ${SCROTARGS[@]} -e 'echo -n $f')"

# upload it and grab the URL
printf "Uploading scrot\n"
JSON="$(curl -sf -F "files[]=@$FILE" http://pomf.se/upload.php)"
BASE="$(jshon -e files -e 0 -e url -u <<< $JSON)"

URL="http://a.pomf.se/$BASE"

# copy the URL to the clipboard
if [[ "$(type -p xclip)" ]]; then
	echo -n "$URL" | xclip -selection clipboard
	echo "$URL (has been copied to clipboard)"
else
	echo "$URL"
fi

rm -f "$FILE"
