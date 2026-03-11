#!/usr/bin/env bash
set -uo pipefail
dirs=(
	bin
	dist
	macro
)
rm -rf "${dirs[@]}"
mkdir -p "${dirs[@]}"
s=src/$1.s
m=macro/$1
d=dist/$1.o
b=bin/$1
cp "$s" "$m.s"
for i in scripts/*; do
	c=$m.${i#scripts/}
	c=${c%.pl}
	"./$i" < "$m.s" > "$c.s"
	cp "$c.s" "$m.s"
done
as "$m.s" -o "$d"
ld "$d" -o "$b"
"./$b"
