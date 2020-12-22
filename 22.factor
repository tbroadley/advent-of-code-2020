USING: kernel io.files io.encodings.utf8 math prettyprint
       math math.parser sequences locals
       combinators splitting arrays
       math.ranges assocs namespaces continuations accessors ;

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

: play-game ( deck1 deck2 quot -- deck win1 )
    [ 2dup [ empty? ] bi@ or ] swap until
    dup empty? [ drop t ] [ nip f ] if ; inline

: compute-score ( deck -- score )
    reverse dup length [1,b] zip
    [ first2 * ] map sum ;

: part1 ( -- answer )
    input [ play-turn ] play-game drop compute-score ;



SYMBOL: seen-positions
ERROR: recursive-game deck1 ;

: position-seen? ( deck1 deck2 -- ? )
    2array seen-positions get-global index ;

:: mark-position-seen ( deck1 deck2 -- )
    seen-positions get-global deck1 deck2 2array suffix :> value
    value seen-positions set-global ;

: recurse? ( deck -- ? ) [ first ] [ length 1 - ] bi <= ;

DEFER: play-recursive-turn
: (play-recursive-turn) ( deck1 deck2 -- deck1' deck2' )
    2dup [ 1 cut swap first head ] bi@
    [ play-recursive-turn ] play-game nip
    [ move-cards ] [ swap move-cards swap ] if ;

: play-recursive-turn ( deck1 deck2 -- deck1' deck2' )
    {
      { [ 2dup 2array . 2dup position-seen? ] [ drop recursive-game ] }
      {
        [ 2dup mark-position-seen 2dup [ recurse? ] bi@ and ]
        [ (play-recursive-turn) ]
      }
      [ play-turn ]
    } cond ;

: part2 ( -- answer )
    { } seen-positions set-global
    [ input [ play-recursive-turn ] play-game drop compute-score ]
    [ dup recursive-game? [ deck1>> compute-score ] [ throw ] if ] recover ;



part1 .
part2 .
