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
