# A Perl Module for parsing derml

use v5.26;									# Use perl version 5.26 and above

my %global;												# All Key-Value pairs found go in here
my $var_name_regex = qr{[a-zA-Z_][A-Za-z0-9_-]+};		# Regex for key and section names	

# Read lines from files specified at the terminal
while(<>) {
	next if /^\s*#/;							# Ignore comments
	simple_key_value_with_square_quote($_);
}

say "KEY: $_ <=> VALUE: " . $global{$_} for(keys %global);

# This sub routine checks if a line is a simple key value pair. If it is, it places an entry in the global hash and
# returns true. If it isn't, it returns false
sub simple_key_value {
	
	$_ = shift;
	
	# Match:
	# Key = Value
	if(/^\s*($var_name_regex)\s+=\s+(\S.*)$/) {
		$global{$1} = $2;			# Put the found entry into the global hash
		return 1;					# Return true if there's a match
	}
	else {
		return 0;					# Return false if it doesn't match
	}
}

# This sub routine checks if a line is a simple key value pair with the value being quoted
sub simple_key_value_with_quote {


}


# Checks if the value in key-value pair is quoted with parentheses
sub simple_key_value_with_paren_quote {

	$_ = shift;

	# Check if quoted with parentheses
	# Match:
	# Key : (Value)
	if(/\s*($var_name_regex)\s+:\s+\(([^\)]+?)\)/) {
		$global{$1} = $2;
		return 1;
	}
	else {
		return 0;
	}
}


# Check if value in key-value pair is quoted with braces
sub simple_key_value_with_brace_quote {

	$_ = shift;

	# Check if quoted with braces
	# Match:
	# Key : {Value}
	if(/\s*($var_name_regex)\s+:\s+\{([^}]+?)\}/) {
		$global{$1} = $2;
		return 1;
	}
	else {
		return 0;
	}
}


# Check if value in key-value pair is quoted with square brackets
sub simple_key_value_with_square_quote {

	$_ = shift;

	# Check if quoted with braces
	# Match:
	# Key : {Value}
	if(/\s*($var_name_regex)\s+:\s+\[([^\]]+?)\]/) {
		$global{$1} = $2;
		return 1;
	}
	else {
		return 0;
	}
}


# Check if value in key-value pair is quoted with angular brackets
sub simple_key_value_with_angle_quote {

	$_ = shift;

	# Check if quoted with angular brackets
	# Match:
	# Key : {Value}
	if(/\s*($var_name_regex)\s+:\s+<([^>]+?)>/) {
		$global{$1} = $2;
		return 1;
	}
	else {
		return 0;
	}
}