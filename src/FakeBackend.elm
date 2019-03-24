module FakeBackend exposing (addNewBotMessage, addNewMessage, parseMessage, slashGif, slashQuote)

import API.Giphy exposing (getRandomGif)
import API.Quote exposing (getRandomQuote)
import Helpers.List exposing (..)
import Helpers.Task exposing (delay)
import Http
import Models exposing (..)
import Regex
import String exposing (join)


parseMessage : Model -> ( Model, Cmd Msg )
parseMessage model =
    let
        regex =
            Maybe.withDefault Regex.never <|
                Regex.fromString " "

        tokens =
            Regex.split regex model.sendTextWidgetValue
    in
    case List.head tokens of
        Just "/quote" ->
            slashQuote model

        Just "/gif" ->
            slashGif (join "+" (removeFromList 0 tokens)) model

        Just _ ->
            addNewMessage model

        Nothing ->
            addNewMessage model


slashGif : String -> Model -> ( Model, Cmd Msg )
slashGif search model =
    ( model
    , Cmd.batch
        [ getRandomGif ShowCard (Just search)
        , delay 1000 <| ScrollDivScrollToBottom
        , Cmd.none
        ]
    )


slashQuote : Model -> ( Model, Cmd Msg )
slashQuote model =
    ( model
    , Cmd.batch
        [ getRandomQuote ShowTextBubble
        , delay 1000 <| ScrollDivScrollToBottom
        , Cmd.none
        ]
    )


addNewMessage : Model -> ( Model, Cmd Msg )
addNewMessage model =
    let
        msg =
            case getItemFromList 1 model.cannedReplies of
                Just item ->
                    item

                Nothing ->
                    ":-)"

        newCannedReplied =
            removeFromList 0 model.cannedReplies

        newModel =
            { model
                | messages =
                    model.messages
                        ++ [ Message User True (TextBubble model.sendTextWidgetValue)
                           ]
                , sendTextWidgetValue = ""
                , cannedReplies = newCannedReplied
            }
    in
    ( newModel
    , Cmd.batch
        [ delay 0 <| SendMessage msg
        , delay 50 <| ScrollDivScrollToBottom
        , delay 1000 <| Loaded
        , delay 1050 <| ScrollDivScrollToBottom
        , Cmd.none
        ]
    )


addNewBotMessage : Message -> Model -> ( Model, Cmd Msg )
addNewBotMessage message model =
    let
        newModel =
            { model
                | messages =
                    model.messages
                        ++ [ message
                           ]
                , sendTextWidgetValue = ""
            }
    in
    ( newModel, Cmd.batch [ delay 1 <| ScrollDivScrollToBottom, Cmd.none ] )
