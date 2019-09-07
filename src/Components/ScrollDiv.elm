module Components.ScrollDiv exposing (Config, scrollToBottom, view)

import Browser.Dom exposing (getViewportOf, setViewportOf)
import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (..)
import Task


type alias Config =
    { id : String
    }


scrollToBottom : Config -> Cmd Msg
scrollToBottom config =
    getViewportOf config.id
        |> Task.andThen (\info -> setViewportOf config.id 0 info.scene.height)
        |> Task.attempt (\_ -> NoOp)


view : Config -> List (Html msg) -> Html msg
view config children =
    div [ class "messages-content", id "messages-content-div" ]
        children
