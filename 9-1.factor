USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser splitting
arrays locals lists sets hash-sets lists.lazy combinators math.ranges ;

IN: 9-1

:: last-25-indices ( ix -- list ) ix 25 - ix [a,b) ;

:: has-property? ( numbers ix -- numbers ? )
     ix last-25-indices
     ix last-25-indices
     [ [let :> ( indices to-exclude ) indices dup [ to-exclude > ] filter [ to-exclude 2array ] map ] ] map concat
     [ first2 [let :> ( ix1 ix2 ) ix1 numbers nth ix2 numbers nth + ix numbers nth = ] ] any?
     [let :> ( discard ? ) numbers ? ] ;

: input ( -- lines ) "9.txt" utf8 file-lines [ string>number ] map ;

: part1 ( -- answer )
    input
    dup length 25 swap [a,b)
    [ has-property? not ] find
    swap drop swap nth ;

part1 .
