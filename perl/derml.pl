# A Perl Module for parsing derml

use v5.26;									# Use perl version 5.26 and above

my %global;												# All Key-Value pairs found go in here
my $var_name_regex = qr{[a-zA-Z_][A-Za-z0-9_-]+};		# Regex for key and section names	

# Read lines from files specified at the terminal
while(<>) {
	next if /^\s*#/;							# Ignore comments
	simple_key_value_with_back_quote($_);
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
	if(/^\s*($var_name_regex)\s+:\s+\(([^\)]+?)\)/) {
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
	if(/^\s*($var_name_regex)\s+:\s+\{([^}]+?)\}/) {
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
	# Key : [Value]
	if(/^\s*($var_name_regex)\s+:\s+\[([^\]]+?)\]/) {
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
	# Key : <Value>
	if(/^\s*($var_name_regex)\s+:\s+<([^>]+?)>/) {
		$global{$1} = $2;
		return 1;
	}
	else {
		return 0;
	}
}



# Check if value in key-value pair is quoted with angular brackets
sub simple_key_value_with_single_quote {

	$_ = shift;

	# Check if quoted with single quotes
	# Match:
	# Key : 'Value'
	if(/^\s*($var_name_regex)\s+:\s+'([^']+?)'/) {
		$global{$1} = $2;
		return 1;
	}
	else {
		return 0;
	}
}



# Check if value in key-value pair is quoted with double quotes
sub simple_key_value_with_double_quote {

	$_ = shift;

	# Check if quoted with double quotes
	# Match:
	# Key : "Value"
	if(/^\s*($var_name_regex)\s+:\s+"([^"]+?)"/) {
		$global{$1} = $2;
		return 1;
	}
	else {
		return 0;
	}
}



# Check if value in key-value pair is quoted with back quotes
sub simple_key_value_with_back_quote {

	$_ = shift;

	# Check if quoted with back quotes
	# Match:
	# Key : `Value`
	if(/^\s*($var_name_regex)\s+:\s+\`([^`]+?)\`/) {
		$global{$1} = $2;
		return 1;
	}
	else {
		return 0;
	}
}



# Check if assigning long value to a key
sub long_value_assignment {
	
	$_ = shift;

	# Match first line of assignment of long values thus:
	# key <
	# The long value follows from the next line
	if(/^\s*($var_name_regex)\s+<\s*$/) {

	}
}



# Returns the formatted first line of a long value. The first
# line of a long value requires a special formatting different
# from that of the rest of the lines
sub get_first_line_of_long_value {

	# Get the next line, which is assumed to be the first line of a long value and strip off the leading spaces
	# Return whatever is left after stripping
	$_ = <>;
	s/^\s*//;
	chomp;			# Don't forget to remove the newline character at the end of the string
	return $_;
}



# Returns the formatted following lines of a long value
# Concatenate all leading spaces into a single space.
sub get_rest_of_long_value {

	my $tmp = "";

	while(<>) {
		last if /^$/;				# We're done once we encounter a blank line
		s/^\s*/ /;					# Concatenate all leading spaces into a single space
		chomp;						# Remove the newline character at the end of the string
		$tmp .= $_;					# Append to lines we've found
	}

	return $tmp;
}