#!/usr/bin/env perl
use strict;
use warnings;
use Getopt::Long;

my $pictures_folder = "./pictures";
my $delay = 900; # The delay between two changes
# Scaling type, available values:
#       * center
#       * fill
#       * scale
#       * tile
#       * max
# Read feh(1) for more information.
my $scaling_type = "center"; 

GetOptions ("delay=i"  => \$delay,
    "folder=s" => \$pictures_folder,
    "scaling=s" => \$scaling_type,
) or die "Error in command line arguments\n";

die "Invalid scaling type: `$scaling_type`.\n" if ($scaling_type ne "center"
                                                    and $scaling_type ne "fill"
                                                    and $scaling_type ne "scale"
                                                    and $scaling_type ne "tile"
                                                    and $scaling_type ne "max");
print "-- DELAY           = $delay\n";
print "-- PICTURES_FOLDER = $pictures_folder\n";
print "-- SCALING_TYPE    = $scaling_type\n\n";

sub list_files {
    open(my $fh, '-|', "find $pictures_folder") or die "Failed to list files: $!\n";
    return $fh;
}

my $file_count = 0;
my $cfh = list_files;
$file_count++ while <$cfh>;
close $cfh;

sub choose_wallpaper {
    my $wallpaper_idx = int(rand($file_count));
    my $fl = list_files;
    while (<$fl>) {
        return $_ if $wallpaper_idx == 0;
        $wallpaper_idx--;
    }
    close $fl;
}

while (1) {
    my $wallpaper_path = choose_wallpaper;
    `feh --bg-$scaling_type $wallpaper_path`;
    print "-- Changed wallpaper to $wallpaper_path";
    sleep $delay;
}
