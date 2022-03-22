# A Perl Module for parsing derml

use v5.26;												# Use perl version 5.26 and above

my %global;												# All Key-Value pairs found go in here
my $var_name_regex = qr{[a-zA-Z][A-Za-z0-9_-]+};		# Regex for key and section names

# Read lines from files specified at the terminal
while(<>) {
	# next if /^\s*#/;							# Ignore comments
	# next if simple_key_value();					# Simple key = value
	# next if simple_key_value_with_quote();		# For Quoted key = 'value'
	# next if long_value_assignment();			# Check if assigning long value via '<'
	# next if multiline_value_assignment();		# Simple multiline value assignment via '|'
	# next if multiline_array();
	simple_single_line_array();
}


say "KEY: $_ <=> VALUE: " . $global{$_} for(keys %global);
say $global{'key20'}[2];

# Just a simple `key = value`. Nothing to see here
sub simple_key_value {
	
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

	if(
		simple_key_value_with_angle_quote()		||
		simple_key_value_with_back_quote()		||
		simple_key_value_with_brace_quote()		||
		simple_key_value_with_double_quote()	||
		simple_key_value_with_paren_quote()		||
		simple_key_value_with_single_quote()	||
		simple_key_value_with_square_quote()
	) {
		return 1;
	}
	else {
		return 0;
	}
}


# Checks if the value in key-value pair is quoted with parentheses
sub simple_key_value_with_paren_quote {

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

	# Check if quoted with square brackets
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



# Check if value in key-value pair is quoted with single quotes
sub simple_key_value_with_single_quote {

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
	
	my $tmp = "";

	# Match first line of assignment of long values thus:
	# key <
	# The long value follows from the next line
	if(/^\s*($var_name_regex)\s+<\s*$/) {
		$tmp .= get_first_line_of_long_value() . get_rest_of_long_value();
		$global{$1} = $tmp;
		return 1;
	}
	else {
		return 0;
	}
}



# Check if assigning multiline value to a key. Note that all
# leading spaces are stripped off from all the lines.
sub multiline_value_assignment {

	my $key; my $delimiter; my $tmp = "";
	if(/^\s*($var_name_regex)\s+\|\s+(\S.*)/) {
		$key = $1; $delimiter = $2;

		while(<>) {
			last if /^\s*$delimiter\s*$/;
			s/^\s*//;
			$tmp .= $_;
		}

		$global{$key} = $tmp;
		return 1;
	}
	else {
		return 0;
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
		last if /^\s*$/;			# We're done once we encounter a blank line
		s/^\s*/ /;					# Concatenate all leading spaces into a single space
		chomp;						# Remove the newline character at the end of the string
		$tmp .= $_;					# Append to lines we've found
	}

	return $tmp;
}



# Checks if a given string is a quoted item
sub get_quoted_item {

	$_ = shift;

	return
		get_angle_content($_)			||
		get_back_quote_content($_)		||
		get_brace_content($_)			||
		get_double_quote_content($_)	||
		get_parens_content($_)			||
		get_single_quote_content($_)	||
		get_square_content($_)			||
		"";
}

# Returns the content of a parens quoted item
sub get_parens_content {

	$_ = shift;
	return $1 if /\((\S[^\)]*?)\)/;					# Return anything between a pair of parentheses
	return "";										# If there's no such, return an empty string (i.e. false)
}

# Returns the content of a braces quoted item
sub get_brace_content {

	$_ = shift;
	return $1 if /\{(\S[^\}]*?)\}/;
	return "";
}

# Returns the content of an angle quoted item
sub get_angle_content {
	
	$_ = shift;
	return $1 if /<(\S[^>]*?)>/;
	return "";
}

# Returns the content of a square bracketed item
sub get_square_content {

	$_ = shift;
	return $1 if /\[(\S[^\]]*?)\]/;
	return "";
}

# Returns the content of double-quote
sub get_double_quote_content {

	$_ = shift;
	return $1 if /"(\S[^"]*?)"/;
	return "";
} 

# Returns the content of single-quote
sub get_single_quote_content {

	$_ = shift;
	return $1 if /'(\S[^']*?)'/;
	return "";
}

