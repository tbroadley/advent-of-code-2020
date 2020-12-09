USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser splitting
arrays locals lists sets hash-sets lists.lazy combinators math.ranges ;

IN: 9-1

:: last-25-indices ( ix -- list ) ix 25 - ix [a,b) ;

:: has-property? ( numbers ix -- numbers ? )
     ix last-25-indices
     [ [let :> ( first-ix ) ix last-25-indices [ first-ix = not ] filter ] ] map
     numbers f ;

"9.txt" utf8 file-lines
[ string>number ] map
dup length 25 swap [a,b)
[ has-property? not ] find
drop swap nth .
