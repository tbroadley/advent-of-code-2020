USING: kernel io.files io.encodings.utf8 math prettyprint
       peg peg.parsers strings math math.parser sequences
       combinators splitting assocs ;

IN: 19

: rule-number ( -- parser )
    integer-parser ":" token hide 2seq [ first ] action ;

: char-rule-definition ( -- parser )
    "\"" token sp hide
    any-char
    "\"" token hide 3seq [ first ] action ;

: seq-rule-definition-part ( -- parser )
    integer-parser sp repeat1 ;

: seq-rule-definition ( -- parser )
    seq-rule-definition-part sp
    "|" token sp hide list-of ;

: rule-definition ( -- parser )
    char-rule-definition seq-rule-definition 2choice ;

: rule ( -- parser ) rule-number rule-definition 2seq ;

: parse-rules ( lines -- rules ) [ rule parse ] map ;

: input ( -- rules messages )
    "19.txt" utf8 file-lines { "" } split first2
    [ parse-rules ] dip ;

: without-matching-prefix ( rules message rule-number -- suffix )
    pick at dup number ?
    [ dupd 1string head? [ drop ] [ nip ] if ]
    [ ]

:: matches-rules? ( rules message rule-numbers -- ? )
    rule-numbers message
    [ [ 2dup ] dip without-matching-prefix ] reduce
    2nip [ string? ] [ empty? ] bi and ;

: matches-rule? ( rules message rule-number -- ? )
    pick at dup number?
    [ 1string = nip ]
    [ [ [ 2dup ] dip matches-rules? ] any? 2nip ] if ;

: part1 ( -- answer )
    input [ dupd 0 matches-rule? ] count nip ;

part1 .

