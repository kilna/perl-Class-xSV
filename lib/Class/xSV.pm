package Class::xSV;

use 5.006;
use strict;
use warnings;

use Package::Stash;

=head1 NAME

Class::xSV - A read/write object mapper for CSV and TSV files.

=head1 VERSION

Version 1.0.0

=cut

our $VERSION = '1.0.0';

use base 'Text::CSV';

my @attribs = qw( autosave id header );
my %attribs = map { $_ => undef } @attribs;

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Class::xSV;

    my $foo = Class::xSV->new();
    ...


=head1 AUTHOR

Anthony Kilna, C<< <anthony at kilna.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-class-xsv at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Class-xSV>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=cut

sub import {
    shift @_;
    my %params = @_;

    my $class = (caller(1))[3];
    die "Class::xSV::import can only be called from 'use' or BEGIN block"
      unless (defined($class) && ($class =~ s/::BEGIN//));
    print "Class: $class\n";

    my $s = Package::Stash->new($class);
   
    my $text_csv = $params{'text_csv'} || 'Text::CSV';
    eval "require $text_csv";
    $@ && die $@;
    $s->add_symbol( '@ISA', [ 'Class::xSV', $text_csv ] );
    $s->add_symbol( '$class_xsv_text_csv', $text_csv );

    my $record_class = $params{'record_class'};
    if (not $record_class) {
        if    ($class =~ m/^(.*?)es/) { $record_class = $1; }
        elsif ($class =~ m/^(.*?)s/)  { $record_class = $1; }
        else                          { $record_class = $class.'::Record'; }
    }
    $s->add_symbol( '$class_xsv_record_class', $record_class );
    
    my %defaults = $params{'defaults'} ? %{ $params{'defaults'} } : ();
    $s->add_symbol( '%class_xsv_defaults', \%defaults );
}

sub new {
    my $class = shift;
    my $s = Package::Stash->new($class);

    my %text_csv_params = (
        %{ $s->get_symbol('%class_xsv_defaults') },
        @_
    );
    my %class_xsv_params = ();
    foreach ( keys %text_csv_params ) {
x
        next unless exists $attribs{$_};
        $class_xsv_params{$_} = delete $text_csv_params{$_};
    }

    my $text_csv = ${ $s->get_symbol('$class_xsv_text_csv') };
    my $self = bless $text_csv->new( %text_csv_params ), $class;
    
    foreach ( keys %class_xsv_params ) { $self->{$_} = $class_xsv_params{$_} }
    
    return $self;
}




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Class::xSV


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Class-xSV>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Class-xSV>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Class-xSV>

=item * Search CPAN

L<http://search.cpan.org/dist/Class-xSV/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2012 Anthony Kilna.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Class::xSV
