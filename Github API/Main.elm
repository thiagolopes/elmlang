module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (src, href, style, class, placeholder)
import Html.Lazy exposing (lazy)
import Html.Events.Extra exposing (onEnter)
import Http
import Debug
import Json.Decode as Decode


-- BEGINER


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias User =
    { login : String
    , avatar_url : String
    , url : String
    , name : Maybe String
    , blog : Maybe String
    , location : Maybe String
    , bio : Maybe String
    }


type alias Model =
    { users : List User
    , nameInput : String
    , user : User
    }


type Msg
    = GetGithubUsers (Result Http.Error (List User))
    | GetGithubUser (Result Http.Error User)
    | FetchGithub (Cmd Msg)
    | ChangeNameUsers String



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchGithub cmd ->
            Debug.log "getUser"
                ( model, cmd )

        GetGithubUser result ->
            case result of
                Err httpErro ->
                    ( { model | user = User "" "" "" Nothing Nothing Nothing Nothing }, Cmd.none )

                Ok msg ->
                    ( { model | user = msg }, Cmd.none )

        GetGithubUsers result ->
            case result of
                Err httpError ->
                    Debug.log (toString httpError)
                        ( { model | users = [] }, Cmd.none )

                Ok msg ->
                    -- Debug.log ("deu certo" ++ toString msg)
                    ( { model | users = msg }, Cmd.none )

        ChangeNameUsers name ->
            let
                users =
                    if String.isEmpty name then
                        []
                    else
                        model.users
            in
                ( { model | nameInput = name, users = users }, Cmd.none )



-- INIT


init : ( Model, Cmd Msg )
init =
    ( Model []
        ""
        (User "" "" "" Nothing Nothing Nothing Nothing)
    , Cmd.none
    )



-- VIEW


view : Model -> Html Msg
view model =
    div [ mainStyle2 ]
        [ div [ mainStyle ]
            [ h1 [] [ text "Github API using Elm" ]
            , search model
            , br [] []
            , lazy generateListViewUsers model.users
            ]
        , div
            [ mainStyle ]
            [ h1 [] [ text "Detalhes" ]
            , lazy detailUser model.user
            ]
        ]


maybeString : Maybe String -> String
maybeString maybe =
    case maybe of
        Just msg ->
            msg

        Nothing ->
            "Empty"


detailUser : User -> Html Msg
detailUser user =
    div [ mainStyle ]
        [ img [ src user.avatar_url, imgStyle ] []
        , h3 [] [ text <| "Nome: " ++ user.login ]
        , p [] [ a [ href <| maybeString user.blog ] [ text <| "Blog: " ++ (maybeString user.blog) ] ]
        , p [] [ text <| "Localização: " ++ (maybeString user.location) ]
        , p [] [ text <| "Bio: " ++ (maybeString user.bio) ]
        ]


search : Model -> Html Msg
search model =
    section []
        [ input
            [ placeholder "type github user here"
            , onInput ChangeNameUsers
            , onEnter (FetchGithub (getGithubUsers model.nameInput))
            ]
            []
        , br [] []
        ]


generateListViewUsers : List User -> Html Msg
generateListViewUsers listUsers =
    List.map
        (\n ->
            li
                [ listStyle, onClick (FetchGithub (getGithubUser n.url)) ]
                [ img [ src n.avatar_url, imgStyle ] [], text n.login ]
        )
        listUsers
        |> ul []



-- FUNCTIONS


getGithubUsers : String -> Cmd Msg
getGithubUsers name =
    let
        url =
            ("https://api.github.com/search/users?q=" ++ name)

        request =
            Http.get url decodeGithubUsers
    in
        Http.send GetGithubUsers request


getGithubUser : String -> Cmd Msg
getGithubUser url =
    let
        request =
            Http.get url decodeGithubUser
    in
        Http.send GetGithubUser request


decodeGithubUser : Decode.Decoder User
decodeGithubUser =
    Decode.map7 User
        (Decode.field "login" Decode.string)
        (Decode.field "avatar_url" Decode.string)
        (Decode.field "url" Decode.string)
        (Decode.field "name" (Decode.maybe Decode.string))
        (Decode.field "blog" (Decode.maybe Decode.string))
        (Decode.field "location" (Decode.maybe Decode.string))
        (Decode.field "bio" (Decode.maybe Decode.string))


decodeGithubUsers : Decode.Decoder (List User)
decodeGithubUsers =
    Decode.at [ "items" ] <|
        Decode.list <|
            Decode.map7 User
                (Decode.field "login" Decode.string)
                (Decode.field "avatar_url" Decode.string)
                (Decode.field "url" Decode.string)
                (Decode.maybe Decode.string)
                (Decode.maybe Decode.string)
                (Decode.maybe Decode.string)
                (Decode.maybe Decode.string)



-- decodeListUser : Decode.Decoder (List User)
-- decodeListUser =
--     Decode.list decodeUser
-- decodeUser : Decode.Decoder User
-- decodeUser =
--     Decode.map2 User
--         (Decode.field "login" Decode.string)
--         (Decode.field "avatar_url" Decode.string)
-- STYLES


imgStyle : Attribute msg
imgStyle =
    style
        [ ( "height", "80px" )
        , ( "width", "80px" )
        , ( "margin", "5px" )
        ]


listStyle : Attribute msg
listStyle =
    style
        [ ( "listStyleType", "none" )
        , ( "display", "flex" )
        , ( "justifyContent", "flex-start" )
        , ( "alignItems", "center" )
        ]


mainStyle : Attribute msg
mainStyle =
    style
        [ ( "display", "flex" )
        , ( "flexDirection", "column" )
        , ( "alignItems", "center" )
        ]


mainStyle2 : Attribute msg
mainStyle2 =
    style
        [ ( "display", "flex" )
        , ( "justifyContent", "space-around" )
        ]
