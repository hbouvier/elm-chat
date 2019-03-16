module Components.Card exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view : String -> Html msg
view url =
    div []
        [ img [ src url, width 120, height 120 ] []
    ]
