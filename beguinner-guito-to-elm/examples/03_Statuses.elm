module AnotherHello exposing (..)

import Html exposing (..)


checkStatus : Int -> String
checkStatus status =
    if status == 200 then
        "You got it!"
    else if status == 404 then
        "Page not found"
    else
        "Unknown response"


statusChecks : List String
statusChecks =
    [ checkStatus 200
    , checkStatus 404
    , checkStatus 418
    ]


renderList : List String -> Html msg
renderList lst =
    lst
        --Using anon func and using a func
        --|> List.map (\l -> li [] [ text l ])
        |> List.map (createLi)
        |> ul []


createLi : String -> Html msg
createLi str =
    li [] [ text str ]


main =
    div []
        [ h1 [] [ text "List of statuses:" ]
        , renderList statusChecks
        ]
