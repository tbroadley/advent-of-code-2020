USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser sets
arrays locals combinators accessors splitting hashtables strings assocs ;

IN: 15

: input ( -- numbers )
    "15.txt" utf8 file-lines
    first "," split [ string>number ] map ;

: to-table ( numbers -- table )
     but-last [ 2array ] map-index >hashtable ;

:: compute-new-end ( table end len -- new-end )
    end table at :> prev-index
    prev-index [ len 1 - prev-index - ] [ 0 ] if ;

:: say-number ( table end len -- table' end' len' )
    table end len compute-new-end :> new-end
    len 1 - end table set-at
    table new-end len 1 + ;

:: solve ( numbers n -- answer )
    numbers [ to-table ] [ last ] [ length ] tri
    dup n swap - [ say-number ] times
    drop nip ;

: part1 ( -- answer ) input 2020 solve ;
: part2 ( -- answer ) input 30000000 solve ;

part1 .
part2 .
