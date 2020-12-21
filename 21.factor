USING: kernel io.files io.encodings.utf8 math prettyprint
       strings math math.parser math.bitwise sequences locals
       combinators splitting assocs sequences.extras splitting arrays
       accessors sets ;

IN: 21

TUPLE: food ingredients allergens ;
C: <food> food

: parse-food ( line -- food )
    " (contains " split1
    [ " " split ]
    [ 1 head* ", " split-subseq [ >string ] map ] bi* <food> ;

: input ( -- foods )
    "21.txt" utf8 file-lines [ parse-food ] map ;

: can-contain-allergen ( foods ingredient -- ? ) 2drop f ;

: part1 ( -- answer )
    input
    dup [ ingredients>> ] map concat members
    [ dupd can-contain-allergen not ] count nip ;

part1 .
