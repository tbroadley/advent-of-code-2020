USING: kernel io.files io.encodings.utf8 math prettyprint sequences
arrays locals lists combinators grouping math.ranges assocs hashtables
sequences.deep sets slots.syntax io ;

IN: 11

TUPLE: pos x y z t ;
C: <pos> pos

:: build-row ( row x -- alist )
    row [| cell y | x y 0 0 <pos> cell 2array ] map-index ;

: input ( -- lines )
    "17.txt" utf8 file-lines
    [ build-row ] map-index concat >hashtable ;

: cartesian-product* ( seqs -- seq )
    [ 1 tail ] [ first ] bi [ cartesian-product concat ] reduce
    [ flatten ] map ;

: adjacent-cell-offsets ( -- offsets )
    4 { -1 0 1 } <repetition> cartesian-product*
    [ [ 0 = ] all? not ] filter [ first4 <pos> ] map ;

: offset ( pos offset -- pos' )
    [ slots{ x y z t } ] bi@ zip [ first2 + ] map
    first4 <pos> ;

: adjacent-cell-positions ( pos -- posseq )
     adjacent-cell-offsets [ over offset ] map nip ;

: adjacent-cells ( state pos -- cells )
     adjacent-cell-positions
     [ over at [ CHAR: . ] unless* ] map nip ;

: on? ( cell -- ? ) CHAR: # = ;

:: cell-update ( state pos -- assoc )
     pos state at :> cell
     state pos adjacent-cells [ on? ] count :> cells-on
     cell on?     cells-on { 2 3 } member? and :> keep-on
     cell on? not cells-on 3 =             and :> turn-on
     keep-on turn-on or
     [ CHAR: # ] [ CHAR: . ] if pos swap 2array ;

:: apply-rules ( state -- )
    state keys :> posseq
    posseq [ adjacent-cell-positions ] map concat :> neighbours
    posseq neighbours append members
    [ state swap cell-update ] map
    [ first2 swap state set-at ] each ;

: part1 ( -- answer )
    input 6 [ dup apply-rules "applied rules" . flush ] times
    values [ on? ] count ;

part1 .
