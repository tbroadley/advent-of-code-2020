USING: io.files io.encodings.utf8 math math.ranges
prettyprint kernel sequences math.parser arrays locals ;

"1.txt" utf8 file-lines
[ string>number ] map
dup dup
2 [ cartesian-product concat ] times
[ first2 first2 + + 2020 = ] find
first2 first2 * *
.
drop
