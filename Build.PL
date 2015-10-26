use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Class::xSV',
    license             => 'perl',
    dist_author         => q{Anthony Kilna <anthony@kilna.com>},
    dist_version_from   => 'lib/Class/xSV.pm',
    build_requires => {
        'Test::More' => 0,
    },
    requires => {
        'perl' => 5.006,
        'Text::CSV' => 0.80,
        'Class::MOP' => 0,
    },
    add_to_cleanup      => [ 'Class-xSV-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
