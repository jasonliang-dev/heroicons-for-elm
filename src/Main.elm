port module Main exposing (..)

import Browser
import Browser.Events as Events
import Gallery
import Gallery.Outline
import Gallery.Solid
import Heroicons.Outline
import Heroicons.Solid
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Keyed as Keyed
import Html.Lazy exposing (lazy)
import Json.Decode as Decode



---- PORTS ----


port iconCodeChange : () -> Cmd msg


port copy : String -> Cmd msg


port makeTippy : String -> Cmd msg


port setTippyContent : String -> Cmd msg


port freeTippy : () -> Cmd msg



---- MODEL ----


type alias ImportStyle =
    { withAs : String
    , withExposing : String
    , onAs : String -> Msg
    , onExposing : String -> Msg
    }


type alias Model =
    { modalFor : Maybe (Gallery.Icon Msg)
    , search : String
    , svgImportStyle : ImportStyle
    , svgAttrsImportStyle : ImportStyle
    }


init : ( Model, Cmd Msg )
init =
    ( { modalFor = Nothing
      , search = ""
      , svgImportStyle =
            { withAs = ""
            , withExposing = ".."
            , onAs = SetSvgAs
            , onExposing = SetSvgExposing
            }
      , svgAttrsImportStyle =
            { withAs = ""
            , withExposing = ".."
            , onAs = SetSvgAttrsAs
            , onExposing = SetSvgAttrsExposing
            }
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = SetModalFor (Maybe (Gallery.Icon Msg))
    | SetSearch String
    | SetSvgAs String
    | SetSvgExposing String
    | SetSvgAttrsAs String
    | SetSvgAttrsExposing String
    | CopyToClipboard String
    | IgnoreKeyboard
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetModalFor maybeIcon ->
            ( { model | modalFor = maybeIcon }
            , case maybeIcon of
                Just _ ->
                    Cmd.batch
                        [ iconCodeChange ()
                        , makeTippy "Copy SVG"
                        ]

                Nothing ->
                    freeTippy ()
            )

        SetSearch str ->
            ( { model | search = str }, Cmd.none )

        SetSvgAs str ->
            let
                old =
                    model.svgImportStyle
            in
            ( { model | svgImportStyle = { old | withAs = str } }
            , Cmd.none
            )

        SetSvgExposing str ->
            let
                old =
                    model.svgImportStyle
            in
            ( { model | svgImportStyle = { old | withExposing = str } }
            , Cmd.none
            )

        SetSvgAttrsAs str ->
            let
                old =
                    model.svgAttrsImportStyle
            in
            ( { model | svgAttrsImportStyle = { old | withAs = str } }
            , Cmd.none
            )

        SetSvgAttrsExposing str ->
            let
                old =
                    model.svgAttrsImportStyle
            in
            ( { model | svgAttrsImportStyle = { old | withExposing = str } }
            , Cmd.none
            )

        CopyToClipboard str ->
            ( model, Cmd.batch [ copy str, setTippyContent "Copied!" ] )

        IgnoreKeyboard ->
            ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ header [ class "bg-elm-blue text-white" ]
            [ div [ class "container mx-auto px-8" ]
                [ div [ class "border-b border-blue-600 flex items-center py-4" ]
                    [ span [ class "font-bold text-2xl mr-auto" ] [ text "Heroicons For Elm" ]
                    , viewNav
                    ]
                ]
            , div [ class "text-center pt-12 pb-20" ]
                [ h1 [ class "text-4xl font-bold inline-flex items-center" ]
                    [ text "Elm + Heroicons ="
                    , span
                        [ class "inline-block ml-3 w-12 h-12"
                        , attribute "aria-label" "Love"
                        ]
                        [ Heroicons.Solid.heart [] ]
                    ]
                , p [ class "text-3xl font-bold text-blue-200" ]
                    [ text "Easy and ready to use svg icons for Elm." ]
                ]
            ]
        , main_ [ class "container px-8 pb-20 mx-auto" ]
            [ div [ class "flex justify-center my-12" ]
                [ label [ class "w-full max-w-xl flex items-center rounded-lg px-4 bg-gray-200 focus-within:shadow-outline focus-within:bg-white transition duration-150" ]
                    [ span [ class "inline-block w-6 h-6 mr-2 text-gray-600" ]
                        [ Heroicons.Outline.search [] ]
                    , input
                        [ class "w-full py-4 bg-gray-200 text-gray-700 placeholder-gray-700 focus:bg-white focus:outline-none transition duration-150"
                        , placeholder "Search all icons"
                        , onInput SetSearch
                        , value model.search
                        ]
                        []
                    ]
                ]
            , if
                List.map (\icon -> icon.name :: icon.tags) Gallery.Outline.model
                    |> List.any (List.any (String.contains model.search))
              then
                div
                    [ class "grid grid-flow-col grid-rows-2 grid-cols-2 gap-x-16 gap-y-8 items-start"
                    , style "grid-template-rows" "auto auto"
                    ]
                    [ viewIcons
                        { heading = "Medium"
                        , subHeader = "2px stroke weight, 24x24 bounding box"
                        , lead = "For primary navigation and marketing sections, designed to be rendered at 24x24."
                        , size = "24px"
                        , search = model.search
                        , icons = Gallery.Outline.model
                        }
                    , viewIcons
                        { heading = "Small"
                        , subHeader = "Solid fill, 20x20 bounding box"
                        , lead = "For buttons, form elements, and to support text, designed to be rendered at 20x20."
                        , size = "20px"
                        , search = model.search
                        , icons = Gallery.Solid.model
                        }
                    ]

              else
                div [ class "text-center py-24" ]
                    [ h2 [ class "text-gray-900 text-2xl font-bold mb-1" ]
                        [ text
                            ("Sorry! I could"
                                ++ String.fromChar (Char.fromCode 39)
                                ++ "t find anything for "
                                ++ String.fromChar (Char.fromCode 8220)
                                ++ model.search
                                ++ String.fromChar (Char.fromCode 8221)
                                ++ "."
                            )
                        ]
                    , p [ class "text-lg text-gray-600" ]
                        [ text "Is there an icon missing? Let me know by "
                        , a [ class "text-elm-blue hover:underline", href "#" ]
                            [ text "opening an issue on GitHub" ]
                        , text "."
                        ]
                    ]
            ]
        , footer [ class "bg-gray-100 text-gray-600 flex border-t border-gray-300 py-12" ]
            [ div [ class "container px-8 mx-auto" ]
                [ a
                    [ class "hover:underline hover:text-gray-700"
                    , href "#"
                    ]
                    [ text "Page Source" ]
                ]
            ]
        , case model.modalFor of
            Just icon ->
                viewModal model.svgImportStyle model.svgAttrsImportStyle icon

            Nothing ->
                text ""
        ]


viewNav : Html msg
viewNav =
    let
        navLinks =
            [ { href = "https://heroicons.com/"
              , view = [ text "Original Heroicons" ]
              }
            , { href = "https://package.elm-lang.org/packages/jasonliang512/elm-heroicons/latest/"
              , view = [ code [ class "text-sm" ] [ text "elm-herocions" ], text " Package" ]
              }
            , { href = "#"
              , view = [ text "GitHub" ]
              }
            ]
    in
    nav []
        [ Keyed.ul [ class "flex justify-end space-x-8" ]
            (List.map
                (\link ->
                    ( link.href
                    , li []
                        [ a
                            [ class "text-blue-200 hover:text-white transition duration-150"
                            , href link.href
                            ]
                            link.view
                        ]
                    )
                )
                navLinks
            )
        ]


viewIcons :
    { heading : String
    , subHeader : String
    , lead : String
    , size : String
    , search : String
    , icons : List (Gallery.Icon Msg)
    }
    -> Html Msg
viewIcons { heading, subHeader, lead, size, search, icons } =
    let
        viewIconKeyed icon =
            ( icon.name, lazy (viewIcon size search) icon )
    in
    section [ class "contents" ]
        [ header [ class "flex flex-wrap items-baseline" ]
            [ h2 [ class "font-medium text-gray-900 flex-none text-lg mr-3" ] [ text heading ]
            , p [ class "font-medium text-gray-500 text-sm mb-2" ] [ text subHeader ]
            , p [ class "text-gray-600 text-sm" ] [ text lead ]
            ]
        , Keyed.ul
            [ class "w-full grid grid-cols-3 gap-8" ]
            (List.map viewIconKeyed icons)
        ]


viewIcon : String -> String -> Gallery.Icon Msg -> Html Msg
viewIcon size search icon =
    li
        (class "flex flex-col items-center space-y-3 mb-1"
            :: (if List.any (String.contains search) (icon.name :: icon.tags) then
                    []

                else
                    [ class "hidden" ]
               )
        )
        [ button
            [ class "w-full h-24 flex items-center justify-center rounded-md border-2 border-gray-200 text-gray-600 hover:text-elm-blue hover:border-elm-blue hover:bg-blue-100 focus:shadow-outline focus:outline-none transition duration-150"
            , onClick (SetModalFor (Just icon))
            , type_ "button"
            ]
            [ span
                [ class "inline-block w-8 h-8"
                , style "width" size
                , style "height" size
                ]
                [ icon.viewIcon [] ]
            ]
        , span [ class "text-gray-600 text-sm" ] [ text icon.name ]
        ]


viewModal : ImportStyle -> ImportStyle -> Gallery.Icon Msg -> Html Msg
viewModal svgImportStyle svgAttrsImportStyle icon =
    div [ class "fixed z-10 inset-0 overflow-y-auto" ]
        [ div [ class "flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0" ]
            [ div [ class "fixed inset-0 transition-opacity" ]
                [ button
                    [ class "absolute inset-0 w-screen h-screen bg-gray-400 opacity-75 cursor-default"
                    , type_ "button"
                    , tabindex -1
                    , onClick (SetModalFor Nothing)
                    ]
                    []
                ]
            , span [ class "hidden sm:inline-block sm:align-middle sm:h-screen" ] []
            , div
                [ attribute "aria-labelledby" "modal-headline"
                , attribute "aria-modal" "true"
                , attribute "role" "dialog"
                , class "relative inline-block align-bottom bg-white rounded-lg text-left shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-2xl sm:w-full"
                ]
                [ button
                    [ class "absolute right-0 top-0 -mt-3 -mr-3 w-8 h-8 flex items-center justify-center shadow hover:shadow-md rounded-full bg-white text-red-500 hover:text-red-700 focus:outline-none focus:shadow-outline transition duration-150"
                    , type_ "button"
                    , onClick (SetModalFor Nothing)
                    ]
                    [ span [ class "inline-block w-5 h-5" ] [ Heroicons.Solid.x [] ] ]
                , div [ class "bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4 rounded-t-lg" ]
                    [ h3
                        [ class "text-lg leading-6 font-medium text-gray-900 mb-2"
                        , id "modal-headline"
                        ]
                        [ text "Icon usage" ]
                    , div [ class "mb-4" ]
                        [ p [ class "leading-tight text-sm text-gray-600" ]
                            [ text "Copy this Elm code and paste it in your project:" ]
                        ]
                    , div [ class "relative mb-6" ]
                        [ button
                            [ class "absolute right-0 bottom-0 rounded-full bg-elm-blue text-white flex items-center justify-center w-8 h-8 -mb-2 -mr-4 shadow hover:shadow-lg focus:outline-none focus:shadow-outline transition duration-150"
                            , type_ "button"
                            , attribute "aria-label" "Copy elm code"
                            , attribute "data-tippy" ""
                            , onClick
                                (CopyToClipboard
                                    (treeToString svgImportStyle
                                        svgAttrsImportStyle
                                        icon.tree
                                    )
                                )
                            ]
                            [ span
                                [ class "inline-block"
                                , style "width" "20px"
                                , style "height" "20px"
                                ]
                                [ Heroicons.Solid.clipboard [] ]
                            ]
                        , pre [ class "overflow-x-auto text-xs font-bold rounded-md p-4 bg-gray-800 text-gray-200" ]
                            [ code [ class "language-elm" ]
                                [ text (importStyleToString "Svg" svgImportStyle ++ "\n")
                                , text (importStyleToString "Svg.Attributes" svgAttrsImportStyle ++ "\n\n")
                                , text "view : Html msg\n"
                                , text
                                    ("view = \n    "
                                        ++ treeToString svgImportStyle
                                            svgAttrsImportStyle
                                            icon.tree
                                    )
                                ]
                            ]
                        ]
                    , h3 [ class "text-lg leading-6 font-medium text-gray-900 mb-3" ]
                        [ text "How are you importing "
                        , code [ class "text-sm code" ] [ text "elm/svg" ]
                        , text "?"
                        ]
                    , div [ class "space-y-1" ]
                        [ viewImportStyle "Svg           " svgImportStyle
                        , viewImportStyle "Svg.Attributes" svgAttrsImportStyle
                        ]
                    ]
                , div [ class "bg-gray-100 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse rounded-b-lg" ]
                    [ span [ class "mt-3 flex w-full rounded-md shadow-sm sm:mt-0 sm:w-auto" ]
                        [ button
                            [ class "inline-flex justify-center w-full rounded-md border border-gray-300 px-4 py-2 bg-white text-base leading-6 font-medium text-gray-700 shadow-sm hover:text-gray-500 focus:outline-none focus:border-blue-300 focus:shadow-outline-blue transition ease-in-out duration-150 sm:text-sm sm:leading-5"
                            , type_ "button"
                            , onClick (SetModalFor Nothing)
                            ]
                            [ text "Close" ]
                        ]
                    ]
                ]
            ]
        ]


viewImportStyle : String -> ImportStyle -> Html Msg
viewImportStyle moduleName { withAs, withExposing, onAs, onExposing } =
    div [ class "text-xs text-gray-600 flex space-x-2 w-100" ]
        [ label [ class "flex items-center flex-auto" ]
            [ code [ class "whitespace-pre mr-2" ]
                [ text ("import " ++ moduleName ++ " as") ]
            , input
                [ class "input-text"
                , type_ "text"
                , value withAs
                , onInput onAs
                ]
                []
            ]
        , label [ class "flex items-center flex-auto" ]
            [ code [ class "whitespace-pre mr-1" ] [ text "exposing (" ]
            , input
                [ class "input-text"
                , type_ "text"
                , value withExposing
                , onInput onExposing
                ]
                []
            , code [ class "ml-1" ] [ text ")" ]
            ]
        ]



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.modalFor of
        Just _ ->
            Events.onKeyDown keyHandle

        Nothing ->
            Sub.none


keyHandle : Decode.Decoder Msg
keyHandle =
    let
        toMsg key =
            case key of
                "Esc" ->
                    SetModalFor Nothing

                "Escape" ->
                    SetModalFor Nothing

                _ ->
                    IgnoreKeyboard
    in
    Decode.field "key" Decode.string
        |> Decode.map toMsg



---- UTILITY ----


importStyleToString : String -> ImportStyle -> String
importStyleToString moduleName { withAs, withExposing } =
    let
        optionalAs =
            case withAs of
                "" ->
                    ""

                nonEmpty ->
                    " as " ++ nonEmpty

        optionalExposing =
            case withExposing of
                "" ->
                    ""

                nonEmpty ->
                    " exposing (" ++ nonEmpty ++ ")"
    in
    "import " ++ moduleName ++ optionalAs ++ optionalExposing


treeToString : ImportStyle -> ImportStyle -> Gallery.XMLTree -> String
treeToString svgImportStyle svgAttrsImportStyle (Gallery.XMLTree tree) =
    let
        attributeToString ( name, value ) =
            name ++ " \"" ++ value ++ "\""

        bracketify xs =
            case xs of
                [] ->
                    "[]"

                nonEmpty ->
                    "[ " ++ String.join ", " nonEmpty ++ " ]"

        tag =
            if
                String.split "," svgImportStyle.withExposing
                    |> List.map String.trim
                    |> List.any (\ex -> ex == tree.tag || ex == "..")
            then
                tree.tag

            else
                (case svgImportStyle.withAs of
                    "" ->
                        "Svg."

                    nonEmpty ->
                        nonEmpty ++ "."
                )
                    ++ tree.tag

        attr ( name, value ) =
            if
                String.split "," svgAttrsImportStyle.withExposing
                    |> List.map String.trim
                    |> List.any (\ex -> ex == name || ex == "..")
            then
                ( name, value )

            else
                ( (case svgAttrsImportStyle.withAs of
                    "" ->
                        "Svg.Attributes."

                    nonEmpty ->
                        nonEmpty ++ "."
                  )
                    ++ name
                , value
                )
    in
    tag
        ++ " "
        ++ bracketify (List.map (attributeToString << attr) tree.attributes)
        ++ " "
        ++ bracketify
            (List.map
                (treeToString svgImportStyle svgAttrsImportStyle)
                tree.children
            )



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = subscriptions
        }
