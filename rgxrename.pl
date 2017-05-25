#!/usr/bin/env perl
use warnings;
use strict;
use Getopt::Std;

# declare the perl command line flags/options we want to allow
my %options=();
getopts("f", \%options);

=pod

=head1 NAME

rgxrename.pl - hardcoded regex batch renaming.

=head1 SYNOPSIS

    rgxrename.pl <file> [<file> ...] or simply rgxrename.pl * within a directory

=head1 DESCRIPTION

The I<rgxrename.pl> command renames files with with a certain hardcoded regex into a new name. Perform on directory with "rgxrename.pl *". Small check to avoid overwriting included.

=cut

my ($nwname, $ext);

foreach my $fn (@ARGV)
{
    # Compute the new name
    if($fn =~ m/([^-]+-[^_]+)_[^_]+(_\d+\.fastq\.gz)/) { # using - and _ as parse tokens

        $nwname = "$1"."$2";
        # print $fn." ".$nwname."\n";

        # Make sure the names are different
        if ($fn ne $nwname) {
            # If a file already exists by that name
            # compute a new name.
            if (-f $nwname) {
                $ext = 0;

                while (-f $nwname.".".$ext) {
                    $ext++;
                }
                $nwname = $nwname.".".$ext;
            }
            if($options{f}) {
                rename($fn, $nwname);
                print "Renamed \"$fn\" -> \"$nwname\".\n";
            } else {
                print "Would rename \"$fn\" -> \"$nwname\" if -f option were supplied.\n";
            }
        }
    }
}
