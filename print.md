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
s=src/$1.s
m=macro/$1
cp "$s" "$m.0.s"
c=$m.0
for i in scripts/*; do
	c_=$c
	c=$m.${i#scripts/}
	c=${c%.pl}
	"./$i" < "$c_.s" > "$c.s"
done
d=dist/$1.o
as "$c.s" -o "$d"
b=bin/$1
if ld "$d" -o "$b"
	then rm -rf dist
fi
"./$b"
```
# `scripts/1.split.pl`
```pl
#!/usr/bin/env perl
while (<>) {
	my @lines = split(/;\s*/, $_);
	for my $line (@lines) {
		print "$line\n";
	}
}
```
# `scripts/2.main.pl`
```pl
#!/usr/bin/env perl
print
	".global _start\n" .
	".intel_syntax noprefix\n\n" .
	"_start:\n";
while (<>) {
	print $_;
}
```
# `scripts/3.exit.pl`
```pl
#!/usr/bin/env perl
while (<>) {
	my $line = $_;
	$line =~ s|\$exit (\d+)|
		"\tmov rax, 60\n" .
		"\tmov rdi, $1\n" .
		"\tsyscall\n"
	|ge;
	print $line;
}
```
# `scripts/4.log.pl`
```pl
#!/usr/bin/env perl
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
		"\tmov rax, 1\n" .
		"\tmov rdi, $rdi\n" .
		"\tlea rsi, [$id]\n" .
		"\tmov rdx, $len\n" .
		"\tsyscall\n"
	!ge;
	print $line;
}
print ".section .rodata\n\n";
while (my ($i, $s) = each %strings) {
	print
		"$i:\n" .
		"\t.asciz \"$s\\n\"\n";
}
```
# `src/main.s`
```s
$echo "Hello, World!"; $exit 0
```
