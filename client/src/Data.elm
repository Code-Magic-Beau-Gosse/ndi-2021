module Data exposing (BoatInfo, Data(..), LifeGuardInfo, toElem, toString)

import Element exposing (..)
import Element.Background
import Element.Border as Border
import Palette


type alias LifeGuardInfo =
    { id : Int
    , firstName : String
    , lastName : String
    , birth : String
    , role : String
    , rescue : String
    }


type alias BoatInfo =
    { id : Int
    , name : String
    , date : String
    , rescue : String
    }


type Data
    = LifeGuard LifeGuardInfo
    | Boat BoatInfo


toString : Data -> String
toString data =
    case data of
        LifeGuard infos ->
            "LifeGuard {\n"
                ++ "id: "
                ++ String.fromInt infos.id
                ++ "\n, firstName: "
                ++ infos.firstName
                ++ "\n, lastName: "
                ++ infos.lastName
                ++ "\n, birth: "
                ++ infos.birth
                ++ "\n, role: "
                ++ infos.role
                ++ "\n, rescue: "
                ++ infos.rescue
                ++ "\n}"

        Boat infos ->
            "Boat {\n"
                ++ "id: "
                ++ String.fromInt infos.id
                ++ "\n, name: "
                ++ infos.name
                ++ "\n, date: "
                ++ infos.date
                ++ "\n, rescue: "
                ++ infos.rescue
                ++ "\n}"


toElem : Data -> Element msg
toElem data =
    case data of
        LifeGuard infos ->
            el []
                (column
                    [ Element.spacing 20, Element.padding 10, Border.rounded 4, Border.solid, Border.width 2 ]
                    [ row []
                        [ text infos.firstName
                        , text " "
                        , text infos.lastName
                        ]
                    , text infos.birth
                    , text infos.role
                    , text infos.rescue
                    ]
                )

        Boat infos ->
            el []
                (column
                    [ width fill ]
                    [ text infos.name ]
                )
