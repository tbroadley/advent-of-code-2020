USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser splitting splitting.extras
sets ;

"6.txt" utf8 file-lines
{ "" } split
[ concat [ drop t ] split*-when members length ] map
sum
.
