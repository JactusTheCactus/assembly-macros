while (<>) {
	my $line = $_;
	$line =~ s|\$exit (\d+)|mov rax, 60\nmov rdi, $1\nsyscall|g;
	print $line;
}
