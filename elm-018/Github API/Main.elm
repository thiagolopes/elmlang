module Main exposing (..)

import Model exposing (..)
import Update exposing (..)
import Utils exposing (..)
import View exposing (..)
import Html exposing (Html)

init : ( Model, Cmd Msg )
init =
    ( Model []
        ""
        (User "" "" "" Nothing Nothing Nothing Nothing)
    , Cmd.none
    )

main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
