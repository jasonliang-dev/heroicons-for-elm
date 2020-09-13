port module Main exposing (..)

import Animation
import Animation.Messenger
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
import Html.Lazy exposing (lazy, lazy3)
import Json.Decode as Decode
import SyntaxHighlight



---- PORTS ----


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
    , backdropStyle : Animation.Messenger.State Msg
    , modalStyle : Animation.Messenger.State Msg
    }


initAnimationStyle : { backdropStyle : List Animation.Property, modalStyle : List Animation.Property }
initAnimationStyle =
    { backdropStyle = [ Animation.opacity 0.0 ]
    , modalStyle = [ Animation.opacity 0.0, Animation.scale 1.05 ]
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
      , backdropStyle = Animation.style initAnimationStyle.backdropStyle
      , modalStyle = Animation.style initAnimationStyle.modalStyle
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = ShowModal (Gallery.Icon Msg)
    | HideModal
    | DestroyModal
    | SetSearch String
    | SetSvgAs String
    | SetSvgExposing String
    | SetSvgAttrsAs String
    | SetSvgAttrsExposing String
    | CopyToClipboard String
    | Animate Animation.Msg
    | IgnoreKeyboard
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        initialTippy =
            "Copy SVG"
    in
    case msg of
        ShowModal icon ->
            let
                openSpring =
                    Animation.spring { stiffness = 500, damping = 28 }
            in
            ( { model
                | modalFor = Just icon
                , backdropStyle =
                    Animation.interrupt
                        [ Animation.toWith
                            openSpring
                            [ Animation.opacity 1.0 ]
                        ]
                        model.backdropStyle
                , modalStyle =
                    Animation.interrupt
                        [ Animation.toWith
                            openSpring
                            [ Animation.opacity 1.0, Animation.scale 1.0 ]
                        ]
                        model.modalStyle
              }
            , makeTippy initialTippy
            )

        HideModal ->
            let
                closeSpring =
                    Animation.spring { stiffness = 600, damping = 30 }
            in
            ( { model
                | backdropStyle =
                    Animation.interrupt
                        [ Animation.toWith closeSpring initAnimationStyle.backdropStyle ]
                        model.backdropStyle
                , modalStyle =
                    Animation.interrupt
                        [ Animation.toWith closeSpring initAnimationStyle.modalStyle
                        , Animation.Messenger.send DestroyModal
                        ]
                        model.modalStyle
              }
            , Cmd.none
            )

        DestroyModal ->
            ( { model | modalFor = Nothing }, freeTippy () )

        SetSearch str ->
            ( { model | search = str }, Cmd.none )

        SetSvgAs str ->
            let
                old =
                    model.svgImportStyle
            in
            ( { model | svgImportStyle = { old | withAs = str } }
            , setTippyContent initialTippy
            )

        SetSvgExposing str ->
            let
                old =
                    model.svgImportStyle
            in
            ( { model | svgImportStyle = { old | withExposing = str } }
            , setTippyContent initialTippy
            )

        SetSvgAttrsAs str ->
            let
                old =
                    model.svgAttrsImportStyle
            in
            ( { model | svgAttrsImportStyle = { old | withAs = str } }
            , setTippyContent initialTippy
            )

        SetSvgAttrsExposing str ->
            let
                old =
                    model.svgAttrsImportStyle
            in
            ( { model | svgAttrsImportStyle = { old | withExposing = str } }
            , setTippyContent initialTippy
            )

        CopyToClipboard str ->
            ( model, Cmd.batch [ copy str, setTippyContent "Copied!" ] )

        Animate animMsg ->
            let
                ( backdropStyle, backdropCmd ) =
                    Animation.Messenger.update animMsg model.backdropStyle

                ( modalStyle, modalCmd ) =
                    Animation.Messenger.update animMsg model.modalStyle
            in
            ( { model | backdropStyle = backdropStyle, modalStyle = modalStyle }
            , Cmd.batch [ backdropCmd, modalCmd ]
            )

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
                    [ span [ class "font-bold text-2xl mr-auto" ] [ text "Heroicons for Elm" ]
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
                    [a
                        [ class "inline-flex rounded px-2 bg-blue-450 text-blue-100 hover:bg-blue-400 hover:text-white transition duration-150"
                        , href "https://package.elm-lang.org/packages/elm/svg/latest/"
                        ]
                        [ small [] [ code [] [ text "elm/svg" ] ] ]
                    , text " icons for your Elm project"
                    ]
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
                    [ class "grid grid-flow-col grid-rows-2 grid-cols-2 gap-x-16 gap-y-6 items-start"
                    , style "grid-template-rows" "auto auto"
                    ]
                    [ viewIcons
                        { heading = "Outline"
                        , subHeader = "Medium icons with 2px stroke and 24x24 bounding box."
                        , size = "24px"
                        , search = model.search
                        , icons = Gallery.Outline.model
                        }
                    , viewIcons
                        { heading = "Solid"
                        , subHeader = "Small icons with solid fill and 20x20 bounding box."
                        , size = "20px"
                        , search = model.search
                        , icons = Gallery.Solid.model
                        }
                    ]

              else
                div [ class "text-center py-24" ]
                    [ h2 [ class "text-gray-700 text-2xl font-bold mb-1" ]
                        [ text
                            "Sorry! I could't find anything for "
                        , span [ class "text-gray-900" ] [ text model.search ]
                        ]
                    , p [ class "text-lg text-gray-600" ]
                        [ text "Is there an icon missing? Let me know by "
                        , a
                            [ class "text-elm-blue hover:underline"
                            , href "https://github.com/jasonliang512/elm-heroicons-gallery/issues"
                            ]
                            [ text "opening an issue on GitHub" ]
                        , text "!"
                        ]
                    ]
            ]
        , footer [ class "bg-gray-100 text-gray-600 flex border-t border-gray-300 py-12" ]
            [ div [ class "flex space-x-8 container px-8 mx-auto" ]
                [ span []
                    [ a
                        [ class "hover:underline font-bold"
                        , href "https://github.com/tailwindlabs/heroicons"
                        ]
                        [ text "Heroicons" ]
                    , text " by "
                    , a
                        [ class "text-elm-blue hover:underline"
                        , href "https://twitter.com/steveschoger"
                        ]
                        [ text "Steve Schoger" ]
                    ]
                , span []
                    [ span [ class "font-bold" ] [ text "Heroicons for Elm" ]
                    , text " by "
                    , a
                        [ class "text-elm-blue hover:underline"
                        , href "https://github.com/jasonliang512"
                        ]
                        [ text "Jason Liang" ]
                    ]
                ]
            ]
        , case model.modalFor of
            Just icon ->
                viewModal model icon

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
              , view =
                    [ code [ class "text-sm" ] [ text "elm-herocions" ]
                    , text " Package"
                    ]
              }
            , { href = "https://github.com/jasonliang512/heroicons-for-elm"
              , view = [ text "GitHub" ]
              }
            ]

        viewLink link =
            li []
                [ a
                    [ class "group text-blue-200 hover:text-white transition duration-150"
                    , href link.href
                    ]
                    link.view
                ]
    in
    nav []
        [ Keyed.ul [ class "flex justify-end space-x-8" ]
            (List.map (\link -> ( link.href, viewLink link )) navLinks)
        ]


