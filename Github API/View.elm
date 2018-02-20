module View exposing (..)

import Model exposing (..)
import Utils exposing (..)
import Update exposing (..)
import Html exposing (..)
import Html.Attributes exposing (src, href, style, class, placeholder)
import Html.Events exposing (onClick, onInput)
import Html.Lazy exposing (lazy)
import Html.Events.Extra exposing (onEnter)

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
