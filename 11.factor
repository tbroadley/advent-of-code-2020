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

:: update-cell ( lines row cell column -- lines row cell' )
     lines row
     {
       { [ lines row column adjacent-cells [ "#" = not ] all? cell "L" = and ]  [ "#" ] }
       { [ lines row column adjacent-cells [ "#" = ] count 3 > cell "#" = and ] [ "L" ] }
       [ cell ]
     } cond ;

:: update-cell-2 ( lines row cell column -- lines row cell' )
     lines row
     {
       { [ lines row column visible-cells [ "#" = not ] all? cell "L" = and ]  [ "#" ] }
       { [ lines row column visible-cells [ "#" = ] count 4 > cell "#" = and ] [ "L" ] }
       [ cell ]
     } cond ;

: apply-rules ( lines -- lines' ) dup [ swap [ update-cell ] map-index nip ] map-index nip ;

: apply-rules-2 ( lines -- lines' ) dup [ swap [ update-cell-2 ] map-index nip ] map-index nip ;

: count-occupied-seats ( lines -- count ) [ [ "#" = [ 1 ] [ 0 ] if ] map-sum ] map-sum ;

: part1 ( -- answer )
    input
    [ [ = ] keep swap ] [ dup apply-rules ] do until
    count-occupied-seats ;

: part2 ( -- answer )
    input
    [ [ = ] keep swap ] [ dup apply-rules-2 ] do until
    count-occupied-seats ;

part1 .
part2 .
