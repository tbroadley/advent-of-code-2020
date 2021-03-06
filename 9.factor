USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser splitting
arrays locals lists sets hash-sets lists.lazy combinators math.ranges ;

IN: 9-1

:: last-25-indices ( ix -- list ) ix 25 - ix [a,b) ;

:: other-indices ( indices to-exclude -- indices other )
     indices dup [ to-exclude < ] filter [ to-exclude 2array ] map ;

:: numbers-sum? ( ix1 ix2 ix numbers -- ? )
     ix1 numbers nth ix2 numbers nth + ix numbers nth = ;

:: has-property? ( numbers ix -- numbers ? )
     ix last-25-indices
     ix last-25-indices
     [ other-indices ] map concat
     [ first2 ix numbers numbers-sum? ] any?
     [let :> ( _ ? ) numbers ? ] ;

: input ( -- lines ) "9.txt" utf8 file-lines [ string>number ] map ;

: part1 ( -- answer )
    input
    dup length 25 swap [a,b)
    [ has-property? not ] find
    swap drop swap nth ;

:: find-summing-run ( numbers _ to-check n -- summing-run )
     to-check
     [ first2 numbers subseq dup sum n = [ drop f ] unless ] map-find
     drop ;

: part2 ( -- answer )
    input
    dup length 0 swap [a,b)
    dup [ other-indices ] map concat
    part1
    find-summing-run
    [ infimum ] [ supremum ] bi + ;

part1 .
part2 .
