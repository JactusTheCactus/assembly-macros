#!/usr/bin/env bash
set -uo pipefail
dirs=(
	bin
	dist
	macro
)
rm -rf "${dirs[@]}"
mkdir -p "${dirs[@]}"
s=src/main.s
m=macro/main
o=dist/main.o
b=bin/main
cp "$s" "$m.s"
for i in scripts/*; do
	c=$m.${i#scripts/}
	c=${c%.pl}
	perl "$i" < "$m.s" > "$c.s"
	cp "$c.s" "$m.s"
done
cat "$m.s"
as "$m.s" -o "$o"
ld "$o" -o "$b"
"./$b"
