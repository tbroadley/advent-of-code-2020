USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser sets
arrays locals combinators accessors splitting strings assocs math.ranges fry math.combinatorics io
math.order ;

IN: 15

TUPLE: bound lo hi ;
C: <bound> bound

TUPLE: field name bounds ;
C: <field> field

TUPLE: ticket values ;
C: <ticket> ticket

TUPLE: input fields my-ticket tickets ;
C: <input> input

: parse-field ( line -- field )
    ": " split1 " or " split1 2array
    [ "-" split1 [ string>number ] bi@ <bound> ] map
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

: in-bound? ( bound value -- ? )
    swap [ lo>> ] [ hi>> ] bi between? ;

:: is-invalid-value? ( fields value -- ? )
    fields [ bounds>> [ value in-bound? not ] all? ] all? ;

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

: nth-value ( ticket n -- value ) swap values>> nth ;

: is-valid-value? ( value field -- ? )
    1array swap is-invalid-value? not ;

:: field-valid? ( field tickets field-n -- ? )
    tickets [ field-n nth-value field is-valid-value? ] all? ;

:: valid-fields ( fields-left tickets field-n -- fields )
    fields-left [ tickets field-n field-valid? ] filter ;

DEFER: (field-order)

:: (((field-order))) ( fields-left tickets acc -- order/? )
    acc length dup fields-left length + [a,b) :> field-ns-left
    field-ns-left [| field-n | fields-left tickets field-n valid-fields empty? ] any?
    [ f ] [ fields-left tickets acc (field-order) ] if ;

:: ((field-order)) ( valid fields-left tickets acc -- order/? )
    fields-left [ name>> valid name>> = not ] filter :> fields-left'
    acc valid suffix :> acc'
    fields-left' tickets acc' (((field-order))) ;

:: (field-order) ( fields-left tickets acc -- order/? )
    fields-left tickets acc length valid-fields :> valids
    {
      { [ fields-left empty? ] [ acc ] }
      { [ valids empty? ] [ f ] }
      [ valids [ fields-left tickets acc ((field-order)) ] map-find drop ]
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
