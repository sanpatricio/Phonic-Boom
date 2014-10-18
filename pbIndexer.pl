#!/usr/bin/perl

###################################
#
# pbIndexer.pl makes use of MP3::Tag, found at http://search.cpan.org/~ilyaz/MP3-Tag-0.9706/Tag.pm.
#
###################################

use warnings;
use strict;
use MP3::Tag;

my ($source, $destination) = ($ARGV[0], $ARGV[1]);

if($source and $destination) {
    my ($title, $track, $artist, $album, $comment, $year, $genre);

    my @files = glob("$source/*.mp3");
    my $outfile = $destination . "/output.html";
    print "Reading .mp3s from $source\n";
    print "Writing to output destination at $outfile\n";

    open(OUT, ">$outfile") or die "Can't open file output.html: $!";

    print OUT "<ul>\n";

    foreach my $file(@files) {
        open(DATA, "<$file") or die "Can't open file $file: $!";

        my $mp3 = MP3::Tag->new($file);
        ($title, $track, $artist, $album, $comment, $year, $genre) = $mp3->autoinfo();
        $comment = $mp3->comment();

        print OUT &output($file);

        close(DATA) or die "Can't close file $file: $!";
        undef $mp3;
    }
    print OUT "</ul>\n";

    close(OUT) or die "Can't close outptu.html: $!";
    sub output {
        my ($link) = @_;
        my $html   .= "    <li><span class=\"artist\">$artist</span>, <span class=\"album\">$album</span> ($year) - Track $track: <a href='$link'>$title</a> <span class=\"miscData\">- $genre, $comment</span></li>\n";
        return $html;
    }
}
else {
    print "You must specify a directory source (where the mp3s are) and a destination for output.html.\n";
    print "Example: \$ ./script.pl source destination\n\$ ./orpheus.pl music .\n\n";
}
