USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser assocs
arrays locals lists combinators grouping math.ranges strings accessors splitting math.functions lists.lazy ;

IN: 12

TUPLE: input ts buses ;
C: <input> input

: parse-buses ( line -- buses ) "," split [ [ string>number ] keep or ] map ;

: get-input ( -- lines )
    "13.txt" utf8 file-lines
    [ first string>number ] [ second parse-buses ] bi <input> ;

:: bus-after-ts ( bus ts -- after )
     ts bus / ceiling bus * ;

:: part1-helper ( ts buses -- answer )
     buses buses [ ts bus-after-ts ] map zip
     [ second ] infimum-by first2
     [let :> ( bus after ) after ts - bus * ] ;

: part1 ( -- answer )
    get-input
    [ ts>> ] [ buses>> [ "x" = not ] filter ] bi
    part1-helper ;

: construct-congruences ( buses -- congruences )
    [ length [0,b) [ 0 swap - ] map ] keep zip
    [ second "x" = not ] filter
    [ first2 [ rem ] keep 2array ] map ;

:: sieve-helper ( x1 n1 x2 n2 -- x' n' )
     x1 [ n1 + ] lfrom-by
     [ n2 mod x2 = ] lfilter car
     n1 n2 * ;

: sieve ( lc1 lc2 -- lc ) [ first2 ] bi@ sieve-helper 2array ;

:: lreduce ( list quot -- result )
     list cdr cdr
     list 2car quot call
     quot foldl ; inline

: part2 ( -- answer )
    get-input buses>>
    construct-congruences
    >list [ sieve ] lreduce first
    ;

part1 .
part2 .
