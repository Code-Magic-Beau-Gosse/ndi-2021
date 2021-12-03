module View exposing (View, map, none, placeholder, toBrowserDocument)

import Browser
import Element exposing (Element)
import Element.Background as Background
import Element.Font as Font
import Palette exposing (..)


type alias View msg =
    { title : String
    , element : Element msg
    }


placeholder : String -> View msg
placeholder str =
    { title = str
    , element = Element.none
    }


none : View msg
none =
    placeholder ""


map : (a -> b) -> View a -> View b
map fn view =
    { title = view.title
    , element = Element.map fn view.element
    }


toBrowserDocument : View msg -> Browser.Document msg
toBrowserDocument view =
    { title = view.title
    , body = [ Element.layout [ Background.color Palette.prussianBlue, Font.color Palette.honeydew ] view.element ]
    }
