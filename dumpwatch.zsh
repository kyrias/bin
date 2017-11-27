#!/usr/bin/env zsh
#
# dumpwatch.zsh - Uploads everything put in ~/dumpdir to a server and copies the public URL
#
# Dependencies:
#   ssh
#   xsel or xclip
#   inotify-tools

if [[ -z "$dump_host" ]]; then
	dump_host=theos.kyriasis.com
fi

if [[ -z "$dump_user" ]]; then
	dump_user="$USER"
fi

while read -r file; do
	scp -o BatchMode=yes -q "$HOME"/dumpdir/"$file" "$dump_host":public_html/d/

	url="$(ssh -o BatchMode=yes -q "$dump_host" printf '%s' https://"$dump_host"/~'$USER'/d/"$file")"
	printf "Dumped file %s to %s. URL: %s\n" "$file" "$dump_host" "$url"
	if command -v xsel &>/dev/null; then
		printf "%s" "$url" | xsel --clipboard --input
	elif command -v xclip &>/dev/null; then
		printf "%s" "$url" | xclip -selection clipboard
	else:
		printf "Neither xclip nor xsel found, can't copy to clipboard\n"
	fi

done < <(inotifywait -me create --format '%f' "$HOME"/dumpdir)
