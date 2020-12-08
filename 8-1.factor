USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser splitting
arrays locals lists sets hash-sets lists.lazy combinators ;

IN: 8-1

: parse-instruction ( line -- instruction ) " " split1 string>number 2array ;

:: simulate-instruction-helper ( program pc acc seen -- newstate )
     seen { pc } >hash-set union
     pc program nth {
       { [ dup first "acc" = ] [ [let :> ( instruction ) pc 1 + instruction second acc + 2array ] ] }
       { [ dup first "jmp" = ] [ [let :> ( instruction ) instruction second pc + acc 2array ] ] }
       { [ first "nop" = ]     [ pc 1 + acc 2array ] }
     } cond first2
     [let :> ( newseen newpc newacc ) program newpc newacc newseen ] 4array ;

:: simulate-instruction ( state -- newstate ) state first4 simulate-instruction-helper ;

: not-done? ( state -- state ? ) dup [ second ] [ fourth ] bi in? not ;

"8.txt" utf8 file-lines
[ parse-instruction ] map
0 0 100 <hash-set> 4array
[ not-done? ] [ simulate-instruction ] while
third .
