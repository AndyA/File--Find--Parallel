#!perl -w
use strict;
use ExtUtils::MakeMaker;

eval 'use ExtUtils::MakeMaker::Coverage';

my %EXE = (
    'lncopies' => {
        PREREQ_PM => {
            'Getopt::Long' => '2.34',
            'Pod::Usage'   => '1.3',
        },
        EXE_FILES => ['examples/lncopies'],
    }
);

my %ARGS = (
    NAME          => 'File::Find::Parallel',
    AUTHOR        => 'Andy Armstrong <andy@hexten.net>',
    VERSION_FROM  => 'lib/File/Find/Parallel.pm',
    ABSTRACT_FROM => 'lib/File/Find/Parallel.pm',
    LICENSE       => 'perl',
    PL_FILES      => {},
    EXE_FILES     => [],
    PREREQ_PM     => {
        'Test::More'    => 0,
        'File::Tempdir' => '0.02',
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES    => 'File-Find-Parallel-*' },
);

$ARGS{SIGN} = 1 if MM->can( 'signature_target' );

while ( my ( $exe, $spec ) = each %EXE ) {
    my $yn = prompt( "Install $exe script?", "N" );
    if ( $yn =~ /^y/i ) {
        while ( my ( $key, $val ) = each %$spec ) {
            if ( ref $val eq 'HASH' ) {
                $ARGS{$key} = { %{ $ARGS{$key} || {} }, %$val };
            }
            elsif ( ref $val eq 'ARRAY' ) {
                push @{ $ARGS{$key} }, @$val;
            }
            else {
                die "Can't merge $key: value not handled\n";
            }
        }
    }
}

WriteMakefile( %ARGS );
