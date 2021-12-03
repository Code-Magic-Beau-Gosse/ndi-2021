module Pages.Home_ exposing (Model, Msg, page)

import Data exposing (Data(..), LifeGuardInfo, toElem, toString)
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
    , result : List LifeGuardInfo
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
    | GotResult (Result Http.Error (List LifeGuardInfo))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SearchReq ->
            ( model, getData )

        UpdateReq request ->
            ( { model | request = request }, Cmd.none )

        GotResult result ->
            case result of
                Ok data ->
                    ( { model | result = data }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )


getData : Cmd Msg
getData =
    Http.get
        { url = "http://localhost:8080/search/lifeguards"
        , expect = Http.expectJson GotResult lifeGuardListDecoder
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



-- VIEW


dataTest : List Data
dataTest =
    [ LifeGuard
        { id = 0
        , firstName = "Emile"
        , lastName = "Rolley"
        , birth = "2021-02-03"
        , role = "Doing NDI..."
        , rescue = "rescue"
        }
    , LifeGuard
        { id = 1
        , firstName = "Gilles"
        , lastName = "Gilles"
        , birth = "2021-02-03"
        , role = "Doing NDI..."
        , rescue = "rescue"
        }
    , Boat
        { id = 2
        , name = "L'Hermione"
        , matricule = "0HASDF-ADF"
        , picture = "https://s1.qwant.com/thumbr/0x380/0/4/ebf6e0d454b4ba0ef53f84ca73f553128230f4964356e152058d2cf8ab184e/hermione_en_mer_op_9149_0.jpg?u=https%3A%2F%2Fminiweb.metropoletpm.fr%2Fsites%2Fnew.tpm-agglo.fr%2Ffiles%2Fhermione_en_mer_op_9149_0.jpg&q=0&b=1&p=0&a=0"
        }
    ]


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
            , el [ Font.bold ] (text ("Result: " ++ (String.concat <| List.map (\info -> Data.toString (LifeGuard info)) model.result)))
            , column
                [ centerX, centerY ]
                (List.foldl
                    (\e acc -> Data.toElem e :: acc)
                    []
                    dataTest
                )
            ]
    }
