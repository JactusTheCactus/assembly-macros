#!/usr/bin/env bash
set -uo pipefail
src=$(cat <<- 'EOF'
	echo "Hello," "World!"; exit 0
	err "Uh-Oh!"; exit 1.0
EOF
)
./test.pl <<< "$src" | jq -r '.'
