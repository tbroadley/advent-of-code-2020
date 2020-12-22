USING: kernel io.files io.encodings.utf8 math prettyprint
       math math.parser sequences locals
       combinators splitting arrays
       math.ranges assocs ;

IN: 21

: input ( -- deck1 deck2 )
    "22.txt" utf8 file-lines { "" } split1
    [ 1 tail [ string>number ] map ] bi@ ;

:: play-turn ( deck1 deck2 -- deck1' deck2' )
    deck1 first deck2 first >
    [ deck1 1 tail deck1 first suffix deck2 first suffix deck2 1 tail ]
    [ deck1 1 tail deck2 1 tail deck2 first suffix deck1 first suffix ] if ;

: play-game ( deck1 deck2 -- deck )
    [ 2dup [ empty? ] bi@ or ] [ play-turn ] until
    2array [ empty? not ] filter first ;

: compute-score ( deck -- score )
    reverse dup length [1,b] zip
    [ first2 * ] map sum ;

: part1 ( -- answer )
    input play-game compute-score ;

part1 .
