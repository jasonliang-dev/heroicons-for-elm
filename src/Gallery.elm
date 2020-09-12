module Gallery exposing (Icon, XMLTree(..))

import Html exposing (Html)
import Svg exposing (Attribute)


type alias Icon a =
    { name : String
    , tags : List String
    , viewIcon : List (Attribute a) -> Html a
    , tree : XMLTree
    }


type XMLTree
    = XMLTree
        { tag : String
        , attributes : List ( String, String )
        , children : List XMLTree
        }
