module Pages.Home_ exposing (Model, Msg, page)

import Data exposing (BoatInfo, Data(..), LifeGuardInfo, toElem, toString)
import Debug exposing (toString)
import Dict exposing (Dict)
import Element exposing (..)
import Element.Font as Font
import Element.Input as Input
import Gen.Params.Home_ exposing (Params)
import Http
import Json.Decode as Decode exposing (Decoder, at, field, float, int, string)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Page exposing (Page)
import Request exposing (Request)
import Result exposing (toMaybe)
import Shared
import View exposing (View)



-- JSON GET


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub msg
subscriptions model =
    Sub.none



-- INIT


type alias Model =
    { request : String
    , result : List Data
    }


init : ( Model, Cmd Msg )
init =
    ( { request = ""
      , result = []
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = SearchReq
    | UpdateReq String
    | GotLifeGuardInfos (Result Http.Error (List LifeGuardInfo))
    | GotBotInfoRes (Result Http.Error (List BoatInfo))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchReq ->
            ( model, getData )

        UpdateReq request ->
            ( { model | request = request }, Cmd.none )

        GotLifeGuardInfos result ->
            case result of
                Ok infos ->
                    ( { model | result = List.map (\info -> LifeGuard info) infos }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        GotBotInfoRes result ->
            case result of
                Ok infos ->
                    ( { model | result = List.map (\info -> Boat info) infos }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )


getData : Cmd Msg
getData =
    Http.get
        { url = "http://localhost:8080/search/lifeguards"
        , expect = Http.expectJson GotLifeGuardInfos lifeGuardListDecoder
        }


lifeGuardInfoDecode : Decoder LifeGuardInfo
lifeGuardInfoDecode =
    Decode.map6 LifeGuardInfo
        (at [ "id" ] int)
        (at [ "firstName" ] string)
        (at [ "lastName" ] string)
        (at [ "birth" ] string)
        (at [ "role" ] string)
        (at [ "rescue" ] string)


lifeGuardListDecoder : Decoder (List LifeGuardInfo)
lifeGuardListDecoder =
    Decode.list lifeGuardInfoDecode


boatDecode : Decoder BoatInfo
boatDecode =
    Decode.map4 BoatInfo
        (at [ "id" ] int)
        (at [ "name" ] string)
        (at [ "matricule" ] string)
        (at [ "picture" ] string)


boatListDecoder : Decoder (List BoatInfo)
boatListDecoder =
    Decode.list boatDecode



-- VIEW


view : Model -> View Msg
view model =
    { title = "Homepage"
    , element =
        column
            [ Font.family
                [ Font.typeface "opendyslexic"
                , Font.sansSerif
                ]
            , centerX
            , height fill
            ]
            [ el
                [ Font.size 100 ]
                (text "D1kerque Gang")
            , el [ centerX, centerY ]
                (Input.search
                    []
                    { onChange = UpdateReq
                    , text = model.request
                    , placeholder = Just (Input.placeholder [] (text "Georges..."))
                    , label = Input.labelLeft [] (text "")
                    }
                )
            , Input.button
                []
                { onPress = Just SearchReq, label = text "Search" }
            , el [ Font.bold ]
                (text
                    (if List.length model.result == 0 then
                        ""

                     else
                        "Result: "
                    )
                )
            , column
                [ centerX, centerY ]
                (List.map Data.toElem model.result)
            ]
    }
