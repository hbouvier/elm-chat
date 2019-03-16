module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import EventHelpers exposing (..)
import Models exposing (..)

import Components.Card as Card
import Components.TextBubble as TextBubble
import Components.SendText as SendText

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
      Card.view message.text

    Text ->
      TextBubble.view message.text



sendTextConfig : SendText.Config Msg
sendTextConfig =
    { sendMsg = SendButtonClicked
    , keyDown = KeyDown
    , textInput = TextInput
    }

view : Model -> Html Msg
view model =
  let
      sendTextState =
          { text = model.message
          }
  in
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
                        , SendText.view sendTextConfig sendTextState
                        ]
                  ]
        ]

