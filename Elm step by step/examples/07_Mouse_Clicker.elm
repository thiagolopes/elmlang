module MouseClicker exposing (..)

import Char
import Html exposing (..)
import Keyboard
import Mouse


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- ALIAS


type alias Coordinates =
    { x : Int
    , y : Int
    }


type alias Model =
    { clicks : Mouse.Position
    , moves : Mouse.Position
    , keyPressed : Keyboard.KeyCode
    }



-- INIT


init : ( Model, Cmd msg )
init =
    ( Model
        (Mouse.Position 0 0)
        (Mouse.Position 0 0)
        0
    , Cmd.none
    )



-- MESSAGES


type Msg
    = MouseMessage Mouse.Position
    | MouseMoveMessage Mouse.Position
    | KeyboardMsg Keyboard.KeyCode



-- Updatates


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MouseMessage position ->
            ( { model
                | clicks = Mouse.Position position.x position.y
              }
            , Cmd.none
            )

        MouseMoveMessage position ->
            ( { model
                | moves = Mouse.Position position.x position.y
              }
            , Cmd.none
            )

        KeyboardMsg code ->
            ( { model | keyPressed = code }, Cmd.none )



-- Subscription


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Mouse.clicks MouseMessage
        , Mouse.moves MouseMoveMessage
        , Keyboard.presses KeyboardMsg
        ]



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ p []
            [ "Position Click X is:"
                ++ (toString model.clicks.x)
                ++ " and postion Y is: "
                ++ (toString model.clicks.y)
                |> text
            ]
        , p
            []
            [ "Position Move X is:"
                ++ (toString model.moves.x)
                ++ " and postion Y is: "
                ++ (toString model.moves.y)
                |> text
            ]
        , p []
            [ "You press this: "
                ++ (toString <| Char.fromCode model.keyPressed)
                |> text
            ]
        ]
