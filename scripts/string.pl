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
		if ($mode == "echo") {
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
