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

MEMO:: count-arrangements ( last-seen to-see -- count )
     to-see length {
       { 0 [ 1 ] }
       { 1 [ 1 ] }
       [
         drop
         to-see [ first ] [ 1 tail ] bi count-arrangements
         to-see second last-seen - 3 <=
         [ last-seen to-see 1 tail count-arrangements ]
         [ 0 ]
         if
         +
       ]
     } case ;

: part2 ( -- answer )
    0
    input natural-sort
    count-arrangements ;

part1 .
part2 .
