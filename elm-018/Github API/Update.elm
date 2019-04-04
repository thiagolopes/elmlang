module Update exposing (..)
import Model exposing (..)
import Http
import Debug


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
