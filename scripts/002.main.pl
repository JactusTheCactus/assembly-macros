#!/usr/bin/env perl
print
	".global _start\n" .
	".intel_syntax noprefix\n\n" .
	"_start:\n";
while (<>) {
	print $_;
}
