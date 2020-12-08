USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser splitting
arrays locals lists sets hash-sets lists.lazy combinators ;

IN: 8-1

: parse-instruction ( line -- instruction ) " " split1 string>number 2array ;

: record-pc ( seen pc -- newseen ) 1array >hash-set union ;

:: update-pc-acc ( pc acc program -- newpc newacc )
     pc program nth {
       { [ dup first "acc" = ] [ [let :> ( instruction ) pc 1 + instruction second acc + 2array ] ] }
       { [ dup first "jmp" = ] [ [let :> ( instruction ) instruction second pc + acc 2array ] ] }
       { [ first "nop" = ]     [ pc 1 + acc 2array ] }
     } cond first2 ;

:: simulate-instruction-helper ( program pc acc seen -- newstate )
     seen pc record-pc
     pc acc program update-pc-acc
     [let :> ( newseen newpc newacc ) program newpc newacc newseen ] 4array ;

:: simulate-instruction ( state -- newstate ) state first4 simulate-instruction-helper ;

: loop-detected? ( state -- ? ) [ second ] [ fourth ] bi in? ;

: program-done? ( state -- ? ) [ first length ] [ second ] bi = ;

: done? ( state -- state ? ) [ ] [ loop-detected? ] [ program-done? ] tri or ;

: create-state ( program -- state ) 0 0 100 <hash-set> 4array ;

: simulate ( state -- finalstate ) [ done? not ] [ simulate-instruction ] while ;

: flip-instruction ( instruction -- newinstruction )
    {
      { [ dup first "acc" = ] [ ] }
      { [ dup first "jmp" = ] [ [let :> ( instruction ) "nop" instruction second 2array ] ] }
      { [ dup first "nop" = ] [ [let :> ( instruction ) "jmp" instruction second 2array ] ] }
    } cond ;

:: generate-candidate-program ( program elt index -- newprogram )
     elt flip-instruction
     index
     index program remove-nth
     insert-nth ;

:: go ( program elt index -- program finalstate )
     program program elt index generate-candidate-program create-state simulate ;

"8.txt" utf8 file-lines
[ parse-instruction ] map
dup
[ go ] map-index
[ program-done? ] find
third
.
drop
drop
