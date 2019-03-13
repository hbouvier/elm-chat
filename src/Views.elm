module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import EventHelpers exposing (..)
import Models exposing (..)

import String exposing (slice, length)

---- VIEW ----

messageItemView : Int -> Message -> Html Msg
messageItemView index message =
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
      div []
        [ img [ src message.text, width 120, height 120 ] []
        ]

    Text ->
      let
        truncated = if length message.text > 120 then "..."  else ""
        s = (slice 0 120 message.text) ++ truncated
      in
        text s



view : Model -> Html Msg
view model =
  div [] 
      [ section [ class "avenue-messenger" ]
                [ div [ class "menu" ]
                      [ div [ class "items"]
                            [ span [] 
                                   [ a [ href "#", title "Minimize" ] [ text "&mdash;" ]
                                   , br [] []
                                   , a [ href "#", title "End Chat" ] [ text "&#10005;" ]
                                   ]
                            ]
                      , div [ class "button"] [ text "..." ]
                      ]
                , div [ class "agent-face" ]
                      [ div [ class "half" ]
                            [ img [ class "agent circle", src "https://www.gravatar.com/avatar/d63acca1aeea094dd10565935d93960b", alt "Henri Bouvier"] []
                            ]
                      ]
                , div [ class "chat" ]
                      [ div [ class "chat-title" ]
                            [ h1 [] [ text "Henri Bouvier" ]
                            , h2 [] [ text "Elm Grasshopper" ]
                            ]
                      , div [ class "messages" ]
                            [ div [ class "messages-content", id "messages-content-div" ]
                                  ( List.indexedMap messageItemView model.messages )
                            ]
                      , div [ class "message-box" ]
                            [ input [
                                class "message-input",
                                placeholder "Type message...",
                                onKeyDown KeyDown,
                                onInput TextInput,
                                value model.message                                
                              ] []
                            , button [ class "message-submit", onClick SendButtonClicked ] [ text "Send" ]
                            ]
                      ]
                ]
      ]

