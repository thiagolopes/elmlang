module Main exposing (..)

import Animate.Css exposing (shake, animated)
import Html exposing (Html, hr, button, br, h1, body, text, div, ul, li, input)
import Html.Events exposing (onInput)
import Html.Attributes exposing (class)
import Markdown


-- Model


type alias Model =
    { first_name : String }


model : Model
model =
    Model ""


markdown_text =
    """
# Hello world

## my markdown code

* item 1
* item 2
"""



-- update


type Msg
    = First String


update : Msg -> Model -> Model
update msg model =
    case msg of
        First new_name ->
            { model | first_name = new_name }



-- view


view : Model -> Html Msg
view model =
    body [ class animated ]
        [ h1 [ class shake ] [ text "Hello world" ]
        , ul []
            [ li
                []
                [ text "item 1" ]
            , li
                []
                [ text "item 2" ]
            ]
        , hr [] []
        , div
            []
            [ Markdown.toHtml [] markdown_text ]
        , hr [] []
        , div []
            [ text "Tap your name: "
            , input [ onInput First ] []
            , br [] []
            ]
        , div []
            [ text "Hello "
            , text model.first_name
            ]
        ]



-- init


main =
    Html.beginnerProgram
        { model = model
        , update = update
        , view = view
        }
