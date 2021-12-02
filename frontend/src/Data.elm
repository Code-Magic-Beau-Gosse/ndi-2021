module Data exposing (Data(..), toElem, toString)

import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font


type Data
    = LifeGuard
        { id : Int
        , firstName : String
        , lastName : String
        , age : Int
        , bio : String
        }
    | Boat
        { id : Int
        , name : String
        , matricule : String
        , picture : String
        }


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
                ++ "\n, age: "
                ++ String.fromInt infos.age
                ++ "\n, bio: "
                ++ String.fromInt infos.age
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
                    , text (String.fromInt infos.age)
                    ]
                )

        Boat infos ->
            el []
                (column
                    [ width fill ]
                    [ text infos.name ]
                )
