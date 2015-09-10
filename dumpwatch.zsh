#!/usr/bin/env zsh

if [[ -z "$dump_host" ]]; then
	dump_host=theos.kyriasis.com
fi

if [[ -z "$dump_user" ]]; then
	dump_user="$USER"
fi

while read -r file; do
	scp -q "$HOME"/dumpdir/"$file" "$dump_host":public_html/d/

	url="https://$dump_host/~$dump_user/d/$file"
	printf "Dumping file %s to %s. URL: %s\n" "$file" "$dump_host" "$url"
	printf "%s\n" "$url" | xclip -selection clipboard

done < <(inotifywait -me create --format '%f' "$HOME"/dumpdir)
