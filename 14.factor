USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser sets
arrays locals combinators accessors splitting hashtables assocs strings math.bitwise sequences.extras ;

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

:: update-bit-2 ( addresses mask-c index -- addresses' )
    mask-c {
      { CHAR: 0 [ addresses ] }
      { CHAR: 1 [ addresses [ index set-bit ] map ] }
      [ drop addresses [ [ index set-bit ] [ index clear-bit ] bi 2array ] map-concat ]
    } case ;

:: mask-address ( address mask -- addresses )
    mask reverse [ 2array ] map-index
    address 1array [ first2 update-bit-2 ] reduce ;

:: execute-mem[]=-2 ( state address value -- state' )
    address state mask>> mask-address
    [ value swap state memory>> set-at ] each
    state ;

: execute-2 ( state instruction -- state' )
    dup mask=?
    [ mask>> execute-mask= ]
    [ [ address>> ] [ value>> ] bi execute-mem[]=-2 ] if ;

: part2 ( -- answer )
    input
    H{ } clone 36 CHAR: X <string> <state>
    [ execute-2 ] reduce
    memory>> values sum ;

part1 .
part2 .
