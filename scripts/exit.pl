#!/usr/bin/env perl
while (<>) {
	my $line = $_;
	$line =~ s|^\t\$exit (\d+)|\tmov rax, 60\n\tmov rdi, $1\n\tsyscall|g;
	print $line;
}
