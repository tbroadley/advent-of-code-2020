USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser sets
arrays locals combinators accessors splitting hashtables assocs strings math.bitwise sequences.extras ;

IN: 14

TUPLE: mask= mask ;
TUPLE: mem[]= address value ;
UNION: instruction mask= mem[]= ;

ERROR: invalid-instruction ;

C: <mask=> mask=
C: <mem[]=> mem[]=

: parse-mask= ( mask -- mask-cs )
    reverse [ 2array ] map-index <mask=> ;

: parse-mem[]= ( after-mem[ -- mem[]= )
    "] = " split1 [ string>number ] bi@ <mem[]=> ;

: parse-line ( line -- instruction )
    {
      { [ dup "mask = " ?head ] [ nip parse-mask= ] }
      { [     "mem["    ?head ] [ nip parse-mem[]= ] }
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
    mask value [ first2 update-bit ] reduce ;

:: execute-mem[]= ( state address value -- state' )
    value state mask>> mask-value
    address state memory>> set-at
    state ;

:: execute ( s instr q -- state' )
    s instr dup mask=?
    [ mask>> execute-mask= ]
    [ [ address>> ] [ value>> ] bi q call ] if ; inline

:: solve ( execute-mem[]=-quot -- answer )
    input
    H{ } clone 36 CHAR: X <string> <state>
    [ execute-mem[]=-quot execute ] reduce
    memory>> values sum ; inline

: part1 ( -- answer ) [ execute-mem[]= ] solve ;

:: apply-floating-bit ( address index -- addresses )
     address [ index set-bit ] [ index clear-bit ] bi 2array ;

:: update-bit-2 ( addresses mask-c index -- addresses' )
    mask-c {
      { CHAR: 0 [ addresses ] }
      { CHAR: 1 [ addresses [ index set-bit ] map ] }
      [ drop addresses [ index apply-floating-bit ] map-concat ]
    } case ;

:: mask-address ( address mask -- addresses )
    mask address 1array [ first2 update-bit-2 ] reduce ;

:: execute-mem[]=-2 ( state address value -- state' )
    address state mask>> mask-address
    [ value swap state memory>> set-at ] each
    state ;

: part2 ( -- answer ) [ execute-mem[]=-2 ] solve ;

part1 .
part2 .
