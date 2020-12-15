USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser sets
arrays locals combinators accessors splitting hashtables strings ;

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

part1 .
