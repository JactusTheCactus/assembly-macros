#!/usr/bin/env perl
use bytes;
my %strings;
while (<>) {
	my $line = $_;
	my $id;
	my $len;
	my $rdi;
	$line =~ s!\$(echo|err) "(.*?)"!
		$id = "\L$2";
		$id =~ s|[^a-z]+|_|g;
		$id =~ s/^_|_$//g;
		$len = length($2) + 1;
		$strings{$id} = $2;
		if ($1 == "echo") {
			$rdi = 1;
		} else {
			$rdi = 2;
		}
		"mov rax, 1\n\tmov rdi, $rdi\n\tlea rsi, [$id]\n\tmov rdx, $len\n\tsyscall"
	!ge;
	print "$line";
}
while (my ($i, $s) = each %strings) {
	print "$i:\n\t.asciz \"$s\\n\"\n";
}
