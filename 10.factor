USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser
arrays locals lists combinators sorting assocs memoize ;

IN: 10

: input ( -- lines ) "10.txt" utf8 file-lines [ string>number ] map ;

: sequential-pairs ( seq -- seq' ) dup 1 tail zip ;

:: count-differences ( prev n1 n2 -- next ) n2 n1 - 1 - prev [ [ 1 + ] change-nth ] keep ;

: part1 ( -- answer )
    input natural-sort
    sequential-pairs
    sequence>list
    { 0 0 0 } [ first2 count-differences ] foldr
    [ first 1 + ] [ third 1 + ] bi *
    ;

DEFER: count-arrangements

MEMO: count-arrangements-helper ( last-seen to-see -- count )
        [ nip [ first ] [ 1 tail ] bi count-arrangements ]
        [ 1 tail count-arrangements ]
        [ second swap - 3 <= ]
        2tri
        [ + ] [ drop ] if ;

MEMO: count-arrangements ( last-seen to-see -- count )
        [ length 1 <= ] keep swap
        [ 2drop 1 ]
        [ count-arrangements-helper ]
        if ;

: part2 ( -- answer )
    0
    input natural-sort
    count-arrangements ;

part1 .
part2 .
