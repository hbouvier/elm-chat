module Components.SendText exposing (Config, State, view)

import Helpers.Event exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias State =
    { text : String
    }


type alias Config msg =
    { sendMsg : msg
    , keyDown : Int -> msg
    , onTextChange : String -> msg
    }


view : Config msg -> State -> Html msg
view config state =
    div [ class "message-box" ]
        [ input
            [ class "message-input"
            , placeholder "Type message..."
            , onKeyDown config.keyDown
            , onInput config.onTextChange
            , value state.text
            ]
            []
        , button [ class "message-submit", onClick config.sendMsg ] [ text "Send" ]
        ]
