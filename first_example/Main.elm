module Main exposing (..)

import Html exposing (h1, div, text, button, input)
import Html.Attributes exposing (class, placeholder)
import Html.Events exposing (onClick)


-- Model


type alias Model =
    { counter : Int, clicks : Int }


initialModel : Model
initialModel =
    { counter = 0
    , clicks = 0
    }



--- Update


type Msg
    = Increment
    | Decrement
    | IncrementTwo
    | DecrementTwo


update : Msg -> Model -> Model
update msg model =
    let
        newModel =
            { model | clicks = model.clicks + 1 }
    in
        case msg of
            Increment ->
                { newModel
                    | counter = model.counter + 1
                    , clicks = model.clicks + 1
                }

            Decrement ->
                { newModel
                    | counter = model.counter - 1
                    , clicks = model.clicks + 1
                }

            IncrementTwo ->
                { newModel
                    | counter = model.counter + 2
                    , clicks = model.clicks + 1
                }

            DecrementTwo ->
                { newModel
                    | counter = model.counter - 2
                    , clicks = model.clicks + 1
                }



--- View


view : Model -> Html.Html Msg
view model =
    div
        []
        [ button [ onClick Decrement ] [ text "-" ]
        , button [ onClick DecrementTwo ] [ text "remove 2" ]
        , h1 [] [ text <| toString model.counter ]
        , button [ onClick Increment ] [ text "+" ]
        , button [ onClick IncrementTwo ] [ text "add 2" ]
        , (toString model.clicks) ++ " click " |> text
        ]



-- Main


main =
    Html.beginnerProgram
        { model = initialModel
        , update = update
        , view = view
        }
