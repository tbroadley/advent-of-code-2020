USING: kernel io.files io.encodings.utf8 math math.parser prettyprint
       sequences locals combinators splitting arrays grouping peg
       assocs hashtables ;

IN: 23

CONSTANT: DIRECTIONS { "e" "ne" "se" "w" "nw" "sw" }

: parse-path ( line -- path )
    DIRECTIONS [ token ] map choice repeat1 parse ;

: input ( -- seq )
    "24.txt" utf8 file-lines [ parse-path ] map ;

: move ( loc direction -- loc' )
    [ first2 ] dip {
      { "e"  [ [     ] [ 1 + ] bi* ] }
      { "ne" [ [ 1 + ] [ 1 + ] bi* ] }
      { "se" [ [ 1 - ] [     ] bi* ] }
      { "w"  [ [     ] [ 1 - ] bi* ] }
      { "nw" [ [ 1 + ] [     ] bi* ] }
      { "sw" [ [ 1 - ] [ 1 - ] bi* ] }
    } case 2array ;

:: flip-tile ( rec path -- rec' )
    1
    path { 0 0 } [ move ] reduce
    rec at+ rec ;

input H{ } clone
[ flip-tile ] reduce
values [ odd? ] count .
