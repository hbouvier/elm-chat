module Widgets.Card exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)


view : String -> Html msg
view url =
    div []
        [ img [ src url, width 260, height 180 ] []
        ]
