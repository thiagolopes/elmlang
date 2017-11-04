module UserInput exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main =
    Html.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- Model


type alias Model =
    { text : String }


model : Model
model =
    { text = "" }


type Msg
    = Text String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Text txt ->
            { model | text = txt }



-- Helper
--bigText : Attribute msg
--bigText =
--style
--[ ( "fontSize", "20em" )
--, ( "color", "sandybrown" )
--]
--smallText : Attribute msg
--smallText =
--style
--[ ( "fontSize", "10em" )
--, ( "color", "indianred" )
--]
--checkTextSize : String -> Attribute msg
--checkTextSize str =
--if String.length (str) > 8 then
--smallText
--else
--bigText


adjustSize : Model -> Attribute msg
adjustSize { text } =
    let
        ( size, color ) =
            if String.length text < 8 then
                ( "20em", "goldenrod" )
            else
                ( "10em", "seashell" )
    in
        style
            [ ( "fontSize", size )
            , ( "color", color )
            , ( "fontFamily", "verdana" )
            ]



-- View


view : Model -> Html Msg
view model =
    div []
        [ input [ placeholder "Type text here", onInput Text ] []
        , div
            [ adjustSize model ]
            [ text model.text ]
        ]
