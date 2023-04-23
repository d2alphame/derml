package Derml;

use 5.026001;
use strict;
use warnings;
use Carp;

our @ISA = qw();

our $VERSION = '0.01';


# Preloaded methods go here.

my %global;                           # Hash to contain all the key and value pairs
my $file;                             # File handle to the file to parse
my $filename;                         # Name of the file to parse
my $percent_callback;                 # Code to run when a percent string or block is encountered
my $current_section = "";

my $varname = qr/[a-zA-Z][a-zA-Z0-9_-]*/;
my $comment = qr/\s*#.*/;


# Subroutine that parses section names
my $parse_section = sub {
  if(/^\s*--\s+($varname)\s+--\s*$/){
    $current_section = $1;
    return 1;
  }
  else {
    return 0;
  }
};


# This is for percent strings and percent blocks
my $percent_entities = sub {
  if(/^\s* % \s+ (\S.*) $/x){
    $percent_callback->($1) if($percent_callback);
    return 1;
  }
  elsif(/^\s* %% \s* $/x){
    my $line = <$file>;
    my $temp = "";
    until(/^\s* %% \s* $/x) {
      $temp .= $_;
      $line = <$file>;
    }
    $percent_callback->($temp) if($percent_callback);
    return 1;
  }
  else { return 0; }
};


# Arrays across multiple lines
my $multiline_array_assignment = sub {
  my $key; my @temp;
  if(/^\s* ($varname)\[\] \s* $/gcx) {
    $key = $1;
    until(/^\s+=\s*$/) {
      $_ = <$file>;

      # Ignore blank lines here
      next if(/^\s*$/);

      # For normal array elements. Starts with =
      if(/^\s+ = \s+ (\S.*)$/gcx) { push @temp, $1 ; next }
      
      # For multi line array elements. Starts with |
      if(/^\s+ \| \s+ (\S.*)$/gcx) {
        my $delim = $1; my $line = "";
        $_ = <$file>;
        until(/^\s+ $delim \s* $/gcx) {
          s/^\s*//;
          $line .= $_;
          $_ = <$file>;
        }
        push @temp, $line;
        next
      }

      # For long value array elements. Starts with <
      if(/^\s+ < \s+ (\S.*) $/gcx) {
        my $longvalue = $1;
        $_ = <$file>;
        until(/^\s*$/) {
          chomp;
          s/^\s*/ /;
          $longvalue .= $_;
          $_ = <$file>;
        }
        push @temp, $longvalue;
        next
      }

      last if(/^\s+=\s*/);
      
      # If we ever get here it means the multi line array delimiter wasn't found
      die "Multi-line array delimiter never found\n";
    }
    if($current_section) {
      $global{"$current_section" . ".$key"} = [ @temp ]
    }
    else { $global{$key} = [ @temp ] }
    return 1;
  }
  else {
    pos($_) = 0;
    return 0;
  }
};


# For arrays where elements are separated by spaces
my $space_separated_array = sub {
  my $key;
  if(s/^\s*\@//) {
    chomp;
    my @temp = split /\s+/, $_;
    $key = shift @temp;
    if($current_section) {
      $global{"$current_section" . ".$key" } = [ @temp ]
    }
    else {
      $global{$key} = [ @temp ]
    }
    return 1;
  }
  else { return 0; }
};


