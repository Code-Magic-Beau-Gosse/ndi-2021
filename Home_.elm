module Pages.Home_ exposing (Model, Msg, page)

import Browser.Dom exposing (Element)
import Debug exposing (toString)
import Dict exposing (Dict)
import Gen.Params.Sandbox exposing (Params)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Page exposing (Page)
import Request exposing (Request)
import Result exposing (toMaybe)
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.sandbox
        { init = init
        , update = update
        , view = view
        }



-- INIT


type alias Model =
    { name : String
    }


init : Model
init =
    { name = ""
    }



-- UPDATE


type Msg
    = Lifeguard String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Lifeguard name ->
            { model | name = name }



-- VIEW


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg, class "url-input" ] []


view : Model -> View Msg
view model =
    { title = "Homepage"
    , body =
        [ Html.div [ class "home-page" ]
            [ Html.div [ class "home-title-container" ] [ Html.h1 [ class "home-title" ] [ Html.text "ShortenIT" ] ]

            --, Html.div [ class "input-container" ] [ Html.input [ class "url-input", placeholder "Enter your url here.." ] [] ]
            , Html.div [ class "input-container" ] [ viewInput "text" "Enter your url here ..." model.name Lifeguard ]
            , Html.div [ class "result-container" ] [ Html.text model.name ]
            ]
        ]
    }
