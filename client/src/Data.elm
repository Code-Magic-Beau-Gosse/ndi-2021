module Data exposing (Data(..), LifeGuardInfo, BoatInfo, toElem, toString)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font


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
    , matricule : String
    , picture : String
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
                ++ "\n, matricule: "
                ++ infos.matricule
                ++ "\n, picture: "
                ++ infos.picture
                ++ "\n}"


toElem : Data -> Element msg
toElem data =
    case data of
        LifeGuard infos ->
            el []
                (column
                    []
                    [ row []
                        [ text infos.firstName
                        , text infos.lastName
                        ]
                    , text infos.birth
                    ]
                )

        Boat infos ->
            el []
                (column
                    [ width fill ]
                    [ text infos.name ]
                )
