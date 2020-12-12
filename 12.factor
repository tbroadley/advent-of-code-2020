USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser assocs
arrays locals lists combinators grouping math.ranges strings math.matrices ;

IN: 12

: input ( -- lines )
    "12.txt" utf8 file-lines
    [ [ first 1string ] map ] [ [ 1 tail string>number ] map ] bi zip ;

:: turn-left ( dir n -- dir' )
     dir { "N" "W" "S" "E" } index
     n 90 / + 4 mod
     { "N" "W" "S" "E" } nth ;

:: next-state ( dir x y instr instr-n -- dir' x' y' )
     instr {
       { "N" [ dir x y instr-n + ] }
       { "S" [ dir x y instr-n - ] }
       { "W" [ dir x instr-n + y ] }
       { "E" [ dir x instr-n - y ] }
       { "L" [ dir instr-n turn-left x y ] }
       { "R" [ dir 360 instr-n - turn-left x y ] }
       { "F" [ dir x y dir instr-n next-state ] }
     } case ;

: part1 ( -- answer )
    input
    { "E" 0 0 } [ first2 [ first3 ] 2dip next-state 3array ] reduce
    [ second abs ] [ third abs ] bi + ;

:: rotate-waypoint-left ( wx wy n -- wx' wy' )
     n 90 /
     {
       { { 1 0 }  { 0 1 }  }
       { { 0 1 }  { -1 0 } }
       { { -1 0 } { 0 -1 } }
       { { 0 -1 } { 1 0 }  }
     } nth
     { wx wy } m.v first2 ;

:: next-state-2 ( x y wx wy instr instr-n -- x' y' wx' wy' )
     instr {
       { "N" [ x y wx wy instr-n + ] }
       { "S" [ x y wx wy instr-n - ] }
       { "W" [ x y wx instr-n + wy ] }
       { "E" [ x y wx instr-n - wy ] }
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
