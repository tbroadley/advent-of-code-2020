USING: io.files io.encodings.utf8 math math.ranges prettyprint kernel sequences math.parser ;

"1.txt" utf8 file-lines
[ string>number . ] each
