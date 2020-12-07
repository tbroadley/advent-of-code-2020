USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser splitting splitting.extras
sets locals arrays math.intervals math.statistics ;

IN: 5-1

:: seat-parts ( seat -- a ) seat 7 head seat 7 tail 2array ;

:: parse-region ( s lo hi -- n ) s lo "0" replace hi "1" replace 2 base> ;

"5.txt" utf8 file-lines
[ seat-parts ] map
[ first2 [| row column | row "F" "B" parse-region column "L" "R" parse-region 2array ] call ] map
[ first2 [| row column | row 8 * column + ] call ] map
[ sum ] keep [ infimum ] keep [ supremum ] keep drop
[| min max | min max 2array mean max min - 1 + * ] call
swap -
.
