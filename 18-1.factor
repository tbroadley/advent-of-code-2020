USING: kernel io.files io.encodings.utf8 math prettyprint
       peg peg.parsers strings math math.parser sequences
       combinators ;

IN: 18

: oparen ( -- parser ) "(" token ;
: cparen ( -- parser ) ")" token ;

: plus   ( -- parser ) "+" token ;
: times  ( -- parser ) "*" token ;
: op     ( -- parser ) plus times 2choice ;

DEFER: expr
: paren-expr ( -- parser )
    oparen [ expr ] delay sp cparen sp 3seq ;

: value ( -- parser ) integer-parser paren-expr 2choice ;

: op-value ( -- parser ) op sp value sp 2seq ;

: expr ( -- parser ) value op-value repeat0 2seq ;



DEFER: eval
: eval-op ( n op e -- result )
    swap {
      { "*" [ eval * ] }
      { "+" [ eval + ] }
    } case ;

: eval ( ast -- n )
    {
      { [ dup number? ] [ ] }
      { [ dup first "(" = ] [ second eval ] }
      [ [ second ] [ first eval ] bi [ first2 eval-op ] reduce ]
    } cond ;

: input ( -- lines ) "18.txt" utf8 file-lines ;

: part1 ( -- answer )
    input [ expr parse ] map [ eval ] map sum ;

part1 .

