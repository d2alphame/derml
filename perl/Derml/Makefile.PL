<<<<<<< HEAD
use 5.026000;
=======
use 5.026001;
>>>>>>> master
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'Derml',
    VERSION_FROM      => 'lib/Derml.pm', # finds $VERSION, requires EU::MM from perl >= 5.5
    PREREQ_PM         => {}, # e.g., Module::Name => 1.1
    ABSTRACT_FROM     => 'lib/Derml.pm', # retrieve abstract from module
<<<<<<< HEAD
    AUTHOR            => 'Deji Adegbite <contact@dejiadegbite.com.com>',
    #LICENSE           => 'perl',
    #Value must be from legacy list of licenses here
    #https://metacpan.org/pod/Module::Build::API
=======
    AUTHOR            => 'Deji Adegbite',
    #LICENSE           => 'perl',
    #Value must be from legacy list of licenses here
    #http://search.cpan.org/perldoc?Module%3A%3ABuild%3A%3AAPI
>>>>>>> master
);