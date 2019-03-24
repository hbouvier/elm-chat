module Views exposing (scrollDivConfig, sendTextConfig, view)

import Components.ScrollDiv as ScrollDiv
import Components.SendText as SendText
import Helpers.Event exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models exposing (..)
import Widgets.Bubble as Bubble


scrollDivConfig : ScrollDiv.Config
scrollDivConfig =
    { id = "messages-content-div"
    }


sendTextConfig : SendText.Config Msg
sendTextConfig =
    { sendMsg = SendTextButtonClicked
    , keyDown = SendTextOnKeyDown
    , onTextChange = SendTextOnTextChange
    }



---- VIEW ----


view : Model -> Html Msg
view model =
    let
        sendTextState =
            { text = model.sendTextWidgetValue
            }
    in
    div []
        [ section [ class "avenue-messenger" ]
            [ div [ class "menu" ]
                [ div [ class "items" ]
                    [ span []
                        [ a [ href "#", title "Minimize" ] [ text "&mdash;" ]
                        , br [] []
                        , a [ href "#", title "End Chat" ] [ text "&#10005;" ]
                        ]
                    ]
                , div [ class "button" ] [ text "..." ]
                ]
            , div [ class "agent-face" ]
                [ div [ class "half" ]
                    [ img [ class "agent circle", src "https://www.gravatar.com/avatar/d63acca1aeea094dd10565935d93960b", alt "Henri Bouvier" ] []
                    ]
                ]
            , div [ class "chat" ]
                [ div [ class "chat-title" ]
                    [ h1 [] [ text "Henri Bouvier" ]
                    , h2 [] [ text "Elm Grasshopper" ]
                    ]
                , div [ class "messages" ]
                    [ ScrollDiv.view scrollDivConfig (List.indexedMap Bubble.view model.messages)
                    ]
                , SendText.view sendTextConfig sendTextState
                ]
            ]
        ]
