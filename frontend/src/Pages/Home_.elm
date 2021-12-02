module Pages.Home_ exposing (Model, Msg, page)

import Debug exposing (toString)
import Dict exposing (Dict)
import Gen.Params.Home_ exposing (Params)
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
    { url : String
    , result : String
    , urls : Dict String String
    }


init : Model
init =
    { url = ""
    , result = ""
    , urls = Dict.empty
    }



-- UPDATE


type Msg
    = SearchReq String


update : Msg -> Model -> Model
update msg model =
    case msg of
        SearchReq url ->
            { model | url = url }



-- VIEW


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg, class "url-input" ] []


view : Model -> View Msg
view model =
    { title = "Homepage"
    , body =
        [ Html.div [ class "home-page" ]
            [ Html.div
                [ class "input-container" ]
                [ viewInput "text" "Search ..." model.url SearchReq ]
            ]
        ]
    }
