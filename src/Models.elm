port module Models exposing (..)

import Time
import Process
import Task


type Msg
    = NoOp
    | KeyDown Int
    | SendButtonClicked
    | TextInput String
    | SendMessage String

---- MODEL ----

type alias Message = { 
  text: String,
  bot: Bool }

type alias Model = { 
    messages: List Message,
    message: String }

init : ( Model, Cmd Msg )
init =
    ( { messages = [], message = "" }, Cmd.none )



-- ADD Message

addNewMessage : Model -> ( Model, Cmd Msg )
addNewMessage model =
  let
     newModel = { model | 
                   messages = model.messages ++ [ 
                      Message model.message False
                   ],
                   message = ""
                }
  in
     ( newModel, Cmd.batch [ 
                              delay(1000) <| SendMessage "",
                              delay(2500) <| SendMessage "yo!",
                              Cmd.none 
                           ] )

addNewBotMessage : Model -> ( Model, Cmd Msg )
addNewBotMessage model =
  let
     newModel = { model | 
                   messages = model.messages ++ [ 
                      Message model.message True
                   ],
                   message = ""
                }
  in
     ( newModel, Cmd.none )


--

delay : Float -> msg -> Cmd msg
delay time msg =
  Process.sleep time
  |> Task.andThen (always <| Task.succeed msg)
  |> Task.perform identity
