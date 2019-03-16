module Views exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import EventHelpers exposing (..)
import Models exposing (..)

import Components.SendText as SendText
import Widgets.Bubble as Bubble

---- VIEW ----

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
                        , div [ class "messages" ] [
                              Bubble.view model
                        ]
                        , SendText.view sendTextConfig sendTextState
                        ]
                  ]
        ]

