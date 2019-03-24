module API.Quote exposing (getRandomQuote)

import Http
import Json.Decode as D


getRandomQuote : (Result Http.Error String -> msg) -> Cmd msg
getRandomQuote msg =
    Http.get
        { url = "https://jsonp.afeld.me/?url=http://quotes.stormconsultancy.co.uk/random.json"
        , expect = Http.expectJson msg quoteDecoder
        }


quoteDecoder : D.Decoder String
quoteDecoder =
    D.field "quote" D.string