# For arrays where elements are quoted with ", ', or `
my $true_quoted_array_assignment = sub {
  my @temp; my $key;
  if(/^\s* ($varname)\[\] \s+ = \s+ (["'`]) ([^\2]+?) \2 /gcx) {
    push @temp, $3;
    $key = $1;
    while(/\G \s*, \s+ (["'`]) ([^\1]+?) \1 /gcx) {
      push @temp, $2;
    }
    unless( /\G \s* $comment $/gcx  ||  /\G \s* $/gcx) {
      pos($_) = 0;
      return 0;
    }
    if($current_section) {
      $global{"$current_section" . ".$key"} = [ @temp ]
    }
    else { $global{$key} = [ @temp ] }
    return 1;
  }
  else {
    pos($_) = 0;
    return 0;
  }
};


# For array assignments like array[] = first, second, third, fourth
my $standard_array_assignment = sub {
  my $key; my @temp;
  if(/^ \s* ($varname)\[\] \s+ = \s+ ([^,]+) /gcx) {
    push @temp, $2;
    $key = $1;
    while(/\G ,\s+ ([^,]+) /gcx) {
      push @temp, $1
    }
    if($current_section) {
      $global{"$current_section" . ".$key"} = [ @temp ]
    }
    else { $global{$key} = [ @temp ] }
    return 1;
  }
  else {
    pos($_) = 0;
    return 0;
  }
};


# For bracket-quoted array assignments
my $bracket_quoted_array_assignment = sub {
  my ($open, $close) = @_;
  my @temp; my $key;
  if(/^ \s* ($varname)\[\] \s+ = \s+ $open([^$close]+?)$close /gcx) {
    push @temp, $2;
    $key = $1;
    while(/\G \s+ $open([^$close]+)$close/gcx) {
      push @temp, $1;
    }
    unless( /\G \s* $comment $/gcx  ||  /\G \s* $/gcx) {
      pos($_) = 0;
      return 0;
    }
    if($current_section) {
      $global{"$current_section" . ".$key"} = [ @temp ]
    }
    else { $global{$key} = [ @temp ] }
    return 1;
  }
  else {
    pos($_) = 0;
    return 0;
  }
};


my $quoted_array_assignment = sub {
  return 1 if($bracket_quoted_array_assignment->("{", "}"));
  return 1 if($bracket_quoted_array_assignment->('\(', '\)'));
  return 1 if($bracket_quoted_array_assignment->("<", ">"));
  return 1 if($bracket_quoted_array_assignment->('\[', '\]'));
  return 1 if($true_quoted_array_assignment->());
  return 0;
};


# For arrays specified on a single line
my $single_line_array_assignment = sub {
  return 1 if $quoted_array_assignment->();
  return 1 if $standard_array_assignment->();
  return 1 if $space_separated_array->();
  return 0;
};


# For parsing arrays
my $array_assignment = sub {
  return 1 if $single_line_array_assignment->();
  return 1 if $multiline_array_assignment->();
  return 0;
};


# Subroutine to parse standard scalar assignment
my $standard_scalar_assignment = sub {
  # Matches
  # x = my value
  if(/^\s*($varname)\s+=\s+(\S.*)/) {
    if($current_section) {
      $global{$current_section . ".$1" } = $2;
      return 1;
    }
    else{
      $global{$1} = $2;
      return 1;
    }
  }
  else { return 0; }
};


# Subroutine to parse true quoted assignments. The true quotes are
# The double quotes, apostrophe and backticks.
my $true_quoted_scalar_assignment = sub {
  # Matches
  # x = "My value"
  # or
  # y = 'My value'
  # or
  # z = `My value`
  if(/^\s* ($varname) \s+ = \s+ (["'`]) ([^\2]+) \2 /gcx) {
    my $key = $1; my $val = $3;
    # After quoted assignment, only comments or spaces may follow
    unless(/\G \s+ $comment/gcx || /\G \s+ $/gcx){
      pos($_) = 0;
      die "Invalid config token in file $filename line $.\n";
    }
    pos($_) = 0;
    if($current_section) {
      $global{$current_section . ".$key"} = $val;
      return 1;
    }
    else {
      $global{$key} = $val;
      return 1;
    }
  }
  else {
    pos($_) = 0;
    return 0;
  }
};


# Subroutine to parse bracket quoted assignments. The bracket quotes
# are braces {}, square brackets [], parentheses (), and angular brackets <>
my $bracket_quoted_scalar_assignment = sub {
  # Matches
  # x = {This uses braces}
  # x = <This uses angles>
  # x = (This uses parens)
  # x = [This uses squares]
  if(   /^\s* ($varname) \s+=\s+ \{ ([^}]+) \} /gcx   ||
        /^\s* ($varname) \s+=\s+ \( ([^)]+) \) /gcx   ||
        /^\s* ($varname) \s+=\s+ \[ ([^\]]+)\] /gcx   ||
        /^\s* ($varname) \s+=\s+ < ([^>]+) > /gcx
   )
  {
    my $key = $1; my $val = $2;
    unless(/\G \s+ $comment/gcx || /\G \s* $/gcx){
      pos($_) = 0;
      die "Invalid config token in file $filename line $.\n";
    }
    pos($_) = 0;
    if($current_section) {
      $global{$current_section . ".$key"} = $val;
      return 1;
    }
    else {
      $global{$key} = $val;
      return 1;
    }
  }
  else {
    pos($_) = 0;
    return 0;
  }
};


# Subroutine to parse long value scalar assignment
my $long_value_scalar_assignment = sub {
  # Matches assignment to long values.
  # Note that long values are terminated with a blank line
  if(/^\s* ($varname) \s+ < \s*$/gcx) {
    my $key = $1;
    my $line = <$file>;                  # Get the first line of the long value
    $line =~ s/^\s*//;
    chomp $line;
    while(<$file>) {
      last if /^\s*$/;
      chomp;
      s/^\s*/ /;
      $line .= $_;
    }
    if($current_section) {
      $global{$current_section . ".$key"} = $line;
    }
    else {
      $global{$key} = $line;
    }
    return 1;
  }
  else { 
    pos($_) = 0;
    return 0; 
  }
};


# Subroutine to parse multiline scalar assignment
my $multine_scalar_assignment = sub {
  if(/^\s* ($varname) \s+\|\s+ (\S.*) $/gcx) {
    my $key = $1; my $delim = $2; my $tmp = "";
    while(<$file>) {
      if(/^\s*$delim\s*$/) {
        if($current_section) {
          $global{$current_section . ".$key"} = $tmp;
        }
        else {
          $global{$key} = $tmp;
        }
        return 1;
      }
      $tmp .= $_ and next if /^\s*$/;
      s/^\s*//;
      $tmp .= $_;
    }
    # If we ever get here, it means we didn't find the delimiter
    die "End of file reached without finding delimiter: $delim\n";
  }
  else { pos($_) = 0; return 0; }
};


# Subroutine to parse quoted scalar assignment
my $quoted_scalar_assignment = sub {
  return 1 if $true_quoted_scalar_assignment->();
  return 1 if $bracket_quoted_scalar_assignment->();
  return 0;
};


# Subroutine to parse scalar assignments
my $scalar_assignment = sub {
  return 1 if $quoted_scalar_assignment->();
  return 1 if $standard_scalar_assignment->();
  return 1 if $long_value_scalar_assignment->();
  return 1 if $multine_scalar_assignment->();
  return 0;
};


# Subroutine that parses assignments
my $assignment = sub {
  return 1 if $array_assignment->();
  return 1 if $scalar_assignment->();
  return 0;
};


# The main parsing subroutine
my $parser = sub {
  while(<$file>) {
    next if /^$comment/;
    next if /^$/;
    next if $parse_section->();
    next if $assignment->();
    next if $percent_entities->();
    # die "Unrecognized key or value: $.\n";
  } 
};


=pod

What follows is for testing and experimentation only and should be removed
later

=cut

derml(shift @ARGV);


# Pass a filename to this subroutine to parse it
sub derml {
  my $len = scalar @_;
  if($len < 1) {
    croak "Pass the name of the file to parse to derml";
  }
  elsif($len > 2) {
    croak "Too many parameters passed to derml";
  }

  $filename = shift;
  $percent_callback = shift;
  open($file, '<', $filename) or croak "Could not open $filename: $!";
  $parser->();

  ######################################################
  # TODO: Delete these lines after testing/development #
  ######################################################
  my @keys = keys %global;                             #
  say "$_ = " . $global{$_} for(@keys);                #
  ######################################################

  say $global{"Multi-line-array.multi"}->[4];
  return \%global;
}


1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Derml - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Derml;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Derml, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.


=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

A. U. Thor, E<lt>deji@E<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2022 by A. U. Thor

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.26.1 or,
at your option, any later version of Perl 5 you may have available.


=cut
