module Main exposing (..)

import Html exposing (text)

helloString = "Hello world" ++ " " ++ toString 1337

main =
    text helloString
