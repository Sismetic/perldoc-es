#!/usr/bin/env perl -s

# Copyright 2011 by Enrique Nell
#
# Usage: perl postprocessing.pl [-trans] [-not_pod] <pod_path>
#
# The optional parameter -trans adds the Translators section
#
# The optional parameter -not_pod specifies the file is not pod
#
# Requires Pod::Simple::HTML


use strict;
use warnings;
use File::Copy;
use File::Basename;
use Pod::Tidy qw( tidy_files );
use Text::Wrap qw( wrap $columns );
use Readonly;
use utf8;

use vars qw( $trans $not_pod );

$|++;

my $pod_path;

if ( $ARGV[0] ) {

    $pod_path = $ARGV[0];

} else {
 
    die "Usage: perl postprocessing.pl [-trans] [-not_pod] <pod_path>\n";

}


# Get path components
my ($name, $path, $suffix) = fileparse($pod_path, qr{\.pod|\.pm});


# Translators section for POD
Readonly my $TRANSLATORS_POD => <<'END';

=head1 TRADUCTORES

=over

=item * Joaquín Ferrero (Tech Lead), C< explorer + POD2ES at joaquinferrero.com >

=item * Enrique Nell (Language Lead), C< blas.gordon + POD2ES at gmail.com >

=back

END

# Translators section for other formats
Readonly my $TRANSLATORS => <<'END';

TRADUCTORES

Joaquín Ferrero (Tech Lead), explorer + POD2ES at joaquinferrero.com

Enrique Nell (Language Lead), blas.gordon + POD2ES at gmail.com

END



if ( !$not_pod ) {

    # Wrap lines (OmegaT removes some line breaks) using Pod::Tidy 
    my $processed = Pod::Tidy::tidy_files(
                                            files   => [ $pod_path ],
                                            inplace => 1,
                                            columns => 80,
                                         );


    # Add TRANSLATORS section
    if ( $trans ) {
    
        open my $out, '>>:encoding(latin-1)', $pod_path;

        print $out $TRANSLATORS_POD;
    
        close $out;

    }


    # Convert pod to html for visual check
    my $out_html = $path . "/$name.html";

    system("perl -MPod::Simple::HTML -e Pod::Simple::HTML::go $pod_path > $out_html");


} else {   # Other text formats (e.g., the main distribution README)

    # Wrap lines (OmegaT removes some line breaks) using Text::Wrap
    my ( $in_path, $out_path );
    $in_path = $pod_path . ".bak";
    $out_path = $pod_path;

    copy( $pod_path, $in_path );

    open my $in, '<:encoding(latin-1)', $in_path;
    open my $out, '>:encoding(latin-1)', $out_path;

    $columns = 80;

    while ( <$in> ) {

        if ( /^\s*$/ ) {
            print $out $_;
            next;
        }

        print $out wrap( "", "", ("$_") );

    }

    close $in;
    
    # Add TRANSLATORS section 
    print $out $TRANSLATORS if $trans;

    close $out;

}






