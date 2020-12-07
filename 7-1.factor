USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser splitting splitting.extras
arrays regexp locals sequences.deep sets ;

IN: 7-1

: parse-rule-rhs ( rhs -- parsed ) [ " ." member? ] trim R/ \s(bags?)/ "" re-replace " " split1 swap drop ;

: parse-rule ( rule -- parsed ) " bags contain " split1 "," split [ parse-rule-rhs ] map 2array ;

:: find-matching-rules ( rules to-match -- rules matching )
    rules dup [ second [ to-match = ] any? ] filter [ first ] map ;

: find-all-matching-rules ( rules to-match -- rules count )
    find-matching-rules [ [ find-all-matching-rules ] map ] keep 2array flatten members ;

"7.txt" utf8 file-lines
[ parse-rule ] map
"shiny gold" find-all-matching-rules
length
.
drop
