module Data exposing (Data, toString)


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
                ++ "\n,firstName: "
                ++ infos.firstName
                ++ "\n,lastName: "
                ++ infos.lastName
                ++ "\n,age: "
                ++ String.fromInt infos.age
                ++ "\n,bio: "
                ++ String.fromInt infos.age
                ++ "\n}"

        Boat infos ->
            "LifeGuard {\n"
                ++ "id: "
                ++ String.fromInt infos.id
                ++ "\n,name: "
                ++ infos.name
                ++ "\n,matricule: "
                ++ infos.matricule
                ++ "\n,picture: "
                ++ infos.picture
                ++ "\n}"
