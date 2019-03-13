module Models exposing (..)

import Time
import Process
import Task
import Http
import Json.Decode exposing (Decoder, field, string)

type Msg
    = NoOp
    | KeyDown Int
    | SendButtonClicked
    | TextInput String
    | SendMessage String
    | ScrollToBottom
    | GotText (Result Http.Error String)
    | GotGif (Result Http.Error String)


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

removeFromList : Int -> List a -> List a
removeFromList i xs =
  (List.take i xs) ++ (List.drop (i+1) xs) 


getItemFromList: Int -> List a -> Maybe a
getItemFromList index xs =
   if  (List.length xs) >= index then
        List.take index xs
        |> List.reverse
        |> List.head
   else 
      Nothing


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
                              Http.get { 
                                url = "https://elm-lang.org/assets/public-opinion.txt"
                              , expect = Http.expectString GotText
                              },
                              getRandomCatGif,
                              delay(100) <| SendMessage "",
                              delay(1500) <| SendMessage msg,
                              delay(1550) <| ScrollToBottom,
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




getRandomCatGif : Cmd Msg
getRandomCatGif =
  Http.get
    { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
    , expect = Http.expectJson GotGif gifDecoder
    }


gifDecoder : Decoder String
gifDecoder =
  field "data" (field "image_url" string)



--

delay : Float -> msg -> Cmd msg
delay time msg =
  Process.sleep time
  |> Task.andThen (always <| Task.succeed msg)
  |> Task.perform identity
