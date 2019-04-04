module CoinFlip exposing (..)

import Html exposing (Html, program, div, text, button, img, Attribute, br)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import Random


main =
    program
        { init = init
        , subscriptions = subscriptions
        , view = view
        , update = update
        }



-- Model


type alias Model =
    { side : String
    , number : Int
    }


init : ( Model, Cmd Msg )
init =
    ( Model "Heads" 0, Cmd.none )



-- MESSAGES


type Msg
    = StartFlip
    | GenerateFlip Bool
    | GetNum
    | GenerateNum Int



-- UPDATES


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StartFlip ->
            ( model, Random.generate GenerateFlip (Random.bool) )

        GenerateFlip bool ->
            ( { model | side = generateSide bool }, Cmd.none )

        GetNum ->
            ( model, Random.generate GenerateNum (Random.int 1 100) )

        GenerateNum num ->
            ( { model | number = num }, Cmd.none )


generateSide : Bool -> String
generateSide bool =
    if bool then
        "Heads"
    else
        "Tails"



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


getImage : Model -> Attribute msg
getImage model =
    let
        imgURL =
            if model.side == "Heads" then
                "http://bjc.edc.org/June2017/bjc-r/img/5-algorithms/img_flipping-a-coin/Heads.png"
            else
                "https://images-na.ssl-images-amazon.com/images/I/51NyMaKLydL.jpg"
    in
        src imgURL


view : Model -> Html Msg
view model =
    div
        [ style
            [ ( "fontSize", "4em" )
            , ( "textAlign", "center" )
            ]
        ]
        [ img
            [ getImage model
            , style [ ( "height", "100px" ), ( "width", "100px" ) ]
            ]
            []
        , br [] []
        , text ("The result is : " ++ model.side)
        , div []
            [ button [ onClick StartFlip ] [ text "Flip" ] ]
        , div []
            [ text ("Random number is: " ++ toString model.number)
            , br [] []
            , button [ onClick GetNum ] [ text "Generate number" ]
            ]
        ]
