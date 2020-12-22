USING: kernel io.files io.encodings.utf8 math prettyprint
       math math.parser sequences locals
       combinators splitting arrays
       math.ranges assocs namespaces continuations accessors ;

IN: 22

: input ( -- deck1 deck2 )
    "22.txt" utf8 file-lines { "" } split1
    [ 1 tail [ string>number ] map ] bi@ ;

: move-cards ( deck1 deck2 -- deck1' deck2' )
    [ 1 cut ] bi@ [ swapd 3append ] dip ;

: play-turn ( deck1 deck2 -- deck1' deck2' )
    2dup [ first ] bi@ >
    [ move-cards ]
    [ swap move-cards swap ] if ;

: play-game ( deck1 deck2 quot -- deck win1 )
    [ 2dup [ empty? ] bi@ or ] swap until
    dup empty? [ drop t ] [ nip f ] if ; inline

: compute-score ( deck -- score )
    reverse dup length [1,b] zip
    [ first2 * ] map sum ;

: part1 ( -- answer )
    input [ play-turn ] play-game drop compute-score ;



: seen? ( seen deck1 deck2 -- ? ) 2array swap index ;

: mark-seen ( seen deck1 deck2 -- seen' ) 2array suffix ;

: recurse? ( deck -- ? ) [ first ] [ length 1 - ] bi <= ;

DEFER: play-recursive-turn
DEFER: play-recursive-game
: (play-recursive-turn) ( deck1 deck2 -- deck1' deck2' )
    2dup [ 1 cut swap first head ] bi@
    [let :> ( deck1 deck2 ) { } clone deck1 deck2 play-recursive-game nip ]
    [ move-cards ] [ swap move-cards swap ] if ;

:: play-recursive-turn ( seen deck1 deck2 -- seen' deck1' deck2' )
    {
      { [ seen deck1 deck2 seen? ] [ seen deck1 { } clone ] }
      {
        [ seen deck1 deck2 mark-seen deck1 deck2 [ recurse? ] bi@ and ]
        [ deck1 deck2 (play-recursive-turn) ]
      }
      [ deck1 deck2 play-turn ]
    } cond ;

: play-recursive-game ( seen deck1 deck2 -- deck win1 )
    [ 2dup [ empty? ] bi@ or ] [ play-recursive-turn ] until nipd
    dup empty? [ drop t ] [ nip f ] if ;

: part2 ( -- answer )
    { } input play-recursive-game drop compute-score ;



part1 .
part2 .
