package Derml;

use 5.026000;
use strict;
use warnings;
use Carp;

our @ISA = qw();

our $VERSION = '0.01';


my $file;											# This will be the handle to the file to parse
my $received_sections_param = 0;					# Parse all sections by default						

# Preloaded methods go here.

# 
sub derml {
	my %params = @_;
	croak "Parameter 'filename' is missing" unless $params{'filename'};
	open ($file, '<', $params{'filename'})
		or croak "Could not open $filename: $!";	
}



sub parse {

}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Derml - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Derml;
  
  # The simplest way to use Derml is to call derml with a filename parameter
  my %data = derml filename => 'myfile.derml'

  In the above form, derml returns a hash which contains the data as parsed.



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

Deji Adegbite, E<lt>contact@dejiadegbite.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2022 by Deji Adegbite

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.30.3 or,
at your option, any later version of Perl 5 you may have available.


=cut
