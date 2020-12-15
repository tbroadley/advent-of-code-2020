USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser sets
arrays locals combinators accessors splitting hashtables strings assocs ;

IN: 15

: input ( -- numbers )
    "15.txt" utf8 file-lines
    first "," split [ string>number ] map ;

: to-map ( numbers -- map )
     but-last [ 2array ] map-index >hashtable ;

:: compute-new-last ( map last len -- new-last )
    last map at :> prev-index
    prev-index [ len 1 - prev-index - ] [ 0 ] if ;

:: say-number ( map last len -- map' last' len' )
    map last len compute-new-last :> new-last
    len 1 - last map set-at
    map new-last len 1 + ;

: part1 ( -- answer )
    input [ to-map ] [ last ] [ length ] tri
    [ 2020 swap - ] keep swap [ say-number ] times
    drop nip ;

: part2 ( -- answer )
    input [ to-map ] [ last ] [ length ] tri
    [ 30000000 swap - ] keep swap [ say-number ] times
    drop nip ;


part1 .
part2 .
