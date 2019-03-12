module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Models exposing (..)
import EventHelpers exposing (..)

-- https://codepen.io/ramilulu/pen/mrNoXw

---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    SendButtonClicked ->
      ( model, Cmd.none )
    TextInput text ->
      ( { model | message = text }, Cmd.none )
    KeyDown key ->
      if key == 13 then
        addNewMessage model
      else
        ( model, Cmd.none )
    SendMessage message ->
      let
          newModel = { model | messages = List.filter (\x -> x.text /= "") model.messages }
      in
          addNewBotMessage { newModel | message = message}
        
    NoOp ->
      ( model, Cmd.none )



---- VIEW ----



messageItemView : Int -> Message -> Html Msg
messageItemView index message =
  if message.bot then
    let
      c = if message.text == "" then "message loading new" else "message"
    in
      div [ class c]
          [ figure [class "avatar"]
                   [ img [ src "https://www.gravatar.com/avatar/d63acca1aeea094dd10565935d93960b" ] []
                   ]
          , span [] [ text message.text ]
          ]
  else
    div [ class "message message-personal new" ] [ text message.text ]


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
                            , h2 [] [ text "Chief Dude Officer" ]
                            ]
                      , div [ class "messages" ]
                            [ div [ class "messages-content" ]
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



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
