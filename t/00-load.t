#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Class::xSV' ) || print "Bail out!\n";
}

diag( "Testing Class::xSV $Class::xSV::VERSION, Perl $], $^X" );
