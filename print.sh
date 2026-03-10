#!/usr/bin/env bash
exec > print.md
echo 'Thoughts?'
while read -r i; do
	echo "# \`$i\`"
	echo '```'"${i##*.}"
	cat "$i"
	echo '```'
done < <(find main.sh scripts src -type f | sort)
