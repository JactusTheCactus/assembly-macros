#!/usr/bin/env perl
while (<>) {
	my @lines = split(/;\s*/, $_);
	for my $line (@lines) {
		print "$line\n";
	}
}
