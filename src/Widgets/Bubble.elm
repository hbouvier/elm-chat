module Widgets.Bubble exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Widgets.Card as Card
import Widgets.TextBubble as TextBubble

import Models exposing (..)

view : Int -> Message -> Html Msg
view index message =
  if message.bot then
    let
      c = if message.text == "" then "message loading new" else "message"
    in
      div [ class c ]
          [ figure [class "avatar"]
                   [ img [ src "https://www.gravatar.com/avatar/d63acca1aeea094dd10565935d93960b" ] []
                   ]
        , span [] [ viewWidget message ]
          ]
  else
    div [ class "message message-personal new" ] [ viewWidget message ]

viewWidget : Message -> Html Msg
viewWidget message =
  case message.widgetType of
    Failure ->
      div []
        [ text "I could not load a random cat for some reason. "
        ]

    Loading ->
      text "Loading..."

    Card ->
      Card.view message.text

    Text ->
      TextBubble.view message.text
