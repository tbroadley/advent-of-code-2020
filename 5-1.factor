USING: kernel io.files io.encodings.utf8 math prettyprint sequences math.parser splitting splitting.extras
sets locals arrays ;

IN: 5-1

:: seat-parts ( seat -- a ) seat 7 head seat 7 tail 2array ;

:: parse-region ( s lo hi -- n ) s lo "0" replace hi "1" replace 2 base> ;

"5.txt" utf8 file-lines
[ seat-parts ] map
[ first2 [| row column | row "F" "B" parse-region column "L" "R" parse-region 2array ] call ] map
[ first2 [| row column | row 8 * column + ] call ] map
supremum
.
