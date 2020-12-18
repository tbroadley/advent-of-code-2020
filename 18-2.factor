USING: kernel io.files io.encodings.utf8 math prettyprint
       peg peg.parsers strings math math.parser sequences
       combinators ;

IN: 18

: oparen ( -- parser ) "(" token ;
: cparen ( -- parser ) ")" token ;

: plus   ( -- parser ) "+" token ;
: times  ( -- parser ) "*" token ;

DEFER: expr
: paren-expr ( -- parser )
    oparen [ expr ] delay sp cparen sp 3seq
    [ second ] action ;

: value ( -- parser ) integer-parser paren-expr 2choice ;

: rep ( l op r quot -- parser )
    [ [ sp ] bi@ 2seq repeat0 2seq ] dip action ; inline

: eval ( seq quot -- n )
    [ [ second [ second ] map ] [ first ] bi ] dip
    reduce ; inline

: add  ( -- parser ) value plus  value [ [ + ] eval ] rep ;
: expr ( -- parser ) add   times add   [ [ * ] eval ] rep ;



: input ( -- lines ) "18.txt" utf8 file-lines ;

: part1 ( -- answer )
    input [ expr parse ] map sum ;

part1 .

