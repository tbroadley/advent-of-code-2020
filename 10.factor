USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser
arrays locals lists combinators sorting assocs ;

IN: 10

: input ( -- lines ) "10.txt" utf8 file-lines [ string>number ] map ;

:: count-differences ( prev n1 n2 -- next ) n2 n1 - 1 - prev [ 1 + ] change-nth prev ;

: part1 ( -- answer )
    input natural-sort
    dup 1 tail zip
    sequence>list
    { 0 0 0 } [ first2 count-differences ] foldr
    [ first 1 + ] [ third 1 + ] bi *
    ;

part1 .
