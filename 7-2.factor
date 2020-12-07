USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser splitting splitting.extras
arrays regexp locals sequences.deep sets sequences.extras ;

IN: 7-1

: parse-bag-description ( desc -- parsed ) " " split1
                                           [let :> ( n desc ) n string>number [ ] [ 0 ] if* desc ] 2array ;

: parse-rule-rhs ( rhs -- parsed ) [ " ." member? ] trim R/ \s(bags?)/ "" re-replace parse-bag-description ;

: parse-rule ( rule -- parsed ) " bags contain " split1 "," split [ parse-rule-rhs ] map 2array ;

:: bag-count ( rules rule-name -- rules count ) rules [ [ first rule-name = ] find swap drop second ] keep swap
                                                [ first2 [let :> ( rules n name ) rules name "other" = not [ name bag-count 1 + n * ] [ 0 ] if ] ] map
                                                sum ;

"7.txt" utf8 file-lines
[ parse-rule ] map
"shiny gold" bag-count
.
drop
