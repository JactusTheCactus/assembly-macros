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
m=macro/main.s
o=dist/main.o
b=bin/main
cp "$s" "$m"
for i in scripts/*; do
	"./$i" < "$m" > "$m.1"
	mv "$m.1" "$m"
done
as "$m" -o "$o"
gcc "$o" -o "$b" -nostdlib -static
"./$b"
