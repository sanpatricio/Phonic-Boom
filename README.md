Phonic Boom
=======

Phonic Boom is a command-line tool used to read music files and their meta-data
from a directory and outputs the details into a flat HTML file for web use.

Once pbIndexer.pl is run from a command line, the resulting output (defaults to
output.html) will contain a ul/li list of mp3s formatted based on the meta tags
associated with the file.  

Use:
$ ./pbIndexer.pl ~/public_html/music
This will index the files located in ~/public_html/music/ and put the results 
in the directory from which PB was run: ./output.html

$ ./pbIndexer.pl ~/public_html/music ~/public_html/mymusic.html
This will index the files located in ~/public_html/music/ and put the results 
into the ~/public_html/mymusic.html file
