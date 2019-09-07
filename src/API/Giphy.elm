module API.Giphy exposing (getRandomGif)

import Http
import Json.Decode as D


getRandomGif : (Result Http.Error String -> msg) -> Maybe String -> Cmd msg
getRandomGif msg search =
    let
        params =
            case search of
                Just text ->
                    "&tag=" ++ text

                Nothing ->
                    ""
    in
    Http.get
        { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC" ++ params
        , expect = Http.expectJson msg giphyDecoder
        }


giphyDecoder : D.Decoder String
giphyDecoder =
    D.field "data"
        (D.field "image_url" D.string)
