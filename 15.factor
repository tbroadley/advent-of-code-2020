USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser sets
arrays locals combinators accessors splitting hashtables strings assocs ;

IN: 15

: input ( -- numbers )
    "15.txt" utf8 file-lines
    first "," split [ string>number ] map ;

: prev-index-of-last ( numbers -- index? )
    [ last ] [ length 2 - ] [ ] tri last-index-from ;

: say-number ( numbers -- numbers' )
    dup [ length 1 - ] [ prev-index-of-last ] bi
    [ - ] [ drop 0 ] if* suffix ;

: part1 ( -- answer )
    input
    [ length 2020 swap - ] keep swap [ say-number ] times
    2020 1 - swap nth ;



: to-map ( numbers -- map )
     but-last [ 2array ] map-index >hashtable ;

:: compute-new-last ( len prev-index -- new-last )
    prev-index [ len 1 - prev-index - ] [ 0 ] if ;

:: say-number-2 ( map last len -- map' last' len' )
    len last map at compute-new-last :> new-last
    len 1 - last map set-at
    map new-last len 1 + ;

: part2 ( -- answer )
    input [ to-map ] [ last ] [ length ] tri
    [ 30000000 swap - ] keep swap [ say-number-2 ] times
    drop nip ;


part1 .
part2 .