viewIcons :
    { heading : String
    , subHeader : String
    , size : String
    , search : String
    , icons : List (Gallery.Icon Msg)
    }
    -> Html Msg
viewIcons { heading, subHeader, size, search, icons } =
    let
        viewIconKeyed icon =
            ( icon.name, lazy (viewIcon size search) icon )
    in
    section [ class "contents" ]
        [ div []
            [ h2 [ class "font-medium text-gray-900 flex-none text-lg mr-3 mb-1" ] [ text heading ]
            , p [ class "font-medium text-gray-600 text-sm" ] [ text subHeader ]
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
            , onClick (ShowModal icon)
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


viewModal :
    { a
        | svgImportStyle : ImportStyle
        , svgAttrsImportStyle : ImportStyle
        , backdropStyle : Animation.Messenger.State Msg
        , modalStyle : Animation.Messenger.State Msg
    }
    -> Gallery.Icon Msg
    -> Html Msg
viewModal { svgImportStyle, svgAttrsImportStyle, backdropStyle, modalStyle } icon =
    div [ class "fixed z-10 inset-0 overflow-y-auto" ]
        [ div [ class "min-h-screen text-center p-0" ]
            [ div (class "fixed inset-0 transition-opacity" :: Animation.render backdropStyle)
                [ button
                    [ class "absolute inset-0 w-screen h-screen bg-gray-300 opacity-75 cursor-default"
                    , type_ "button"
                    , tabindex -1
                    , onClick HideModal
                    ]
                    []
                ]
            , span [ class "inline-block align-middle h-screen" ] []
            , div
                (Animation.render modalStyle
                    ++ [ attribute "aria-labelledby" "modal-headline"
                       , attribute "aria-modal" "true"
                       , attribute "role" "dialog"
                       , class "relative inline-block bg-white rounded-lg text-left shadow-xl transition-all my-8 align-middle max-w-2xl w-full"
                       ]
                )
                [ lazy3 viewModalContent svgImportStyle svgAttrsImportStyle icon ]
            ]
        ]


viewModalContent : ImportStyle -> ImportStyle -> Gallery.Icon Msg -> Html Msg
viewModalContent svgImportStyle svgAttrsImportStyle icon =
    div [ class "contents" ]
        [ button
            [ class "absolute right-0 top-0 -mt-3 -mr-3 w-8 h-8 flex items-center justify-center shadow hover:shadow-md rounded-full bg-white text-red-500 hover:text-red-700 focus:outline-none focus:shadow-outline transition duration-150"
            , type_ "button"
            , onClick HideModal
            ]
            [ span [ class "inline-block w-5 h-5" ] [ Heroicons.Solid.x [] ] ]
        , div [ class "bg-white p-6 pb-4 rounded-t-lg" ]
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
                , div [ class "elm-syntax-highlight-fix" ]
                    [ SyntaxHighlight.useTheme SyntaxHighlight.oneDark
                    , codeStateToString svgImportStyle svgAttrsImportStyle icon
                        |> SyntaxHighlight.elm
                        |> Result.map (SyntaxHighlight.toBlockHtml Nothing)
                        |> Result.withDefault
                            (pre []
                                [ code []
                                    [ text
                                        (codeStateToString
                                            svgImportStyle
                                            svgAttrsImportStyle
                                            icon
                                        )
                                    ]
                                ]
                            )
                    ]
                ]
            , h3 [ class "text-lg leading-6 font-medium text-gray-900 mb-3" ]
                [ text "How are you importing "
                , code [ class "text-sm bg-gray-200 text-gray-800 font-bold" ] [ text "elm/svg" ]
                , text "?"
                ]
            , div [ class "space-y-1" ]
                [ viewImportStyle "Svg           " svgImportStyle
                , viewImportStyle "Svg.Attributes" svgAttrsImportStyle
                ]
            ]
        , div [ class "bg-gray-100 px-6 py-3 flex flex-row-reverse rounded-b-lg" ]
            [ span [ class "flex rounded-md shadow-sm mt-0" ]
                [ button
                    [ class "inline-flex justify-center w-full rounded-md border border-gray-300 px-4 py-2 bg-white font-medium text-gray-700 shadow-sm hover:text-gray-500 focus:outline-none focus:border-blue-300 focus:shadow-outline-blue transition ease-in-out duration-150 text-sm leading-5"
                    , type_ "button"
                    , onClick HideModal
                    ]
                    [ text "Close" ]
                ]
            ]
        ]


