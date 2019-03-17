module Models exposing (..)

import Time
import Process
import Task
import Http
import Json.Decode as D exposing (Decoder, field, string, list, map3)
-- import Json.Decode exposing (Decoder, field, string, list, map3)
import ListHelpers exposing (..)
import Regex
import String exposing (join)

type Msg
    = NoOp
    | KeyDown Int                          -- SendText widget ENTER handler
    | SendButtonClicked                    -- SendText button click handler
    | TextInput String                     -- SendText text handler
    | ScrollToBottom                       -- ScrollDiv scroll to bottom
    | GotText (Result Http.Error String)   -- HTTP response with TEXT
    | GotGif (Result Http.Error String)    -- HTTP Response with gif URL
    | GotListOfQuotes (Result Http.Error QuoteAPIResponse)
    | SendMessage String                   -- CHAT time to add a bubble

---- MODEL ----

type WidgetType
  = Text
  | Card
  | Failure
  | Loading

type alias Message = { 
  widgetType: WidgetType,
  text: String,
  bot: Bool }

type alias Widget = { 
  widgetType: WidgetType,
  bot: Bool,
  payload: String}


type alias Model = { 
    messages: List Message,
    message: String,
    cannedReplies: List String}

init : ( Model, Cmd Msg )
init =
  let model = { messages = [], 
        message = "",
        cannedReplies = [
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
        ]}
  in
    initialBotMessage model

-- ADD Message



initialBotMessage : Model -> ( Model, Cmd Msg )
initialBotMessage model =
  let
     msg = case getItemFromList 1 model.cannedReplies of
      Just item -> item
      Nothing -> ":-)"

     newCannedReplied = removeFromList 0 model.cannedReplies
     newModel = { model | 
                   messages = model.messages ++ [ 
                      Message Text model.message False
                   ],
                   message = "",
                   cannedReplies = newCannedReplied
                }
  in
     ( newModel, Cmd.batch [ 
                              delay(100) <| SendMessage "",
                              delay(1500) <| SendMessage msg,
                              delay(1550) <| ScrollToBottom,
                              Cmd.none 
                           ] )

parseMessage : Model -> ( Model, Cmd Msg)
parseMessage model =
  let
    regex = 
      Maybe.withDefault Regex.never <|
        Regex.fromString " "
    tokens = Regex.split regex model.message
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
                              getRandomCatGif search,
                              delay(1000) <| ScrollToBottom,
                              Cmd.none 
                           ] )

slashQuote: Model -> ( Model, Cmd Msg)
slashQuote model =
     ( model, Cmd.batch [ 
                              getRandomQuote,
                              delay(1000) <| ScrollToBottom,
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
                      Message Text model.message False
                   ],
                   message = "",
                   cannedReplies = newCannedReplied
                }
  in
     ( newModel, Cmd.batch [ 
                              delay(100) <| SendMessage "",
                              delay(1500) <| SendMessage msg,
                              delay(1550) <| ScrollToBottom,
                              Cmd.none 
                           ] )

addNewBotMessage : WidgetType -> Model -> ( Model, Cmd Msg )
addNewBotMessage widgetType model  =
  let
     newModel = { model | 
                   messages = model.messages ++ [ 
                      Message widgetType model.message True
                   ],
                   message = ""
                }

  in
     ( newModel, Cmd.batch [ delay(1) <| ScrollToBottom, Cmd.none ] )

getRandomQuote: Cmd Msg
getRandomQuote =
  Http.get 
    {
      url = "https://jsonp.afeld.me/?url=http://quotes.stormconsultancy.co.uk/random.json"
    , expect = Http.expectJson GotText simpleQuoteDecoder
    }

getRandomQuote2: Cmd Msg
getRandomQuote2 =
  Http.get 
    {
      url = "https://theysaidso.com/api/qod"
    , expect = Http.expectJson GotListOfQuotes quoteAPIResponseDecoder
    }

getOpinion: Cmd Msg
getOpinion =
  Http.get 
    {
      url = "https://elm-lang.org/assets/public-opinion.txt"
    , expect = Http.expectString GotText
    }


getRandomCatGif : String -> Cmd Msg
getRandomCatGif search =
  Http.get
    { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ search
    , expect = Http.expectJson GotGif gifDecoder
    }

type alias Quote =
  { quote: String
  , author: String
  }

type alias Contents =
  { quotes: List Quote
  }

type alias QuoteAPIResponse =
    { contents : Contents
    }

quoteDecoder: D.Decoder Quote
quoteDecoder =
  D.map2 
    Quote
    (D.field "quote" D.string)
    (D.field "author" D.string)

quotesDecoder: D.Decoder (List Quote)
quotesDecoder =
  D.list quoteDecoder

contentsDecoder: D.Decoder Contents
contentsDecoder =
  D.map
    Contents
    (D.field "quotes" quotesDecoder)

quoteAPIResponseDecoder: D.Decoder QuoteAPIResponse
quoteAPIResponseDecoder =
  D.map
  QuoteAPIResponse
  (D.field "contents" contentsDecoder)


gifDecoder : Decoder String
gifDecoder =
  field "data" (field "image_url" string)

simpleQuoteDecoder : Decoder String
simpleQuoteDecoder =
  field "quote" string

--

delay : Float -> msg -> Cmd msg
delay time msg =
  Process.sleep time
  |> Task.andThen (always <| Task.succeed msg)
  |> Task.perform identity
