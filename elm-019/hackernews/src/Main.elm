module Main exposing (main)

import Browser
import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, float, int, list, map5, string)
import List
import String exposing (..)


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }



-- model


type alias Item =
    { by : String
    , id : Float
    , title : String
    , type_ : String
    , url : String
    }


type Model
    = Failure Http.Error
    | Loading
    | Success (List Int)
    | SuccessHome Item


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getHotPosts )



-- update


type Msg
    = Refresh
    | GotHotPosts (Result Http.Error (List Int))
    | GotPost (Result Http.Error Item)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Refresh ->
            ( Loading, getHotPosts )

        GotHotPosts result ->
            case result of
                Ok ids ->
                    ( Success ids, getFirstPost )

                Err err ->
                    ( Failure err, Cmd.none )

        GotPost home ->
            case home of
                Ok item ->
                    ( SuccessHome item, Cmd.none )

                Err err ->
                    ( Failure err, Cmd.none )



-- view
-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "HackerNews" ]
        , viewGif model
        ]


viewGif : Model -> Html Msg
viewGif model =
    case model of
        Failure err ->
            div []
                [ text <| Debug.toString err
                , button [ onClick Refresh ] [ text "Try Again!" ]
                ]

        Loading ->
            text "Loading..."

        Success url ->
            text "Loading..."

        SuccessHome item ->
            div [] [ divItem item ]


divItem : Item -> Html Msg
divItem item =
    div []
        [ ul []
            [ li [] [ text item.title ]
            , li [] [ a [ href item.url ] [ text item.url ] ]
            ]
        , br [] []
        ]


getHotPosts : Cmd Msg
getHotPosts =
    Http.get
        { url = "https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty"
        , expect = Http.expectJson GotHotPosts (list int)
        }


getFirstPost : Cmd Msg
getFirstPost =
    Http.get
        { url = "https://hacker-news.firebaseio.com/v0/item/19588996.json?print=pretty"
        , expect = Http.expectJson GotPost itemDecoder
        }


itemDecoder : Decoder Item
itemDecoder =
    map5
        Item
        (field "by" string)
        (field "id" float)
        (field "title" string)
        (field "type" string)
        (field "url" string)
