print ".global _start\n.intel_syntax noprefix\n_start:\n";
while (<>) {
	print $_;
}
