use strict;
use warnings;
use utf8;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'POD2::ES',
    AUTHOR            => q{Equipo de Perl en Español},
    VERSION_FROM      => 'lib/POD2/ES.pm',
    ABSTRACT_FROM     => 'lib/POD2/ES.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'POD2::Base' => 0.043,
        'Pod::Perldoc' => 3.15,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'POD2-ES-*' },
);
