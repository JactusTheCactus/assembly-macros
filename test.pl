#!/usr/bin/env perl
use strict;
use warnings;
use boolean;
sub stringify_token {
	print $_;
	# my ($cmd, $val) = @_;
	# my $val = $_;
	# my $type;
	# if ($val =~ /^".*?"$/) {
	# 	$type = "str";
	# } elsif ($val =~ /^\d+$/) {
	# 	$type = "int";
	# } elsif ($val =~ /^\d+\.\d*$/) {
	# 	$type = "dbl";
	# } else {
	# 	$type = "nul";
	# }
	# my $cmd = "CMD";
	# "{\"command\":\"$cmd\",\"type\":\"$type\",\"value\":\"$val\"}"
}
my $lines = "";
while (<>) {
	$lines = $lines . $_;
}
$lines =~ s|\n[\s\n]*|;|g;
$lines =~ s|;+|;|g;
my @obj = ();
for my $l (split(/;+\s*/, $lines)) {
	$l =~ s|^\s*(.*?)\s*$|$1|g;
	my @tokens;
	my $string = false;
	my $current = "";
	for my $c (split(//, $l)) {
		my $concat = true;
		if ($c eq "\"") {
			$string = !$string;
		}
		if (!$string) {
			if ($c =~ /\s/) {
				push(@tokens, $current);
				$current = "";
				$concat = false;
			}
		}
		if ($concat) {
			$current = $current . $c;
		}
	}
	push(@tokens, $current);
	my $cmd = shift(@tokens);
	for my $i (@tokens) {
		# push(@obj, $i);
		# print "$i\n";
	}
	my @val = ();
	for my $i (@tokens) {
		my $type;
		if ($i =~ /^".*?"$/) {
			$type = "string";
		} elsif ($i =~ /^\d+$/) {
			$type = "integer";
		} elsif ($i =~ /^\d+\.\d*$/) {
			$type = "float";
		} else {
			$type = "null";
		}
		push(@val, "{\"data\":$i,\"type\":\"$type\"}");
	}
	push(@obj, "{\"command\":\"$cmd\",\"arguments\":[" . join(",", @val) . "]}");
	# push(@obj, "{\"$cmd\":[" . join(", ", @tokens) . "]}");
}
print "[" . join(",", @obj) . "]";
