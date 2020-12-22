USING: kernel io.files io.encodings.utf8 math prettyprint
       math math.parser sequences locals
       combinators splitting arrays
       math.ranges assocs ;

IN: 21

: input ( -- deck1 deck2 )
    "22.txt" utf8 file-lines { "" } split1
    [ 1 tail [ string>number ] map ] bi@ ;

: move-cards ( deck1 deck2 -- deck1' deck2' )
    [ 1 cut ] bi@ [ swapd 3append ] dip ;

: play-turn ( deck1 deck2 -- deck1' deck2' )
    2dup [ first ] bi@ >
    [ move-cards ]
    [ swap move-cards swap ] if ;

: play-game ( deck1 deck2 -- deck )
    [ 2dup [ empty? ] bi@ or ] [ play-turn ] until
    2array [ empty? not ] filter first ;

: compute-score ( deck -- score )
    reverse dup length [1,b] zip
    [ first2 * ] map sum ;

: part1 ( -- answer )
    input play-game compute-score ;

part1 .
