USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser splitting
arrays locals lists sets hash-sets lists.lazy combinators ;

IN: 8-1

: parse-instruction ( line -- instruction ) " " split1 string>number 2array ;

: record-pc ( seen pc -- newseen ) 1array >hash-set union ;

:: update-pc-acc ( pc acc program -- newpc newacc )
     pc program nth {
       { [ dup first "acc" = ] [ [let :> ( instruction ) pc 1 + instruction second acc + ] ] }
       { [ dup first "jmp" = ] [ [let :> ( instruction ) instruction second pc + acc ] ] }
       { [ first "nop" = ]     [ pc 1 + acc ] }
     } cond ;

:: simulate-instruction-helper ( program pc acc seen -- newstate )
     seen pc record-pc
     pc acc program update-pc-acc
     [let :> ( newseen newpc newacc ) program newpc newacc newseen ] 4array ;

:: simulate-instruction ( state -- newstate ) state first4 simulate-instruction-helper ;

: loop-detected? ( state -- ? ) [ second ] [ fourth ] bi in? ;

: program-done? ( state -- ? ) [ first length ] [ second ] bi = ;

: done? ( state -- ? ) [ loop-detected? ] [ program-done? ] bi or ;

: simulate ( state -- finalstate ) [ dup done? not ] [ simulate-instruction ] while ;

: create-state ( program -- state ) 0 0 100 <hash-set> 4array ;

:: replace-instruction ( instruction new -- newinstruction ) new instruction second 2array ;

: flip-instruction ( instruction -- newinstruction )
    {
      { [ dup first "acc" = ] [ ] }
      { [ dup first "jmp" = ] [ "nop" replace-instruction ] }
      { [ dup first "nop" = ] [ "jmp" replace-instruction ] }
    } cond ;

:: generate-candidate-program ( program elt ix -- newprogram )
     elt flip-instruction
     ix
     ix program remove-nth
     insert-nth ;

:: simulate-changed-program ( program elt ix -- program finalstate )
     program
     program elt ix generate-candidate-program
     create-state
     simulate ;

"8.txt" utf8 file-lines
[ parse-instruction ] map
dup
[ simulate-changed-program ] map-index
[ program-done? ] find
third
.
drop
drop
