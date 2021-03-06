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
    dup {
      { [ "mask = " ?head ] [ nip parse-mask=  ] }
      { [ "mem["    ?head ] [ nip parse-mem[]= ] }
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

:: execute ( state instr quot -- state' )
    state instr dup mask=?
    [ mask>> execute-mask= ]
    [ [ address>> ] [ value>> ] bi quot call ] if ; inline

:: solve ( quot -- answer )
    input
    H{ } clone 36 CHAR: X <string> <state>
    [ quot execute ] reduce memory>> values sum ; inline

: part1 ( -- answer ) [ execute-mem[]= ] solve ;



: apply-floating-bit ( address index -- addresses )
     [ set-bit ] [ clear-bit ] 2bi 2array ;

:: update-bit-2 ( addresses mask-c index -- addresses' )
    addresses mask-c {
      { CHAR: 0 [ ] }
      { CHAR: 1 [ [ index set-bit ] map ] }
      [ drop [ index apply-floating-bit ] map-concat ]
    } case ;

: mask-address ( mask address -- addresses )
    1array [ first2 update-bit-2 ] reduce ;

:: execute-mem[]=-2 ( state address value -- state' )
    state mask>> address mask-address
    [ value swap state memory>> set-at ] each
    state ;

: part2 ( -- answer ) [ execute-mem[]=-2 ] solve ;



part1 .
part2 .
