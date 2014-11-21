#!/usr/bin/perl

use warnings;
use strict;
use MP3::Tag;
use File::Basename;

###################################
#
# Phonic Boom - pbIndexer.pl
# ==========================
#     Author: Patrick Riggs (Github: sanpatricio)
#     November 2014
#
# Instructions:
# -------------
#     Requires MP3::Tag, found at http://search.cpan.org/~ilyaz/MP3-Tag-0.9706/Tag.pm.
#     Run Phonic Boom from the command line as such:
#
#     $ ./pbIndexer.pl $source $destination $webdir
#
# Arguments:
# ----------
# $source      - This should be the filesystem path of the directory where the mp3s are contained.
#                Put all the files of the same artist in the same directory.  Don't split albums
#                into separate subdirectories.  pbIndexer will group and sort them properly (grouped
#                by album, then sorted by track number) so long as the metadata is correctly specified.  
#
# $destination - This will be the directory and filename where you want pbIndexer to output the HTML
#                stub file.  This will not be proper HTML but simply a <ul> list with pbIndexer css
#                classes for styling.  It is meant to be included in another, proper HTML page.
#
# $webdir      - This argument is used to specify the download link for the <a href=""> statement.
#
###################################

my ($source, $destination, $webdir) = @ARGV;

my %music;

if($source) {
    print "    Reading from source: $source\n";
    my ($title, $track, $artist, $album, $comment, $year, $genre); # Variables for the file metadata
    my @files = glob("$source/*.mp3");                             # Put the file content in an array
    my $outfile = $destination;                                    # The file where the output goes
    my $prevAlbum = "";
    if (!$destination) { $outfile = "./output.html"; }             # If no destination out file is given, use ./output.html

    my $count = $#files;
    print "    Files detected: " . ($count + 1) . "\n";
    print "    Writing to output destination at $outfile\n";

    foreach my $file(@files) {
        open my $dataFH, '<', $file or die "    Can't open file $file: $!";

        my $mp3 = MP3::Tag->new($file);
        ($title, $track, $artist, $album, $comment, $year, $genre) = $mp3->autoinfo();
        $comment = $mp3->comment();

        my $link     = $webdir;
        my $filename = basename($file); 

        $music {$title} = {
            title    => "$title",
            album    => "$album",
            track    => "$track",
            artist   => "$artist",
            year     => "$year",
            genre    => "$genre",
            comment  => "$comment",
            link     => "$link/$filename"
        };
 
        close($dataFH) or die "    Can't close file $file: $!";
        undef $mp3;
    }

    my @keys = sort { 
        $music{$a}{album} cmp $music{$b}{album} 
            or
        $music{$a}{track} cmp $music{$b}{track}
    } keys %music;

    open my $outFH, '>', $outfile or die "    Can't open file $outfile: $!";
    
    foreach my $key (@keys) {
        if($prevAlbum ne $music{$key}{album}) {
            if(length($prevAlbum == 0)) { print "</ul>\n";}
            print $outFH "<h3>$album</h3>\n";
            print $outFH "<ul>\n";
        }
        my $trackTitle = $music{$key}{title};
        print $outFH "    <li class='pbTrack'>$music{$key}{album} - $music{$key}{track} <a href='$music{$key}{link}'>";
        printf $outFH "%-20s</a></li>\n ", $key, $music{$key};
        
        $prevAlbum = $music{$key}{album};
    }

    print $outFH "</ul>\n";
    close($outFH) or die "    Can't close $outfile: $!";
    print "    Finished.\n\n";
}
else {
    print "    Source couldn't be read.  Execution block skipped.\n";
    print "    You must specify the following: \n";
    print "    1) Directory source (where the mp3s files are)\n";
    print "    2) A destination file for the output HTML stub\n";
    print "    3) The web directory where the files are (to build the download link)\n";
    print "    Example: \$ ./pbIndexer.pl source destination\ni.e. \$ ./pbIndexer.pl ~/public_html/music ~/public_html ~/music/artist/\n\n";
}
