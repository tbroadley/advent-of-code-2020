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
     instr {
       { "N" [ s [ instr-n + ] change-y ] }
       { "S" [ s [ instr-n - ] change-y ] }
       { "E" [ s [ instr-n + ] change-x ] }
       { "W" [ s [ instr-n - ] change-x ] }
       { "L" [ s [ instr-n turn-left ] change-dir ] }
       { "R" [ s [ 360 instr-n - turn-left ] change-dir ] }
       { "F" [ s s dir>> instr-n next-state ] }
     } case ;

: part1 ( -- answer )
    input
    "E" 0 0 <state> [ first2 next-state ] reduce
    [ x>> abs ] [ y>> abs ] bi + ;

:: rotate-waypoint-left ( wx wy n -- wx' wy' )
     n 90 /
     {
       { { 1 0 }  { 0 1 }  }
       { { 0 -1 } { 1 0 }  }
       { { -1 0 } { 0 -1 } }
       { { 0 1 }  { -1 0 } }
     } nth
     { wx wy } m.v first2 ;

:: next-state-2 ( x y wx wy instr instr-n -- x' y' wx' wy' )
     instr {
       { "N" [ x y wx wy instr-n + ] }
       { "S" [ x y wx wy instr-n - ] }
       { "E" [ x y wx instr-n + wy ] }
       { "W" [ x y wx instr-n - wy ] }
       { "L" [ x y wx wy instr-n rotate-waypoint-left ] }
       { "R" [ x y wx wy 360 instr-n - rotate-waypoint-left ] }
       { "F" [ x y [ wx instr-n * + ] [ wy instr-n * + ] bi* wx wy ] }
     } case ;

: part2 ( -- answer )
    input
    { 0 0 10 1 } [ first2 [ first4 ] 2dip next-state-2 4array ] reduce
    [ first abs ] [ second abs ] bi + ;

part1 .
part2 .
