USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser ;

"1.txt" utf8 file-lines
[ string>number ] map
dup cartesian-product
concat
[ first2 + 2020 = ] find
first2 *
.
drop
