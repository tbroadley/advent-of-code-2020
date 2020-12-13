USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser assocs
arrays locals lists combinators grouping math.ranges strings accessors splitting math.functions ;

IN: 12

TUPLE: input ts buses ;
C: <input> input

: parse-buses ( line -- buses ) "," split [ [ string>number ] keep or ] map ;

: get-input ( -- lines )
    "13.txt" utf8 file-lines
    [ first string>number ] [ second parse-buses ] bi <input> ;

:: bus-after-ts ( ts bus -- ts after )
     ts
     ts bus / ceiling bus * ;

: part1 ( -- answer )
    get-input
    [ ts>> ] [ buses>> [ "x" = not ] filter ] bi
    [ [ bus-after-ts ] map ] keep swap zip
    [ second ] infimum-by first2
    [let :> ( ts bus after ) after ts - bus * ]
    ;

: part2 ( -- answer )
    0
    ;

part1 .
part2 .
