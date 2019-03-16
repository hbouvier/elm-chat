module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Views exposing (..)
import Models exposing (..)
import Json.Encode as Encode
import Components.ScrollDiv as ScrollDiv

-- https://codepen.io/ramilulu/pen/mrNoXw

---- UPDATE ----

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    SendButtonClicked ->
      parseMessage model
    TextInput text ->
      ( { model | message = text }, Cmd.none )
    KeyDown key ->
      if key == 13 then
        parseMessage model
      else
        ( model, Cmd.none )
    SendMessage message ->
      let
          newModel = { model | messages = List.filter (\x -> x.text /= "") model.messages }
      in
          addNewBotMessage Text { newModel | message = message}
    ScrollToBottom ->
      (model, ScrollDiv.scrollToBottom scrollDivConfig)
    GotText result ->
      case result of
        Ok fullText ->
           addNewBotMessage Text { model | message = fullText}
        Err _ ->
          ( model, Cmd.none )
    GotGif result ->
      case result of
        Ok url ->
           addNewBotMessage Card { model | message = url }
        Err _ ->
          ( model, Cmd.none)
    NoOp ->
      ( model, Cmd.none )

---- PROGRAM ----


main : Program () Model Msg -- Maybe Model
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
