module Main exposing (..)

import Browser
import Views exposing (..)
import Models exposing (..)
import Components.ScrollDiv as ScrollDiv

-- https://codepen.io/ramilulu/pen/mrNoXw

---- UPDATE ----

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    -- SendText Widget handles
    SendTextButtonClicked ->
      parseMessage model
    SendTextOnTextChange text ->
      ( { model | sendTextWidgetValue = text }, Cmd.none )
    SendTextOnKeyDown key ->
      if key == 13 then
        parseMessage model
      else
        ( model, Cmd.none )

    -- ScrollDiv widget handler
    ScrollDivScrollToBottom ->
      (model, ScrollDiv.scrollToBottom scrollDivConfig)

    -- Response from `quote` API
    ShowTextBubble result ->
      case result of
        Ok fullText ->
           addNewBotMessage (Message Bot (TextBubble fullText)) model
        Err _ ->
          ( model, Cmd.none )

    -- Response from `giphy` API
    ShowCard result ->
      case result of
        Ok url ->
           addNewBotMessage (Message Bot (CardBubble url)) model
        Err _ ->
          ( model, Cmd.none)

    -- User sending message to the bot
    SendMessage message ->
      let
          newModel
            = { model | 
                messages
                  = List.filter (\x -> 
                    case x.widget of
                      TextBubble "" ->
                        False
                      _  -> True
                  ) model.messages
              }
      in
          addNewBotMessage (Message Bot (TextBubble message)) newModel

    -- Nothing to do
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
