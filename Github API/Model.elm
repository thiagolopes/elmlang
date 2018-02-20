module Model exposing (..)
import Json.Decode as Decode

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
