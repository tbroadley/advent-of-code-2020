USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser sets
arrays locals combinators accessors splitting strings assocs math.ranges fry math.combinatorics ;

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
    [ [ parse-field ] map ]
    [ second parse-ticket ]
    [ 1 tail [ parse-ticket ] map ] tri* <input> ;

: get-input ( -- input )
    "16.txt" utf8 file-lines
    { "" } split first3 parse-input ;

:: is-invalid-value? ( fields value -- ? )
    fields [ ranges>> [ value swap member? not ] all? ] all? ;

: find-invalid-values ( fields ticket -- values )
    values>> [ dupd is-invalid-value? ] filter nip ;

: part1 ( -- answer )
    get-input
    [ fields>> ] [ tickets>> ] bi
    [ dupd find-invalid-values ] map concat sum nip ;



: remove-invalid-tickets ( input -- input' )
    [ fields>> ] keep
    [ [ dupd find-invalid-values empty? ] filter ] change-tickets
    nip ;

:: field-valid? ( field tickets field-n -- ? )
    tickets [ values>> field-n swap nth ] map
    [ field 1array swap is-invalid-value? not ] all? ;

:: valid-fields ( fields-left tickets field-n -- fields )
    fields-left [ tickets field-n field-valid? ] filter ;

DEFER: (field-order)

:: ((field-order)) ( valid fields-left tickets acc -- order/? )
    fields-left [ name>> valid name>> = not ] filter
    tickets
    acc valid suffix (field-order) ;

:: (field-order) ( fields-left tickets acc -- order/? )
    fields-left tickets acc length valid-fields :> valids
    {
      { [ fields-left empty? ] [ acc ] }
      { [ valids empty? ] [ f ] }
      [ valids [ fields-left tickets acc ((field-order)) ] find nip ]
    } cond ;

: field-order ( input -- order/? )
    [ fields>> ] [ tickets>> ] bi
    { } (field-order) ;

: to-permutation ( order fields -- permutation )
    [ [ name>> ] map ] bi@
    swap [ over index ] map nip ;

: permute ( permutation seq -- seq' )
    swap [ over nth ] map nip ;

: part2 ( -- answer )
    get-input remove-invalid-tickets
    [ field-order ] keep [ fields>> to-permutation ] keep
    my-ticket>> values>> permute 6 head product ;



part1 .
part2 .
