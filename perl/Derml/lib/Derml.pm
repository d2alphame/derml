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
my $current_section = "";

my $varname = qr/[a-zA-Z_][a-zA-Z0-9_-]*/;


my $parser = sub {

  while(<$file>) {
    next if //
  }
};


# Pass a filename to this funtion to parse it
sub derml {
  my $len = scalar @_;
  if($len < 1) {
    croak "Pass the name of the file to parse to derml";
  }
  elsif($len > 1) {
    croak "Too many parameters passed to derml";
  }

  my $filename = shift;
  open($file, '<', $filename) or croak "Could not open $filename: $!";
  $parser->();
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
