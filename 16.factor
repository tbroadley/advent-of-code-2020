USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser sets
arrays locals combinators accessors splitting strings assocs math.ranges fry ;

IN: 15

TUPLE: field name ranges ;
C: <field> field

TUPLE: ticket values ;
C: <ticket> ticket

TUPLE: input fields my-ticket tickets ;
C: <input> input

: parse-field ( line -- field )
    ": " split1 " or " split1 2array
    [ "-" split1 [ string>number ] bi@ [a,b] ] map
    <field> ;

: parse-ticket ( line -- ticket )
    "," split [ string>number ] map <ticket> ;

: parse-input ( fields-sec my-ticket tickets -- input )
    [ 1 tail [ parse-field ] map ]
    [ second parse-ticket ]
    [ 1 tail [ parse-ticket ] map ] tri* <input> ;

: get-input ( -- input )
    "16.txt" utf8 file-lines
    { "" } split first3 parse-input ;

:: is-invalid-value? ( fields value -- ? )
    fields [ ranges>> [ value swap member? not ] all? ] all? ;

: find-invalid-values ( fields tickets -- values )
    [ values>> ] map concat
    [ dupd is-invalid-value? ] filter nip ;

: part1 ( -- answer )
    get-input
    [ fields>> ] [ tickets>> ] bi find-invalid-values sum ;

part1 .
