port module Storage exposing (..)

import Data exposing (..)
import Json.Decode as Decode exposing (Decoder, float, int, string)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Json.Encode as Encode


port save : Decode.Value -> Cmd msg


port load : (Decode.Value -> msg) -> Sub msg


type alias Storage =
    { request : Data }



-- Converting to JSON
-- TO DO


toJson : Storage -> Decode.Value
toJson storage =
    Encode.object [ ( "request", Encode.list storage.request ) ]



-- Converting from JSON


fromJson : Decode.Value -> Storage
fromJson value =
    value
        |> Decode.decodeValue decoder
        |> Result.withDefault initial


decoder : Decoder Storage
decoder =
    Json.map Storage
        (Decode.Decoder.field "counter" Json.int)


decodeLifeGuard : Decoder Data
decodeLifeGuard =
    Decode.succeed Data
        |> required "id" Decode.int
        |> required "firstName" Decode.string
        |> required "lastName" Decode.string
        |> required "age" Decode.int
        |> optional "bio" Decode.string


decodeBoat : Decoder Data
decodeBoat =
    Decode.succeed Data
        |> required "id" Decode.int
        |> required "name" Decode.string
        |> required "matricule" Decode.string
        |> required "picture" Decode.int


initial : Storage
initial =
    { counter = 0
    }


increment : Storage -> Cmd msg
increment storage =
    { storage | counter = storage.counter + 1 }
        |> toJson
        |> save


decrement : Storage -> Cmd msg
decrement storage =
    { storage | counter = storage.counter - 1 }
        |> toJson
        |> save
