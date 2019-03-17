module Widgets.Bubble exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Widgets.Card as Card
import Widgets.TextBubble as TextBubble

import Models exposing (..)

view : Int -> Message -> Html Msg
view index message =
  if message.source == Bot then
    let
      c = case message.widget of
        TextBubble "" ->
          "message loading new"
        _ ->
          "message"
    in
      div [ class c ]
          [ figure [class "avatar"]
                   [ img [ src "https://www.gravatar.com/avatar/d63acca1aeea094dd10565935d93960b" ] []
                   ]
        , span [] [ viewWidget message ]
          ]
  else -- User
    div [ class "message message-personal new" ] [ viewWidget message ]

viewWidget : Message -> Html Msg
viewWidget message =
  case message.widget of
    -- Failure ->
    --   div []
    --     [ text "I could not load a random cat for some reason. "
    --     ]

    -- Loading ->
    --   text "Loading..."

    CardBubble url ->
      Card.view url

    TextBubble text ->
      TextBubble.view text
