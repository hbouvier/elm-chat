module Models exposing (..)

import Http
import Regex
import String exposing (join)
import API.Giphy exposing (getRandomGif)
import API.Quote exposing (getRandomQuote)
import Helpers.Task exposing (delay)
import Helpers.List exposing (..)

---- MSG ----

type Msg
    = NoOp
    | SendTextOnKeyDown Int                       -- SendText widget ENTER handler
    | SendTextButtonClicked                       -- SendText widget button click handler
    | SendTextOnTextChange String                 -- SendText widget text handler
    | ScrollDivScrollToBottom                     -- ScrollDiv widget scroll to bottom
    | ShowTextBubble (Result Http.Error String)   -- HTTP response with TEXT
    | ShowCard (Result Http.Error String)         -- HTTP Response with image URL
    | SendMessage String                          -- CHAT time to add a bubble

---- MODEL ----

type Widget
  = TextBubble String
  | CardBubble String

type MessageSource
  = User
  | Bot

type alias Message
  = {
    source: MessageSource
  , widget: Widget 
  }

type alias Model
  = {
    messages: List Message
  , sendTextWidgetValue: String
  , cannedReplies: List String
  }

init : ( Model, Cmd Msg )
init =
  let
    model
      = {
          messages = []
        , sendTextWidgetValue = ""
        , cannedReplies = [
            "Hi there, I'm Henri and you?",
            "Nice to meet you",
            "How are you?",
            "Not too bad, thanks",
            "What do you do?",
            "That's awesome",
            "Elm is the way to go",
            "I think you're a nice person",
            "Why do you think that?",
            "Can you explain?",
            "Anyway I've gotta go now",
            "It was a pleasure chat with you",
            "Time to make a new Elm project",
            "Bye",
            ":)"
        ]
      }
  in
    initialBotMessage model

-- Initialization

initialBotMessage : Model -> ( Model, Cmd Msg )
initialBotMessage model =
  let
     msg = case getItemFromList 1 model.cannedReplies of
      Just item -> item
      Nothing -> ":-)"

     newCannedReplied = removeFromList 0 model.cannedReplies
     newModel = { model | 
                   cannedReplies = newCannedReplied
                }
  in
     ( newModel, Cmd.batch [ 
                              delay(100) <| SendMessage "",
                              delay(1500) <| SendMessage msg,
                              delay(1550) <| ScrollDivScrollToBottom,
                              Cmd.none 
                           ] )

parseMessage : Model -> ( Model, Cmd Msg)
parseMessage model =
  let
    regex = 
      Maybe.withDefault Regex.never <|
        Regex.fromString " "
    tokens = Regex.split regex model.sendTextWidgetValue
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


slashGif: String -> Model -> ( Model, Cmd Msg)
slashGif search model =
     ( model, Cmd.batch [ 
                              getRandomGif ShowCard (Just search),
                              delay(1000) <| ScrollDivScrollToBottom,
                              Cmd.none 
                           ] )

slashQuote: Model -> ( Model, Cmd Msg)
slashQuote model =
     ( model, Cmd.batch [ 
                              getRandomQuote ShowTextBubble,
                              delay(1000) <| ScrollDivScrollToBottom,
                              Cmd.none 
                           ] )


addNewMessage : Model -> ( Model, Cmd Msg )
addNewMessage model =
  let
     msg = case getItemFromList 1 model.cannedReplies of
      Just item -> item
      Nothing -> ":-)"

     newCannedReplied = removeFromList 0 model.cannedReplies
     newModel = { model | 
                   messages = model.messages ++ [ 
                      Message User (TextBubble model.sendTextWidgetValue)
                   ],
                   sendTextWidgetValue = "",
                   cannedReplies = newCannedReplied
                }
  in
     ( newModel, Cmd.batch [ 
                              delay(100) <| SendMessage "",
                              delay(1500) <| SendMessage msg,
                              delay(1550) <| ScrollDivScrollToBottom,
                              Cmd.none 
                           ] )

addNewBotMessage : Message -> Model -> ( Model, Cmd Msg )
addNewBotMessage message model  =
  let
     newModel = { model | 
                   messages = model.messages ++ [ 
                      message
                   ],
                   sendTextWidgetValue = ""
                }

  in
     ( newModel, Cmd.batch [ delay(1) <| ScrollDivScrollToBottom, Cmd.none ] )
