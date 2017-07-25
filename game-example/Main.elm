module Main exposing (..)

import Html exposing (hr, text, br, textarea, div, p)
import Html.Events exposing (onInput)
import Html.Attributes as Attr exposing (style)
import Bass exposing (style, center, h1, italic, col_6, fit, h6, m4, h2, bold)
import String exposing (startsWith, isEmpty)


lorem =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent sollicitudin nibh quis arcu eleifend dapibus. Nullam ultricies posuere quam quis faucibus. Quisque pharetra sagittis urna, sit amet euismod erat rhoncus ut. Cras nec metus facilisis, mattis augue lobortis, ultrices libero. Mauris ultricies dolor arcu, in malesuada velit placerat non. Vivamus vehicula lobortis mi, ac dignissim ipsum commodo tincidunt. Fusce vel fermentum turpis. Etiam tristique, nibh id venenatis vulputate, turpis lorem blandit dui, sit amet mollis neque odio ac nisl. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Mauris et porttitor eros. Fusce enim quam, rhoncus in metus sit amet, euismod mollis orci. Fusce quis lacus dui. Phasellus malesuada aliquam lorem, non sollicitudin elit pharetra semper. "


type alias Model =
    { tapping : String
    , same : Bool
    , tappingNumber : Int
    , rate : Float
    }


model : Model
model =
    Model "" False 0 0


type Msg
    = Change String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change value ->
            if isEmpty value then
                { model | tappingNumber = 0, same = False, tapping = "" }
            else
                let
                    newModel =
                        { model
                            | tapping = value
                            , tappingNumber = model.tappingNumber + 1
                        }
                in
                    if startsWith value lorem then
                        { newModel | same = True }
                    else
                        { newModel | same = False }


mountScoreText : Model -> Html.Html Msg
mountScoreText model =
    if model.same then
        div
            [ Attr.style
                [ ( "color", "green" )
                ]
            ]
            [ text "GOOD" ]
    else if isEmpty model.tapping then
        div
            [ Bass.style [ bold ]
            ]
            [ text "START!" ]
    else
        div
            [ Attr.style
                [ ( "color", "red" )
                ]
            ]
            [ text "BAD" ]


view : Model -> Html.Html Msg
view model =
    div
        [ Bass.style
            [ center
            , h1
            , italic
            ]
        ]
        [ text "Lorem ipsum Game"
        , p [ Bass.style [ h2 ] ] [ text "Test your tapping" ]
        , p [ Bass.style [ h6, m4 ] ] [ text lorem ]
        , p [ Bass.style [ bold ] ] [ text model.tapping ]
        , div [ Bass.style [ center ] ]
            [ textarea
                [ Attr.style
                    [ ( "width", "50%" )
                    , ( "height", "10em" )
                    ]
                , onInput Change
                ]
                []
            ]
        , div [ Bass.style [ center, m4 ] ]
            [ text "Number: "
            , text <| toString <| model.tappingNumber
            , mountScoreText model
            ]
        ]


main =
    Html.beginnerProgram
        { view = view
        , model = model
        , update = update
        }
