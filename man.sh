#!/usr/bin/env bash
set -uo pipefail
{
	name=amc86
	C='\fR'
	I='\fI'
	B='\fB'
	section() {
		printf '.SH %s\n' "${*^^}"
	}
	printf '.TH %s 1\n' "${name^^}"
	section name
	x86='x86-64 assembly'
	printf '%s - %s\n' "$name" "$x86 macro compiler"
	args=(
		"${I}FILE$C"
		"$B-h?$C|$B--help$C"
	)
	section synopsis
	printf '.B %s\n' "$name"
	name=$B$name$C
	printf '[%s]\n' "${args[@]}"
	desc=$(cat <<- EOF
		$name is a tool that compiles programs
		written in a shell-like DSL into $I$x86$C,
		assembles the result,
		and links it into a binary.
	EOF
	)
	section description
	printf '.P\n%s\n' "$desc"
	declare -A cmd=(
		[-? -h --help]='Display usage information.'
		["${I}FILE$C"]='Input '"$name"' source file'
	)
	section options
	while read -r i; do
		read -r -a args_a <<< "$i"
		# shellcheck disable=2046
		printf -v args_s '%s, ' $(printf '%s\n' "${args_a[@]}" | sort)
		printf '.TP\n.B %s' "${args_s%, }"
		printf '\n%s\n' "${cmd[$i]}"
	done < <(printf '%s\n' "${!cmd[@]}" | sort)
	section commands
	declare -A cmd=(
		[echo MESSAGE:str]="Write ${I}MESSAGE$C to standard output."
		[err ERROR:str]="Write ${I}ERROR$C to standard error."
		[exit CODE:u8]="Terminate the program with exit code ${I}CODE$C."
	)
	while read -r i
		do printf '.TP\n.B %s\n%s\n' "$i" "${cmd[$i]}"
	done < <(printf '%s\n' "${!cmd[@]}" | sort)
	section lexical rules
	declare -A rules=(
		[Strings]="Strings are quoted with single quotes (') or double quotes (\")."
		[Comments]="Text following a hash (#) is commented out. ${I}(Not yet implemented)$C"
		[Whitespace]='Tokens are separated by whitespace.'
		[Commands]="Commands are prefixed with a dollar sign '$'"
		[Statements]='Statements must be split with either semicolons (;) or newlines (\\n).'
	)
	while read -r i
		do printf '.TP\n.B %s\n%s\n' "$i" "${rules[$i]}"
	done < <(printf '%s\n' "${!rules[@]}" | sort)
	section examples
	# shellcheck disable=2016
	examples=(
		'$echo "Hello, World!"; $exit 0'
		"\$err 'Uh-Oh!'; \$exit 1"
	)
	while read -r i
		do printf '.P\n%s\n' "$i"
	done < <(printf '%s\n' "${examples[@]}" | sort)
	section exit status
	codes=(
		'Success.'
		'Invalid Arguments.'
		'Macro compilation error.'
		'Assembler error.'
		'Linker error.'
	)
	for c in "${!codes[@]}"; do
		printf '.TP\n.B %s\n%s\n' "$c" "${codes[$c]}"
	done
} | perl -pe 's|-|\\-|g' > man.1
