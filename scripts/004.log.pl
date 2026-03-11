#!/usr/bin/env perl
use bytes;
my %vars;
sub fn_log {
	my ($mode, $str) = @_;
	my $id;
	$id = "\L$str";
	$id =~ s|[^a-z]+|_|g;
	$id =~ s/^_|_$//g;
	$id = $id . "_" . scalar keys %vars;
	my $len = 1 + length $str;
	$vars{$id} = $str;
	my $rdi;
	if ($mode eq "echo") {
		$rdi = 1;
	} elsif ($mode eq "err") {
		$rdi = 2;
	}
	"\$let str $id = \"$str\"\n" .
	"\tmov rax, 1\n" .
	"\tmov rdi, $rdi\n" .
	"\tlea rsi, [rip + $id]\n" .
	"\tmov rdx, $len\n" .
	"\tsyscall\n"
}
while (<>) {
	my $line = $_;
	$line =~ s/\$(echo|err) "(.*?)"/fn_log($1, $2)/ge;
	print $line;
}
