module Widgets.Bubble exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (..)
import Widgets.Card as Card
import Widgets.TextBubble as TextBubble


type alias State =
    Bool


view : Int -> Message -> Html msg
view index message =
    if message.source == Bot then
        let
            c =
                if message.loading then
                    "message loading new"

                else
                    "message"
        in
        div [ class c, id (String.fromInt index) ]
            [ figure [ class "avatar" ]
                [ img [ src "https://www.gravatar.com/avatar/d63acca1aeea094dd10565935d93960b" ] []
                ]
            , span [] [ viewWidget message ]
            ]

    else
        -- User
        div [ class "message message-personal new" ] [ viewWidget message ]


viewWidget : Message -> Html msg
viewWidget message =
    case message.widget of
        -- Failure ->
        --   div []
        --     [ text "I could not load a random cat for some reason. "
        --     ]
        CardBubble url ->
            Card.view url

        TextBubble text ->
            TextBubble.view text
