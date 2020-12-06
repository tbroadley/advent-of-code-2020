USING: io.files io.encodings.utf8 math math.ranges
prettyprint kernel sequences math.parser arrays locals ;

"1.txt" utf8 file-lines
[ string>number ] map
dup
[| stack n | stack [ [ n 2array ] map ] [ swap ] bi ] map concat
[ first2 + 2020 = ] filter
first
first2 *
.
drop
