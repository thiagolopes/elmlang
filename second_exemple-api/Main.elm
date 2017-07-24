module Main exposing (..)

import Html exposing (div, h1, br, li, ul, strong, form, input, button, textarea, text)
import Html.Attributes exposing (value)
import Html.Events exposing (onInput, onSubmit)


-- Model


type alias Comment =
    { author : String
    , content : String
    }


type alias Model =
    { comments : List Comment
    , form : Comment
    }


initialModel : Model
initialModel =
    --ou
    --Model [] { author = "", content = "" }
    --ou
    --{ comments = []
    --, form = { author = "", content = "" }
    --}
    Model [] (Comment "" "")



-- Update


type Msg
    = PostComment
    | UpdateComment String
    | UpdateAuthor String


update : Msg -> Model -> Model
update msg model =
    case msg of
        PostComment ->
            { model
                | comments = List.append model.comments [ model.form ]
                , form = Comment "" ""
            }

        UpdateAuthor value ->
            { model
                | form =
                    Comment value model.form.content
            }

        UpdateComment value ->
            { model
                | form =
                    Comment model.form.author value
            }



-- View


pluralize : String -> Int -> String
pluralize name count =
    if count == 1 then
        name
    else
        name ++ "s"


viewComment : Comment -> Html.Html Msg
viewComment comment =
    li []
        [ strong [] [ text comment.author ]
        , br [] []
        , text comment.content
        ]


view : Model -> Html.Html Msg
view model =
    let
        count =
            List.length model.comments

        title =
            (toString count) ++ (pluralize " Comentário" count)
    in
        div []
            [ h1 [] [ text title ]
            , ul [] (List.map viewComment model.comments)
            , form [ onSubmit PostComment ]
                [ text "Nome: "
                , br [] []
                , input [ onInput UpdateAuthor, value model.form.author ] []
                , br [] []
                , text "Comentario: "
                , br [] []
                , textarea [ onInput UpdateComment, value model.form.content ] []
                , br [] []
                , button [] [ text "Enviar" ]
                ]
            , br [] []
            , strong [] [ text "Status " ]
            , text "do modelo: "
            , br [] []
            , model |> toString |> text
            ]



-- Init
--main =
--initialModel |> toString |> text


main =
    Html.beginnerProgram
        { model = initialModel
        , update = update
        , view = view
        }
