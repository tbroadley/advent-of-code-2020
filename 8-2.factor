USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser splitting
arrays locals lists sets hash-sets lists.lazy combinators ;

IN: 8-1

: parse-instruction ( line -- instruction ) " " split1 string>number 2array ;

: record-pc ( seen pc -- newseen ) 1array >hash-set union ;

:: update-pc ( instruction n pc -- newpc )
     instruction "jmp" =
     [ pc n + ]
     [ pc 1 + ]
     if ;

:: update-acc ( instruction n acc -- newacc )
     instruction "acc" =
     [ acc n + ]
     [ acc ]
     if ;

:: simulate-instruction-helper ( program pc acc seen -- program newpc newacc newseen )
     program
     pc program nth first2 [ pc update-pc ] [ acc update-acc ] 2bi
     seen pc record-pc ;

:: simulate-instruction ( state -- newstate ) state first4 simulate-instruction-helper 4array ;

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
