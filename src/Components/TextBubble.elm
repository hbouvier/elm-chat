module Components.TextBubble exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import String exposing (slice, length)


view : String -> Html msg
view message =
    let
        truncated = if length message > 120 then "..."  else ""
        s = (slice 0 120 message) ++ truncated
    in
        text s
