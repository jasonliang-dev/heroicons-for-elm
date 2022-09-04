module Gallery exposing (Icon, XmlTree(..))

import Html exposing (Html)


type alias Icon a =
    { name : String
    , tags : List String
    , viewIcon : Html a
    , tree : XmlTree
    }


type XmlTree
    = XmlTree
        { tag : String
        , attributes : List ( String, String )
        , children : List XmlTree
        }
