module LulaMain exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Mouse


main =
    Html.program
        { view = view
        , update = update
        , init = init
        , subscriptions = subscriptions
        }



-- ALIAS


type alias SetPosition =
    { x : Int
    , y : Int
    }


type alias Model =
    { mousePosition : Mouse.Position
    }



-- INIT


init : ( Model, Cmd Msg )
init =
    ( Model
        (Mouse.Position 0 0)
    , Cmd.none
    )



-- MSGS


type Msg
    = MouseMsg Mouse.Position
    | Rendering


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MouseMsg position ->
            ( { model
                | mousePosition =
                    { x = position.x, y = position.y }
              }
            , Cmd.none
            )

        Rendering ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Mouse.moves MouseMsg


styleMain : Attribute msg
styleMain =
    style
        [ ( "width", "100%" )
        , ( "height", "100%" )
        , ( "backgroundColor", "tomato" )
        , ( "cursor", "none" )
        ]


styleImage : Attribute msg
styleImage =
    style
        [ ( "position", "relative" )
        , ( "padding", "10px" )
        ]


setPositions : Int -> Int -> Attribute msg
setPositions x y =
    style
        [ ( "top", (y - 125 |> toString) ++ "px" )
        , ( "left", (x - 100 |> toString) ++ "px" )
        ]


view : Model -> Html Msg
view model =
    div [ styleMain ]
        [ img
            [ src "lula.png", styleImage, setPositions model.mousePosition.x model.mousePosition.y ]
            []
        ]
