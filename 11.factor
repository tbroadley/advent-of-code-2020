USING: kernel io.files io.encodings.utf8 math prettyprint sequences
arrays locals lists combinators grouping math.ranges ;

IN: 11

: input ( -- lines ) "11.txt" utf8 file-lines [ 1 group ] map ;

: index-into ( r c lines -- cell ) [ swap ] dip ?nth ?nth ;

: adjacent-cell-offsets ( -- offsets )
    { -1 0 1 } { -1 0 1 } cartesian-product concat
    4 swap remove-nth ;

:: offset ( rc n row column -- row' column' ) rc first2 [ n * row + ] [ n * column + ] bi* ;

:: adjacent-cell-indices ( row column -- indices )
     adjacent-cell-offsets
     [ 1 row column offset 2array ] map ;

:: adjacent-cells ( lines row column -- cells )
     row column adjacent-cell-indices
     [ first2 lines index-into ] map
     [ ] filter ;

:: find-visible-cell ( rc n lines row column -- rc visible-cell )
     rc
     rc n row column offset
     lines index-into
     dup "." = [ drop f ] [ ] if ;

:: visible-cells ( lines row column -- cells )
     adjacent-cell-offsets
     [ 50 [1,b) [ lines row column find-visible-cell ] map-find drop nip ] map ;

:: update-cell ( lines row cell column quot threshold -- lines row cell' )
     lines row
     lines row column quot call
     {
       { [ dup [ "#" = not ] all?           cell "L" = and ] [ drop "#" ] }
       { [     [ "#" = ] count threshold >= cell "#" = and ] [ "L" ]      }
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
