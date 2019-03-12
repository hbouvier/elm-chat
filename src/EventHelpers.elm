module EventHelpers exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode

onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger = on "keydown" (Decode.map tagger keyCode)
