USING: kernel io.files io.encodings.utf8 math prettyprint sequences
arrays locals lists combinators grouping math.ranges ;

IN: 10

: input ( -- lines ) "11.txt" utf8 file-lines [ 1 group ] map ;

:: adjacent-cell-indices ( row column -- indices )
     { -1 0 1 } { -1 0 1 } cartesian-product concat 4 swap remove-nth
     [ first2 [ row + ] [ column + ] bi* 2array ] map ;

:: adjacent-cells ( lines row column -- cells )
     row column adjacent-cell-indices
     [ first2 swap lines ?nth ?nth ] map
     [ ] filter ;

:: visible-cells ( lines row column -- cells )
     { -1 0 1 } { -1 0 1 } cartesian-product concat 4 swap remove-nth
     [
       50 [1,b)
       [ [let :> ( rc n )
         rc
         rc first2 [ n * row + ] [ n * column + ] bi*
         swap lines ?nth ?nth
         dup "." = [ drop f ] [ ] if
       ] ] map-find drop nip
     ] map ;

:: update-cell ( lines row cell column quot threshold -- lines row cell' )
     lines row
     {
       { [ lines row column quot call [ "#" = not ] all? cell "L" = and ]  [ "#" ] }
       { [ lines row column quot call [ "#" = ] count threshold >= cell "#" = and ] [ "L" ] }
       [ cell ]
     } cond ; inline

:: apply-rules ( lines quot threshold -- lines' )
   lines
   lines [ swap [ quot threshold update-cell ] map-index nip ] map-index nip ; inline

: count-occupied-seats ( lines -- count ) [ [ "#" = [ 1 ] [ 0 ] if ] map-sum ] map-sum ;

: part1 ( -- answer )
    input
    [ [ = ] keep swap ] [ dup [ adjacent-cells ] 4 apply-rules ] do until
    count-occupied-seats ;

: part2 ( -- answer )
    input
    [ [ = ] keep swap ] [ dup [ visible-cells ] 5 apply-rules ] do until
    count-occupied-seats ;

part1 .
part2 .
