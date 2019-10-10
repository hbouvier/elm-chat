module API.Watson exposing (getWatsonResponse)

import Http
import Json.Decode as D
import Json.Encode as E


getWatsonResponse : (Result Http.Error String -> msg) -> Maybe String -> Cmd msg
getWatsonResponse msg question =
    let
        text =
            case question of
                Just value ->
                    value

                Nothing ->
                    ""
    in
        
        Http.request
            { method = "POST"
            , headers = []
            , url = "https://info-nuagique.mybluemix.net/v1/watson"
            , body = Http.jsonBody (newWatsonRequestEncoder text)
            , expect = Http.expectJson msg watsonResponseDecoder
            , timeout = Nothing
            , tracker = Nothing
            }


newWatsonRequestEncoder : String -> E.Value
newWatsonRequestEncoder text =
    E.object
        [ ( "text", E.string text )
        ]


watsonResponseDecoder : D.Decoder String
watsonResponseDecoder =
    D.field "text" D.string
