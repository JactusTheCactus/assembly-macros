#!/usr/bin/env perl
use bytes;
my @types = (
	qr|str(?:ing)?|i
);
my %vars;
sub fn_let {
	my ($type, $var, $str) = @_;
	my $fail = 1;
	for my $r (@types) {
		if ($type =~ $r) {
			$fail = 0;
			last;
		}
	}
	if ($fail) {
		die "'$type' is not a valid type.";
	}
	my $len = 1 + length $str;
	$vars{$var} = $str;
	return;
}
while (<>) {
	my $line = $_;
	$line =~ s/\$let (\w[\w\d]*) (.*?) = "(.*?)"/fn_let($1, $2, $3);/gei;
	print $line;
}
print ".section .rodata\n\n";
while (my ($var, $str) = each %vars) {
	print
		"$var:\n" .
		"\t.asciz \"$str\\n\"\n";
}
