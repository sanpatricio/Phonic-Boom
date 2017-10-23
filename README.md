Phonic Boom
=======

Phonic Boom is a command-line tool used to read a directory of music files to
output an unordered list HTML stub.  The list order is arranged around the file 
metadata and can handle multiple albums in the same directory, separating each
into different <ul> groupings.

Once pbIndexer.pl is run from a command line, the resulting output (defaults to
output.html) will contain a ul/li list of mp3s formatted based on the meta tags
associated with the file.  

Use:
    $ ./pbIndexer.pl ~/public_html/music ~/public_html/mymusic.html /music/artist/
    This will index the files located in ~/public_html/music/ and put the results 
    into the ~/public_html/mymusic.html file
