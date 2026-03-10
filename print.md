Thoughts?
# `main.sh`
```sh
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
```
# `scripts/exit.pl`
```pl
while (<>) {
	my $line = $_;
	$line =~ s|\$exit (\d+)|mov rax, 60\nmov rdi, $1\nsyscall|g;
	print $line;
}
```
# `scripts/log.pl`
```pl
use bytes;
my %strings;
while (<>) {
	my $line = $_;
	my $mode;
	my $id;
	my $str;
	$line =~ s!\$(echo|err) "(.*?)"!
		$mode = $1;
		$str = $2;
		$id = "\L$str";
		$id =~ s|[^a-z]+|_|g;
		$id =~ s/^_|_$//g;
		my $len = length($str) + 1;
		$strings{$id} = $str;
		my $rdi;
		if ($mode eq "echo") {
			$rdi = 1;
		} else {
			$rdi = 2;
		}
		"mov rax, 1\nmov rdi, $rdi\nlea rsi, [$id]\nmov rdx, $len\nsyscall"
	!ge;
	print "$line";
}
print ".section .rodata\n";
while (my ($i, $s) = each %strings) {
	print "$i:\n.asciz \"$s\\n\"\n";
}
```
# `scripts/main.pl`
```pl
print ".global _start\n.intel_syntax noprefix\n_start:\n";
while (<>) {
	print $_;
}
```
# `src/main.s`
```s
$echo "Hello, World!"
$exit 0
```
