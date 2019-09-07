module Helpers.List exposing (getItemFromList, popItemFromList, removeFromList)


removeFromList : Int -> List a -> List a
removeFromList i xs =
    List.take i xs ++ List.drop (i + 1) xs


getItemFromList : Int -> List a -> Maybe a
getItemFromList index xs =
    if List.length xs >= index then
        List.take index xs
            |> List.reverse
            |> List.head

    else
        Nothing


popItemFromList : List a -> a -> ( a, List a )
popItemFromList xs defaultValue =
    let
        item =
            case getItemFromList 1 xs of
                Just value ->
                    value

                Nothing ->
                    defaultValue

        tail =
            removeFromList 0 xs
    in
    ( item, tail )
