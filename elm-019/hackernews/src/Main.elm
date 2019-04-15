module Main exposing (main)

import Browser
import Debug
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, int, list, map8, string)
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


apiV1 : String
apiV1 =
    "https://api.hnpwa.com/v0/news/1.json"


type alias Item =
    { id : Int
    , title : String
    , points : Int
    , user : String
    , time_ago : String
    , type_ : String
    , url : String
    , domain : String
    }


type Model
    = Failure Http.Error
    | Loading
    | Success (List Item)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getNews )



-- update


type Msg
    = Refresh
    | GetNews (Result Http.Error (List Item))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Refresh ->
            ( Loading, getNews )

        GetNews result ->
            case result of
                Ok items ->
                    ( Success items, Cmd.none )

                Err err ->
                    ( Failure err, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        Failure err ->
            div []
                [ button [ onClick Refresh ] [ text "Try Again!" ] ]

        Loading ->
            text "Loading..."

        Success items ->
            listItems items


listItems : List Item -> Html Msg
listItems items =
    div [] <| itemListItems items


itemListItems : List Item -> List (Html Msg)
itemListItems items =
    List.map
        (\item ->
            ul []
                [ li [] [ text item.title ]
                , li [] [ text item.url ]
                ]
        )
        items


getNews : Cmd Msg
getNews =
    let
        url =
            apiV1
    in
    Http.get
        { url = url
        , expect = Http.expectJson GetNews newsDecoder
        }


newsDecoder : Decoder (List Item)
newsDecoder =
    list
        (map8
            Item
            (field "id" int)
            (field "title" string)
            (field "points" int)
            (field "user" string)
            (field "time_ago" string)
            (field "type" string)
            (field "url" string)
            (field "domain" string)
        )
