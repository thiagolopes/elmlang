module HelloTwo exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)


main : Html msg
main =
    div [ class "elm-div" ]
        [ h1 [ class "banner" ] [ text "Welcom to my Elm Site :D" ]
        , p [] [ text "Iam liking Elm so far!" ]
        , p [] [ text "Eager to lear more about Elm" ]
        ]
