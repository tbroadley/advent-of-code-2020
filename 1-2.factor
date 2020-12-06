USING: io.files io.encodings.utf8 math math.ranges
prettyprint kernel sequences math.parser arrays locals ;

"1.txt" utf8 file-lines
[ string>number ] map
dup dup
[| stack n | stack [| stack2 m | stack2 [ m n 3array ] map stack2 swap ] map stack swap ] map
concat concat
[ first3 + + 2020 = ] filter
first
first3 * *
.
drop
drop
