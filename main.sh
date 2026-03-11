#!/usr/bin/env bash
set -uo pipefail
main() {
	dirs=(
		bin
		dist
		macro
	)
	rm -rf "${dirs[@]}"
	mkdir -p "${dirs[@]}"
	s=src/$1.s
	m=macro/$1
	c=$m.000
	d=dist/$1.o
	b=bin/$1
	compile() {
		cp "$s" "$m.000.s"
		for i in scripts/*; do
			c_=$c
			c=$m.${i#scripts/}
			c=${c%.pl}
			"./$i" < "$c_.s" > "$c.s"
		done
	}
	assemble() {
		as "$c.s" -o "$d"
	}
	link() {
		if ld "$d" -o "$b"
			then rm -rf dist
		fi
	}
	if compile
		then if assemble
			then if link
				then "./$b"
			else
				echo "Linking failed." >&2
				return 4
			fi
		else
			echo "Assembly failed." >&2
			return 3
		fi
	else
		echo "Macro compilation failed." >&2
		return 2
	fi
}
if (( $# != 1 )); then
	man ./man.1
	exit 1
else
	for i in "$@"
		do case "$i" in
			'-?'|-h|--help)help;;
			*)main "$i";;
		esac
	done
fi
