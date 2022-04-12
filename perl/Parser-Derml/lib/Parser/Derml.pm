package Parser::Derml;

use 5.026000;                         # Use perl minimum version of 5.26
use strict;
use warnings;
use Carp;

our @ISA = qw();

our $VERSION = '0.01';

my $file;                             # This will be the handle to the derml file to parse
my $current_section = '$';            # This is the main section by default.    

sub parse {
  my %params = @_;
  croak "Parameter 'filename' is required" unless $params{'filename'};
  my $filename = $params{'filename'};
  open $file, '<', $filename
    or croak "Could not open $filename: $!";
}


my parse_settions = sub {

}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Parser::Derml - Perl extension for parsing derml configuration format

=head1 SYNOPSIS

use Parser::Derml;

The simplest way to use Derml is to call 'parse' with the name of the file to
parse and a subroutine to run whenever a section is found.

    Parser::Derml::parse filename => 'file.derml', action => \&my_sub

In the above form, all sections in the file 'file.derml' will be parsed and for
each section that is found, my_sub() will be called.

my_sub should expect the following hash as parameter
{
  section => 'name_of_section',
  data => {
    key1 => value1,
    key2 => value2
    ...
  }  
}


# The sections to be parsed can be specified
Parser::Derml::parse(
  filename => 'file.derml',
  sections => [ 'Section1', 'Section2', 'Section3' ]
)


=head1 DESCRIPTION

Parser::Derml Is a perl module which parses a simple configuration file format derml. 

=head1 SEE ALSO

Mention other useful documentation such as the documentation of
related modules or operating system documentation (such as man pages
in UNIX), or any relevant external documentation such as RFCs or
standards.

If you have a mailing list set up for your module, mention it here.

If you have a web site set up for your module, mention it here.

=head1 AUTHOR

Deji Adegbite, E<lt>dejiadegbite@ta10.sd.apple.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2022 by Deji Adegbite

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.30.3 or,
at your option, any later version of Perl 5 you may have available.


=cut
