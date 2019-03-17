module Helpers.List exposing (..)

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
