USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser assocs
arrays locals lists combinators grouping math.ranges strings math.matrices accessors ;

IN: 12

: input ( -- lines )
    "12.txt" utf8 file-lines
    [ [ first 1string ] map ] [ [ 1 tail string>number ] map ] bi zip ;

TUPLE: state dir x y ;
C: <state> state

:: turn-left ( dir degrees -- dir' )
     dir { "N" "W" "S" "E" } index
     degrees 90 / + 4 mod
     { "N" "W" "S" "E" } nth ;

:: next-state ( s instr instr-n -- s' )
     s instr {
       { "N" [ [ instr-n + ] change-y ] }
       { "S" [ [ instr-n - ] change-y ] }
       { "E" [ [ instr-n + ] change-x ] }
       { "W" [ [ instr-n - ] change-x ] }
       { "L" [ [ instr-n turn-left ] change-dir ] }
       { "R" [ [ 360 instr-n - turn-left ] change-dir ] }
       { "F" [ dup dir>> instr-n next-state ] }
     } case ;

: part1 ( -- answer )
    input
    "E" 0 0 <state> [ first2 next-state ] reduce
    [ x>> abs ] [ y>> abs ] bi + ;

TUPLE: state-2 x y dx dy ;
C: <state-2> state-2

:: rotate-waypoint-left ( s degrees -- s' )
     degrees 90 /
     {
       { { 1 0 }  { 0 1 }  }
       { { 0 -1 } { 1 0 }  }
       { { -1 0 } { 0 -1 } }
       { { 0 1 }  { -1 0 } }
     } nth
     s [ dx>> ] [ dy>> ] bi 2array m.v first2
     s swap >>dy swap >>dx ;

:: next-state-2 ( s instr instr-n -- s' )
     s instr {
       { "N" [ [ instr-n + ] change-dy ] }
       { "S" [ [ instr-n - ] change-dy ] }
       { "E" [ [ instr-n + ] change-dx ] }
       { "W" [ [ instr-n - ] change-dx ] }
       { "L" [ instr-n rotate-waypoint-left ] }
       { "R" [ 360 instr-n - rotate-waypoint-left ] }
       { "F" [
               [ [ x>> ] [ dx>> instr-n * ] bi + ] keep swap >>x
               [ [ y>> ] [ dy>> instr-n * ] bi + ] keep swap >>y
             ]
       }
     } case ;

: part2 ( -- answer )
    input
    0 0 10 1 <state-2> [ first2 next-state-2 ] reduce
    [ x>> abs ] [ y>> abs ] bi + ;

part1 .
part2 .
