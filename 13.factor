USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser assocs
arrays locals lists combinators grouping math.ranges strings accessors splitting math.functions lists.lazy ;

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

: construct-congruences ( buses -- congruences )
    [ length [0,b) [ 0 swap - ] map ] keep zip
    [ second "x" = not ] filter
    [ first2 [ mod ] keep [ + ] keep [ mod ] keep 2array ] map ;

:: sieve ( lc1 lc2 -- lc )
     lc1 first [ lc1 second + ] lfrom-by
     [ lc2 second mod lc2 first = ] lfilter car
     lc1 second lc2 second *
     2array ;

: part2 ( -- answer )
    get-input buses>>
    construct-congruences
    [ 2 tail >list ] [ first2 sieve ] bi [ sieve ] foldl
    first
    ;

part1 .
part2 .
