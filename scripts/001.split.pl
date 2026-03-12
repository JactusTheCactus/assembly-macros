#!/usr/bin/env perl
while (<>) {
	for my $line (split(/;\s*/, $_)) {
		print "$line\n";
	}
}