viewImportStyle : String -> ImportStyle -> Html Msg
viewImportStyle moduleName { withAs, withExposing, onAs, onExposing } =
    let
        inputClassShared =
            "flex-auto w-0 min-w-0 rounded px-2 py-1 font-mono text-gray-600 focus:text-gray-800 bg-gray-200 border border-gray-200 focus:border-gray-400 transition duration-150 focus:outline-none"
    in
    div [ class "text-xs text-gray-600 flex space-x-2" ]
        [ label [ class "flex items-center flex-auto" ]
            [ code [ class "whitespace-pre mr-2" ]
                [ text ("import " ++ moduleName ++ " as") ]
            , input
                [ class inputClassShared
                , type_ "text"
                , value withAs
                , onInput onAs
                ]
                []
            ]
        , label [ class "flex items-center flex-auto" ]
            [ code [ class "whitespace-pre mr-1" ] [ text "exposing (" ]
            , input
                [ class inputClassShared
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
    Sub.batch
        [ case model.modalFor of
            Just _ ->
                Events.onKeyDown keyHandle

            Nothing ->
                Sub.none
        , Animation.subscription Animate
            [ model.backdropStyle
            , model.modalStyle
            ]
        ]


keyHandle : Decode.Decoder Msg
keyHandle =
    let
        toMsg key =
            case key of
                "Esc" ->
                    HideModal

                "Escape" ->
                    HideModal

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


codeStateToString : ImportStyle -> ImportStyle -> Gallery.Icon msg -> String
codeStateToString svgImportStyle svgAttrsImportStyle icon =
    importStyleToString "Svg" svgImportStyle
        ++ "\n"
        ++ importStyleToString "Svg.Attributes" svgAttrsImportStyle
        ++ "\n\nicon : Html msg\n"
        ++ "icon = \n    "
        ++ treeToString svgImportStyle
            svgAttrsImportStyle
            icon.tree



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = subscriptions
        }
