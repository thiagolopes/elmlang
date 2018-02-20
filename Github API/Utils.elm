module Utils exposing (..)
import Html.Attributes exposing (src, href, style, class, placeholder)
import Html exposing (..)
import Http



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


maybeString : Maybe String -> String
maybeString maybe =
    case maybe of
        Just msg ->
            msg

        Nothing ->
            "Empty"
