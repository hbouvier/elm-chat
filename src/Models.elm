module Models exposing (Message, MessageSource(..), Model, Msg(..), Widget(..), getCannedResponses, init, initialBotMessage)

import Helpers.List exposing (..)
import Helpers.Task exposing (delay)
import Http



---- MSG ----


type Msg
    = NoOp
    | SendTextOnKeyDown Int -- SendText widget ENTER handler
    | SendTextButtonClicked -- SendText widget button click handler
    | SendTextOnTextChange String -- SendText widget text handler
    | ScrollDivScrollToBottom -- ScrollDiv widget scroll to bottom
    | ShowTextBubble (Result Http.Error String) -- HTTP response with TEXT
    | ShowCard (Result Http.Error String) -- HTTP Response with image URL
    | SendMessage String -- CHAT time to add a bubble
    | Loaded



---- MODEL ----


type Widget
    = TextBubble String
    | CardBubble String


type MessageSource
    = User
    | Bot


type alias Message =
    { source : MessageSource
    , loading : Bool
    , widget : Widget
    }


type alias Model =
    { messages : List Message
    , sendTextWidgetValue : String
    , cannedReplies : List String
    }


init : ( Model, Cmd Msg )
init =
    let
        model =
            { messages = []
            , sendTextWidgetValue = ""
            , cannedReplies = getCannedResponses
            }
    in
    initialBotMessage model



-- Initialization


getCannedResponses : List String
getCannedResponses =
    [ "Hi there, I'm Henri and you?"
    , "Nice to meet you"
    , "How are you?"
    , "Not too bad, thanks"
    , "What do you do?"
    , "That's awesome"
    , "Elm is the way to go"
    , "I think you're a nice person"
    , "Why do you think that?"
    , "Can you explain?"
    , "Anyway I've gotta go now"
    , "It was a pleasure chat with you"
    , "Time to make a new Elm project"
    , "Bye"
    , ":)"
    ]


initialBotMessage : Model -> ( Model, Cmd Msg )
initialBotMessage model =
    let
        ( reply, cannedReplies ) =
            popItemFromList model.cannedReplies ":-)"

        newModel =
            { model | cannedReplies = cannedReplies }
    in
    ( newModel
    , Cmd.batch
        [ delay 0 <| SendMessage reply
        , delay 1000 <| Loaded
        , delay 1050 <| ScrollDivScrollToBottom
        , Cmd.none
        ]
    )
