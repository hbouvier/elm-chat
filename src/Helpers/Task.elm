module Helpers.Task exposing (delay)
import Task
import Process

delay : Float -> msg -> Cmd msg
delay time msg =
  Process.sleep time
  |> Task.andThen (always <| Task.succeed msg)
  |> Task.perform identity
