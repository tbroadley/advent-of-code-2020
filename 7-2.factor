USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser splitting splitting.extras
arrays regexp locals sequences.deep sets ;

IN: 7-1

: parse-bag-description ( desc -- parsed ) " " split1 [let :> ( n desc ) n string>number desc ] 2array ;

: parse-rule-rhs ( rhs -- parsed ) [ " ." member? ] trim R/ \s(bags?)/ "" re-replace parse-bag-description ;

: parse-rule ( rule -- parsed ) " bags contain " split1 "," split [ parse-rule-rhs ] map 2array ;

: bag-count ( rule -- count ) second [ first ] map sum 1 - ;

:: match-rule ( rule to-match -- match ) rule second [ second to-match = ] any? [ rule first rule bag-count 2array ] [ f ] if ;

:: find-matching-rules ( rules to-match -- rules matching )
    rules dup [ to-match match-rule ] map [ f eq? not ] filter dup . ;

: find-all-matching-rules ( rules to-match -- rules matching )
    find-matching-rules [ [ second find-all-matching-rules ] map ] keep 2array flatten members ;

"7.txt" utf8 file-lines
[ parse-rule ] map
"shiny gold" find-all-matching-rules
length
.
drop
