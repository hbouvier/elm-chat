module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Views exposing (..)
import Models exposing (..)
import Json.Encode as Encode

import Browser.Dom exposing (getViewportOf, setViewportOf)
import Task

-- https://codepen.io/ramilulu/pen/mrNoXw

---- UPDATE ----


viewportId =
    "messages-content-div"


jumpToBottom : String -> Cmd Msg
jumpToBottom id =
  getViewportOf id
    |> Task.andThen (\info -> setViewportOf id 0 info.scene.height)
    |> Task.attempt (\_ -> NoOp)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    SendButtonClicked ->
      addNewMessage model
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
          addNewBotMessage Text { newModel | message = message}
    ScrollToBottom ->
      (model, jumpToBottom viewportId)
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