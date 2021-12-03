module Pages.Home_ exposing (Model, Msg, page)

import Data exposing (BoatInfo, Data(..), LifeGuardInfo, toElem, toString)
import Debug exposing (toString)
import Dict exposing (Dict)
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Gen.Params.Home_ exposing (Params)
import Http
import Json.Decode as Decode exposing (Decoder, at, field, float, int, string)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Page exposing (Page)
import Palette exposing (..)
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


type FilterType
    = LifeGuardFilter
    | BoatFilter


filterToString : FilterType -> String
filterToString filter =
    case filter of
        LifeGuardFilter ->
            "Life Guard"

        BoatFilter ->
            "Boat"


type alias Model =
    { request : String
    , result : Result String (List Data)
    , filter : FilterType
    }


init : ( Model, Cmd Msg )
init =
    ( { request = ""
      , result = Ok []
      , filter = LifeGuardFilter
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = SearchReq
    | UpdateReq String
    | GotLifeGuardInfos (Result Http.Error (List LifeGuardInfo))
    | GotBotInfoRes (Result Http.Error (List BoatInfo))
    | SwitchFilter


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchReq ->
            ( model, getData model )

        UpdateReq request ->
            ( { model | request = request }, Cmd.none )

        GotLifeGuardInfos result ->
            case result of
                Ok infos ->
                    ( { model | result = Ok <| List.map (\info -> LifeGuard info) infos }, Cmd.none )

                Err (Http.BadBody _) ->
                    ( { model | result = Err "Sorry, no corresponding match found..." }, Cmd.none )

                Err _ ->
                    ( { model | result = Err "Sorry, an error occured..." }, Cmd.none )

        GotBotInfoRes result ->
            case result of
                Ok infos ->
                    ( { model | result = Ok <| List.map (\info -> Boat info) infos }, Cmd.none )

                Err _ ->
                    ( { model | result = Err "" }, Cmd.none )

        SwitchFilter ->
            ( { model
                | filter =
                    case model.filter of
                        LifeGuardFilter ->
                            BoatFilter

                        BoatFilter ->
                            LifeGuardFilter
              }
            , Cmd.none
            )


getData : Model -> Cmd Msg
getData model =
    case model.filter of
        LifeGuardFilter ->
            Http.get
                { url = "http://localhost:8080/search/lifeguards/" ++ model.request
                , expect = Http.expectJson GotLifeGuardInfos lifeGuardListDecoder
                }

        BoatFilter ->
            Http.get
                { url = "http://localhost:8080/search/boats/" ++ model.request
                , expect = Http.expectJson GotBotInfoRes boatListDecoder
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
        (at [ "date" ] string)
        (at [ "rescue" ] string)


boatListDecoder : Decoder (List BoatInfo)
boatListDecoder =
    Decode.list boatDecode



-- VIEW


viewResult : Result String (List Data) -> List (Element msg)
viewResult result =
    case result of
        Ok res ->
            List.map Data.toElem res

        Err msg ->
            [ el [ Font.color Palette.imperialRed ] (text msg) ]


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
            , padding -10000
            ]
            [ el
                [ Font.size 100 ]
                (text "D1kerque Gang")
            , el [ centerX, centerY ]
                (Input.spellChecked
                    []
                    { onChange = UpdateReq
                    , text = model.request
                    , placeholder = Just (Input.placeholder [] (text "You should try 'Thomas'..."))
                    , label = Input.labelLeft [] (text "")
                    }
                )
            , Input.button
                []
                { onPress = Just SearchReq, label = text "Search" }
            , Input.button
                []
                { onPress = Just SwitchFilter, label = text <| filterToString model.filter }
            , column
                [ centerX, centerY ]
                (viewResult model.result)
            ]
    }