# Returns the content of back-quoted item
sub get_back_quote_content {

	$_ = shift;
	return $1 if /\`(\S[^`]*?)\`/;
	return "";
}

sub multiline_array {

	my $key; my @tmp; my $tmpline;
	if(/^\s*($var_name_regex)\[\]\s*$/) {
		$key = $1;
		while(<>) {
			last if /^\s*=\s*$/;
			last if /^\s*\|\s*$/;
			last if /^\s*<\s*$/;

			# Array element with simple assignment
			if(/^\s+=\s+(\S.*)$/) {
				push @tmp, $1;
				next;
			}

			# Array element with line too long
			if(/^\s+<\s+(\S.*)/) {
				$tmpline = $1;
				while(<>) {
					last if /^\s*$/;
					s/^\s*/ /;
					chomp;
					$tmpline .= $_;
				}
				push @tmp, $tmpline;
				next;
			}

			# Multiline array element
			if(/^\s+\|\s+(\S.*)/) {
				my $delimiter = $1; my $tmpmultiline = "";
				while(<>) {
					last if(/^\s*$delimiter\s*$/);
					s/^\s+//;
					$tmpmultiline .= $_;
				}

				push @tmp, $tmpmultiline;
				next;
			}

		}
		$global{$key} = [ @tmp ];
		return 1;
	}
	else {
		return 0;
	}
}

# For processing single-line array
sub single_line_array {

}

sub simple_single_line_array {
	my @tmp;
	if(/\s*($var_name_regex)\[\]\s+=\s+([^\s,][^,]*)/g) {
		my $key = $1;
		push @tmp, $2;
		while(/\G,\s+([^\s,][^,]*)/gc) {
			push @tmp, $1;
		}
		$global{$key} = [ @tmp ];
		return 1;
	}
	else {
		return 0;
	}
}


sub single_line_paren_quoted_array {
	my @tmp;
	if(/\s*($var_name_regex)\[\]\s+:/g) {
		my $key = $1;
		while(/\G\s+\(([^\)]+)\)/gc){
			push @tmp, $1;
		}
		$global{$key} = [ @tmp ];
		return 1;
	}
	else {
		return 0;
	}
}

sub single_line_brace_quoted_array {
	my @tmp;
	if(/\s*($var_name_regex)\[\]\s+:/g) {
		my $key = $1;
		while(/\G\s+\{([^\}]+)\}/gc){
			push @tmp, $1;
		}
		$global{$key} = [ @tmp ];
		return 1;
	}
	else {
		return 0;
	}
}

sub single_line_angle_quoted_array {
	my @tmp;
	if(/\s*($var_name_regex)\[\]\s+:/g) {
		my $key = $1;
		while(/\G\s+<([^>]+)>/gc){
			push @tmp, $1;
		}
		$global{$key} = [ @tmp ];
		return 1;
	}
	else {
		return 0;
	}
}


sub single_line_square_quoted_array {
	my @tmp;
	if(/\s*($var_name_regex)\[\]\s+:/g) {
		my $key = $1;
		while(/\G\s+\[([^\]]+)\]/gc){
			push @tmp, $1;
		}
		$global{$key} = [ @tmp ];
		return 1;
	}
	else {
		return 0;
	}
}


sub single_line_apos_quoted_array {
	my @tmp;
	if(/\s*($var_name_regex)\[\]\s+:\s+'([^']+)'/g) {
		my $key = $1;
		push @tmp, $2;
		while(/\G\s*,\s+'([^']+)'/gc) {
			push @tmp, $1;
		}
		$global{$key} = [ @tmp ];
		return 1;
	}
	else {
		return 0;
	}
}


sub single_line_dquot_quoted_array {
	my @tmp;
	if(/\s*($var_name_regex)\[\]\s+:\s+"([^"]+)"/g) {
		my $key = $1;
		push @tmp, $2;
		while(/\G\s*,\s+"([^"]+)"/gc) {
			push @tmp, $1;
		}
		$global{$key} = [ @tmp ];
		return 1;
	}
	else {
		return 0;
	}
}


sub single_line_tick_quoted_array {
	my @tmp;
	if(/\s*($var_name_regex)\[\]\s+:\s+\`([^`]+)\`/g) {
		my $key = $1;
		push @tmp, $2;
		while(/\G\s*,\s+\`([^`]+)\`/gc) {
			push @tmp, $1;
		}
		$global{$key} = [ @tmp ];
		return 1;
	}
	else {
		return 0;
	}
}


sub single_line_space_separated_array {
	my @tmp;
	if(/@($var_name_regex)/g) {
		my $key = $1;
		while(/\G\s+(\S+)/gc) {
			push @tmp, $1;
		}
		$global{$key} = [ @tmp ];
		return 1;
	}
	else {
		return 0;
	}
}

# TODO: Refactor into regexes for quoted items

# TODO: Add POD documentation