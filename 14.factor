USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser sets
arrays locals combinators accessors splitting hashtables assocs strings math.bitwise ;

IN: 13

TUPLE: mask= mask ;
TUPLE: mem[]= address value ;
UNION: instruction mask= mem[]= ;

ERROR: invalid-instruction ;

C: <mask=> mask=
C: <mem[]=> mem[]=

: parse-mem[]= ( after-mem[ -- mem[]= )
    "] = " split1 [ string>number ] bi@ <mem[]=> ;

: parse-line ( line -- instruction )
    {
      { [ dup "mask = " ?head ] [ nip <mask=> ] }
      { [ "mem[" ?head ] [ nip parse-mem[]= ] }
      [ invalid-instruction ]
    } cond ;

: input ( -- instructions )
    "14.txt" utf8 file-lines [ parse-line ] map ;

TUPLE: state memory mask ;

C: <state> state

: execute-mask= ( state mask -- state' ) >>mask ;

: update-bit ( value mask-c index -- value' )
    swap {
      { CHAR: 0 [ clear-bit ] }
      { CHAR: 1 [ set-bit ] }
      [ 2drop ]
    } case ;

:: mask-value ( value mask -- value' )
    mask reverse [ 2array ] map-index
    value [ first2 update-bit ] reduce ;

:: execute-mem[]= ( state address value -- state' )
    value state mask>> mask-value
    address state memory>> set-at
    state ;

: execute ( state instruction -- state' )
    dup mask=?
    [ mask>> execute-mask= ]
    [ [ address>> ] [ value>> ] bi execute-mem[]= ] if ;

: part1 ( -- answer )
    input
    H{ } clone 36 CHAR: X <string> <state>
    [ execute ] reduce
    memory>> values sum ;

part1 .
