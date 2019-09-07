module Main exposing (main, update)

import Browser
import Components.ScrollDiv as ScrollDiv
import FakeBackend exposing (..)
import Helpers.Task exposing (delay)
import Models exposing (..)
import Views exposing (..)



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
            ( model, ScrollDiv.scrollToBottom scrollDivConfig )

        -- Response from `quote` API
        ShowTextBubble result ->
            case result of
                Ok fullText ->
                    addNewBotMessage (Message Bot False (TextBubble fullText)) model

                Err _ ->
                    ( model, Cmd.none )

        -- Response from `giphy` API
        ShowCard result ->
            case result of
                Ok url ->
                    addNewBotMessage (Message Bot False (CardBubble url)) model

                Err _ ->
                    ( model, Cmd.none )

        -- User sending message to the bot
        SendMessage message ->
            addNewBotMessage (Message Bot True (TextBubble message)) model

        -- Remove the loading bubble
        Loaded ->
            let
                newModel =
                    { model
                        | messages =
                            List.map
                                (\x ->
                                    case x.loading of
                                        True ->
                                            { x | loading = False }

                                        False ->
                                            x
                                )
                                model.messages
                    }
            in
            ( newModel, Cmd.none )

        -- Nothing to do
        NoOp ->
            ( model, Cmd.none )



---- PROGRAM ----


main : Program () Model Msg



-- Maybe Model


main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
