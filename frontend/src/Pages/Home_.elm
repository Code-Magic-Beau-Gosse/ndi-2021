module Pages.Home_ exposing (Model, Msg, page)

import Data exposing (Data(..), toElem, toString)
import Debug exposing (toString)
import Dict exposing (Dict)
import Element exposing (..)
import Element.Font as Font
import Element.Input as Input
import Gen.Params.Home_ exposing (Params)
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
    { request : String
    , result : String
    }


init : Model
init =
    { request = ""
    , result = ""
    }



-- UPDATE


type Msg
    = SearchReq String


update : Msg -> Model -> Model
update msg model =
    case msg of
        SearchReq request ->
            { model | request = request }



-- VIEW


dataTest : List Data
dataTest =
    [ LifeGuard
        { id = 0
        , firstName = "Emile"
        , lastName = "Rolley"
        , age = 21
        , bio = "Doing NDI..."
        }
    , LifeGuard
        { id = 1
        , firstName = "Gilles"
        , lastName = "Gilles"
        , age = 20
        , bio = "Doing NDI... too"
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
        column [ centerX, height fill ]
            [ el
                [ Font.size 100
                , Font.family
                    [ Font.typeface "Helvetica", Font.sansSerif ]
                ]
                (text "D1kerque Gang")
            , el [ centerX, centerY ]
                (Input.search
                    []
                    { onChange = SearchReq
                    , text = model.request
                    , placeholder = Just (Input.placeholder [] (text "Georges..."))
                    , label = Input.labelLeft [] (text "")
                    }
                )
            , column
                [ centerX, centerY ]
                (List.foldl
                    (\e acc -> Data.toElem e :: acc)
                    []
                    dataTest
                )
            ]
    }
