USING: kernel io.files io.encodings.utf8 math prettyprint
       strings math math.parser math.bitwise sequences locals
       combinators splitting assocs sequences.extras splitting arrays ;

IN: 20

: parse-image ( lines -- edges )
    [
      [ first ]
      [ [ last ] map >string ]
      [ last reverse ]
      [ [ first ] map reverse >string ]
    ] cleave 4array ;

: parse-tile ( lines -- id tile )
    [ first 5 tail 1 head* string>number ]
    [ 1 tail parse-image ] bi ;

: input ( -- alist )
    "20.txt" utf8 file-lines { "" } split
    [ parse-tile 2array ] map ;

input .
