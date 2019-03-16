module Components.SendText exposing (State, Config, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import EventHelpers exposing (..)


type alias State =
  { text : String
  }

type alias Config msg =
  { sendMsg: msg
  , keyDown: Int -> msg
  , textInput: String -> msg
  }


view : Config msg -> State -> Html msg
view config state =
  div [ class "message-box" ]
    [ input [
        class "message-input"
      , placeholder "Type message..."
      , onKeyDown config.keyDown
      , onInput config.textInput
      , value state.text
      ] []
    , button [ class "message-submit", onClick config.sendMsg ] [ text "Send" ]
    ]
