module Main exposing (main)

import Browser
import Debug
import Html exposing (Html, a, button, div, li, text, ul)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)
import Http
import Json.Decode as D
import Url exposing (fromString)


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


type alias NewsItem =
    { id : Int
    , title : String
    , points : Maybe Int
    , user : Maybe String
    , time_ago : String
    , type_ : String
    , url : String
    , domain : String
    }


type Model
    = FailureGetNews Http.Error
    | LoadingNews
    | SuccessNews (List NewsItem)


init : () -> ( Model, Cmd Msg )
init _ =
    ( LoadingNews, getNews )



-- update


type Msg
    = Refresh
    | GetNews (Result Http.Error (List NewsItem))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Refresh ->
            ( LoadingNews, getNews )

        GetNews result ->
            case result of
                Ok items ->
                    ( SuccessNews items, Cmd.none )

                Err err ->
                    Debug.log "ok"
                        ( FailureGetNews err, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    case model of
        FailureGetNews err ->
            div []
                [ button [ onClick Refresh ] [ text "Try Again!" ] ]

        LoadingNews ->
            text "Loading..."

        SuccessNews items ->
            listItems items


listItems : List NewsItem -> Html Msg
listItems items =
    div [] <| itemListItems items


itemListItems : List NewsItem -> List (Html Msg)
itemListItems items =
    List.map
        (\item ->
            ul []
                [ li
                    []
                    [ a [ href item.url ]
                        [ text <| item.title ]
                    , text
                        (getHost item)
                    ]
                ]
        )
        items


getHost : NewsItem -> String
getHost newsitem =
    let
        url =
            fromString newsitem.url
    in
    case url of
        Just url_success ->
            " (" ++ url_success.host ++ ") "

        Nothing ->
            ""


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


newsDecoder : D.Decoder (List NewsItem)
newsDecoder =
    D.list
        (D.map8
            NewsItem
            (D.field "id" D.int)
            (D.field "title" D.string)
            (D.field "points" (D.nullable D.int))
            (D.field "user" (D.nullable D.string))
            (D.field "time_ago" D.string)
            (D.field "type" D.string)
            (D.field "url" D.string)
            (D.field "domain" D.string)
        )
