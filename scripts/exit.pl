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
