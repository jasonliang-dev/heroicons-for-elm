-- elm-live src\Main.elm --start-page=dev.html -- --output=main.js --debug


port module Main exposing (main)

import Browser
import Browser.Events
import Gallery
import Gallery.Mini
import Gallery.Outline
import Gallery.Solid
import Html exposing (..)
import Html.Attributes as Attributes exposing (class)
import Html.Events as Events
import Html.Keyed as Keyed
import Json.Decode as Decode
import Svg
import Svg.Attributes



-- PORTS


port copy : String -> Cmd msg



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Imports =
    { svgAs : String
    , svgExposing : String
    , attrsAs : String
    , attrsExposing : String
    }


type IconKind
    = Outline
    | Solid
    | Mini


type alias Model =
    { search : String
    , iconKind : IconKind
    , imports : Imports
    , modal : Maybe (Gallery.Icon Msg)
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { search = ""
      , iconKind = Outline
      , imports =
            { svgAs = ""
            , svgExposing = ".."
            , attrsAs = ""
            , attrsExposing = ".."
            }
      , modal = Nothing
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = ChangeSearch String
    | ChangeIconKind IconKind
    | ChangeSvgAs String
    | ChangeSvgExposing String
    | ChangeAttributesAs String
    | ChangeAttributesExposing String
    | SelectIcon (Gallery.Icon Msg)
    | DeselectIcon
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeSearch str ->
            ( { model | search = str }, Cmd.none )

        ChangeIconKind kind ->
            ( { model | iconKind = kind }, Cmd.none )

        ChangeSvgAs str ->
            let
                old =
                    model.imports
            in
            ( { model | imports = { old | svgAs = str } }, Cmd.none )

        ChangeSvgExposing str ->
            let
                old =
                    model.imports
            in
            ( { model | imports = { old | svgExposing = str } }, Cmd.none )

        ChangeAttributesAs str ->
            let
                old =
                    model.imports
            in
            ( { model | imports = { old | attrsAs = str } }, Cmd.none )

        ChangeAttributesExposing str ->
            let
                old =
                    model.imports
            in
            ( { model | imports = { old | attrsExposing = str } }, Cmd.none )

        SelectIcon icon ->
            ( { model | modal = Just icon }, copy (treeToString model.imports icon.tree) )

        DeselectIcon ->
            ( { model | modal = Nothing }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        keyHandle key =
            case key of
                "Esc" ->
                    DeselectIcon

                "Escape" ->
                    DeselectIcon

                _ ->
                    NoOp
    in
    Sub.batch
        [ case model.modal of
            Just _ ->
                Browser.Events.onKeyDown
                    (Decode.map keyHandle (Decode.field "key" Decode.string))

            Nothing ->
                Sub.none
        ]



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ header [ class "bg-elm-blue text-white" ]
            [ nav [ class "py-4 px-4 container mx-auto flex justify-end gap-8 text-blue-100 border-b border-sky-600" ]
                [ a [ class "hover:text-white", Attributes.href "https://heroicons.com/" ] [ text "Heroicons" ]
                , a [ class "hover:text-white", Attributes.href "https://package.elm-lang.org/packages/jasonliang-dev/elm-heroicons/latest/" ] [ text "Elm Package" ]
                , a [ class "hover:text-white", Attributes.href "https://github.com/jasonliang-dev/heroicons-for-elm" ] [ text "GitHub" ]
                ]
            , div [ class "container mx-auto px-4 pt-16 pb-20" ]
                [ div [ class "flex flex-col items-center" ]
                    [ h1 [ class "text-5xl font-bold flex items-center" ]
                        [ text "Elm + Heroicons = "
                        , Svg.svg [ Svg.Attributes.class "w-16 h-16 pl-2", Svg.Attributes.viewBox "0 0 24 24", Svg.Attributes.fill "currentColor" ] [ Svg.path [ Svg.Attributes.d "M11.645 20.91l-.007-.003-.022-.012a15.247 15.247 0 01-.383-.218 25.18 25.18 0 01-4.244-3.17C4.688 15.36 2.25 12.174 2.25 8.25 2.25 5.322 4.714 3 7.688 3A5.5 5.5 0 0112 5.052 5.5 5.5 0 0116.313 3c2.973 0 5.437 2.322 5.437 5.25 0 3.925-2.438 7.111-4.739 9.256a25.175 25.175 0 01-4.244 3.17 15.247 15.247 0 01-.383.219l-.022.012-.007.004-.003.001a.752.752 0 01-.704 0l-.003-.001z" ] [] ]
                        ]
                    , p [ class "text-xl text-blue-200 font-semibold pr-2" ]
                        [ code [] [ text "elm/svg" ]
                        , text " icons for your Elm project"
                        ]
                    ]
                ]
            ]
        , div [ class "max-w-lg relative mx-auto mt-16" ]
            [ span [ class "absolute inset-y-0 left-0 flex items-center pl-3 text-gray-800" ]
                [ Svg.svg [ Svg.Attributes.class "absolute w-4 h-4", Svg.Attributes.viewBox "0 0 20 20", Svg.Attributes.fill "currentColor" ] [ Svg.path [ Svg.Attributes.fillRule "evenodd", Svg.Attributes.d "M9 3.5a5.5 5.5 0 100 11 5.5 5.5 0 000-11zM2 9a7 7 0 1112.452 4.391l3.328 3.329a.75.75 0 11-1.06 1.06l-3.329-3.328A7 7 0 012 9z", Svg.Attributes.clipRule "evenodd" ] [] ] ]
            , input [ Attributes.value model.search, Events.onInput ChangeSearch, class "placeholder:italic placeholder:text-slate-400 block bg-white w-full border border-slate-300 rounded-md py-3 pl-9 pr-3 shadow-sm focus:outline-none focus:border-sky-500 focus:ring-sky-500 focus:ring-1", Attributes.placeholder "Search..." ] []
            ]
        , div [ class "mt-10 container max-w-7xl mx-auto px-4 grid grid-cols-3 gap-x-8" ]
            [ viewkindButton
                { kind = Outline
                , short = "24x24, 1.5px stroke"
                , long = "Icons with an outlined appearance."
                , current = model.iconKind
                }
            , viewkindButton
                { kind = Solid
                , short = "24x24, Solid fill"
                , long = "Icons with a filled appearance."
                , current = model.iconKind
                }
            , viewkindButton
                { kind = Mini
                , short = "20x20, Solid fill"
                , long = "For small elements like buttons and forms."
                , current = model.iconKind
                }
            ]
        , if List.any (kindaMatch model.search) Gallery.Outline.model then
            div [ class "min-h-screen mt-10" ]
                [ Keyed.ul [ class "grid grid-cols-8 container max-w-7xl mx-auto px-4 gap-y-6 gap-x-8" ]
                    (List.map
                        (\icon ->
                            ( icon.name
                            , viewIcon
                                model.iconKind
                                (model.search
                                    |> String.toLower
                                    |> String.replace "-" " "
                                )
                                icon
                            )
                        )
                        (case model.iconKind of
                            Outline ->
                                Gallery.Outline.model

                            Solid ->
                                Gallery.Solid.model

                            Mini ->
                                Gallery.Mini.model
                        )
                    )
                ]

          else
            div [ class "min-h-screen mt-56 container max-w-7xl mx-auto px-4" ]
                [ div [ class "font-medium text-gray-500 text-center" ]
                    [ text "Sorry! I couldn't find anything for "
                    , span [ class "font-bold text-gray-900" ] [ text model.search ]
                    ]
                ]
        , footer [ class "text-right container mx-auto px-4 border-t border-gray-200 mt-28" ]
            [ div [ class "pt-12 pb-20 text-gray-700" ]
                [ text "Made with "
                , a [ Attributes.href "https://odin-lang.org/", class "text-sky-500 hover:text-sky-600 font-medium" ]
                    [ text "Odin" ]
                , text " and "
                , a [ Attributes.href "https://elm-lang.org/", class "text-sky-500 hover:text-sky-600 font-medium" ]
                    [ text "Elm" ]
                ]
            ]
        , case model.modal of
            Just icon ->
                viewModal model.imports icon

            Nothing ->
                text ""
        ]


viewkindButton : { kind : IconKind, short : String, long : String, current : IconKind } -> Html Msg
viewkindButton { kind, short, long, current } =
    let
        kindStr =
            case kind of
                Outline ->
                    "Outline"

                Solid ->
                    "Solid"

                Mini ->
                    "Mini"
    in
    button
        [ Attributes.classList
            [ ( "p-4 rounded-lg border transition-colors", True )
            , ( "border-gray-50 shadow", current == kind )
            , ( "border-transparent hover:border-gray-100 hover:bg-gray-50", current /= kind )
            ]
        , Events.onClick (ChangeIconKind kind)
        ]
        [ div [ class "text-left" ]
            [ span
                [ Attributes.classList
                    [ ( "font-medium mr-2", True )
                    , ( "text-sky-600", current == kind )
                    , ( "text-gray-800", current /= kind )
                    ]
                ]
                [ text kindStr ]
            , span [ class "text-gray-500 text-sm" ] [ text short ]
            , div [ class "text-gray-600" ] [ text long ]
            ]
        ]


viewIcon : IconKind -> String -> Gallery.Icon Msg -> Html Msg
viewIcon kind search icon =
    let
        dim =
            case kind of
                Outline ->
                    "w-6 h-6"

                Solid ->
                    "w-6 h-6"

                Mini ->
                    "w-5 h-5"
    in
    div [ Attributes.classList [ ( "text-center", True ), ( "hidden", not (kindaMatch search icon) ) ] ]
        [ button [ Attributes.id icon.name, Events.onClick (SelectIcon icon), class "w-full h-28 flex flex-col justify-center items-center bg-white hover:bg-sky-100 rounded-lg border border-gray-200 hover:border-sky-500 text-gray-600 hover:text-sky-700 focus:outline-none focus:border-sky-500 transition-colors" ]
            [ div [ class dim ] [ icon.viewIcon ] ]
        , label [ Attributes.for icon.name, Attributes.title icon.name, class "block mt-1 text-gray-500 truncate text-sm" ]
            [ text icon.name ]
        ]


viewModal : Imports -> Gallery.Icon msg -> Html Msg
viewModal imports icon =
    div [ class "relative z-10" ]
        [ div [ class "fixed inset-0 bg-gray-200 bg-opacity-75 transition-opacity" ] []
        , div [ class "fixed inset-0 z-10 overflow-y-auto" ]
            [ button [ Events.onClick DeselectIcon, class "absolute inset-0 w-full h-full opacity-0 cursor-default", Attributes.tabindex -1] []
            , div [ class "flex min-h-full items-end justify-center p-4 text-center sm:items-center sm:p-0" ]
                [ div [ class "relative transform overflow-hidden rounded-lg bg-white text-left shadow-xl transition-all sm:my-8 sm:w-full sm:max-w-lg md:max-w-3xl" ]
                    [ div [ class "bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4" ]
                        [ h3 [ class "text-lg font-medium text-gray-900" ]
                            [ text "Usage" ]
                        , p [ class "text-sm text-gray-500" ]
                            [ text "Copy this Elm code and paste it in your project:" ]
                        , div [ class "bg-slate-800 border border-slate-900 text-slate-50 p-4 rounded overflow-x-auto mt-3 text-sm" ]
                            [ pre [ class "mb-1" ]
                                [ span [ class "text-violet-400" ] [ text "import" ]
                                , text " Svg           "
                                , span [ class "text-violet-400" ] [ text " as " ]
                                , input [ Attributes.value imports.svgAs, Events.onInput ChangeSvgAs, class "mx-1 px-1 bg-slate-900 rounded outline-none w-40" ] []
                                , span [ class "text-violet-400" ] [ text " exposing " ]
                                , text "("
                                , input [ Attributes.value imports.svgExposing, Events.onInput ChangeSvgExposing, class "mx-1 px-1 bg-slate-900 rounded outline-none w-40" ] []
                                , text ")"
                                ]
                            , pre [ class "mb-1" ]
                                [ span [ class "text-violet-400" ] [ text "import" ]
                                , text " Svg.Attributes"
                                , span [ class "text-violet-400" ] [ text " as " ]
                                , input [ Attributes.value imports.attrsAs, Events.onInput ChangeAttributesAs, class "mx-1 px-1 bg-slate-900 rounded outline-none w-40" ] []
                                , span [ class "text-violet-400" ] [ text " exposing " ]
                                , text "("
                                , input [ Attributes.value imports.attrsExposing, Events.onInput ChangeAttributesExposing, class "mx-1 px-1 bg-slate-900 rounded outline-none w-40" ] []
                                , text ")"
                                ]
                            , pre [ class "mb-1" ]
                                [ span [ class "text-yellow-300" ] [ text "\nicon" ]
                                , span [ class "text-slate-400" ] [ text " : " ]
                                , span [ class "text-violet-400" ] [ text "Html" ]
                                , text " msg"
                                ]
                            , pre [ class "mb-1" ]
                                [ span [ class "text-yellow-300" ] [ text "icon" ]
                                , span [ class "text-slate-400" ] [ text " =" ]
                                ]
                            , pre [ class "mb-1" ] (text "    " :: viewTree imports icon.tree)
                            ]
                        ]
                    , div [ class "bg-gray-50 px-4 py-3 sm:flex sm:flex-row-reverse sm:px-6" ]
                        [ button [ Events.onClick DeselectIcon, class "mt-3 inline-flex w-full justify-center rounded-md border border-gray-300 bg-white px-4 py-2 text-base font-medium text-gray-700 shadow-sm hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-sky-500 focus:ring-offset-2 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm" ]
                            [ text "Close" ]
                        ]
                    ]
                ]
            ]
        ]


viewTree : Imports -> Gallery.XmlTree -> List (Html msg)
viewTree imports (Gallery.XmlTree tree) =
    let
        bracketify xs =
            case xs of
                [] ->
                    [ span [ class "text-slate-400" ] [ text " []" ] ]

                nonEmpty ->
                    List.concat
                        [ [ span [ class "text-slate-400" ] [ text " [ " ] ]
                        , List.intersperse (span [ class "text-slate-400" ] [ text ", " ])
                            (List.map (\x -> span [] x) xs)
                        , [ span [ class "text-slate-400" ] [ text " ]" ] ]
                        ]

        tag =
            if
                String.split "," imports.svgExposing
                    |> List.map String.trim
                    |> List.any (\ex -> ex == tree.tag || ex == "..")
            then
                [ text tree.tag ]

            else
                [ span [ class "text-sky-400" ]
                    [ text
                        (if imports.svgAs == "" then
                            "Svg."

                         else
                            imports.svgAs ++ "."
                        )
                    ]
                , text tree.tag
                ]

        attrs ( name, value ) =
            if
                String.split "," imports.attrsExposing
                    |> List.map String.trim
                    |> List.any (\ex -> ex == name || ex == "..")
            then
                [ span [] [ text name ]
                , span [ class "text-lime-300" ] [ text (" \"" ++ value ++ "\"") ]
                ]

            else
                [ span [ class "text-sky-400" ]
                    [ text
                        (if imports.attrsAs == "" then
                            "Svg.Attributes."

                         else
                            imports.attrsAs ++ "."
                        )
                    ]
                , span [] [ text name ]
                , span [ class "text-lime-300" ] [ text (" \"" ++ value ++ "\"") ]
                ]
    in
    List.concat
        [ tag
        , bracketify (List.map attrs tree.attributes)
        , bracketify (List.map (viewTree imports) tree.children)
        ]



-- UTILS


treeToString : Imports -> Gallery.XmlTree -> String
treeToString imports (Gallery.XmlTree tree) =
    let
        bracketify xs =
            case xs of
                [] ->
                    "[]"

                nonEmpty ->
                    "[ " ++ String.join ", " nonEmpty ++ " ]"

        tag =
            if
                String.split "," imports.svgExposing
                    |> List.map String.trim
                    |> List.any (\ex -> ex == tree.tag || ex == "..")
            then
                tree.tag

            else
                (if imports.svgAs == "" then
                    "Svg."

                 else
                    imports.svgAs ++ "."
                )
                    ++ tree.tag

        attr ( name, value ) =
            if
                String.split "," imports.attrsExposing
                    |> List.map String.trim
                    |> List.any (\ex -> ex == name || ex == "..")
            then
                name ++ " \"" ++ value ++ "\""

            else
                (if imports.attrsAs == "" then
                    "Svg.Attributes." ++ name

                 else
                    imports.attrsAs ++ "." ++ name
                )
                    ++ " \""
                    ++ value
                    ++ "\""
    in
    tag
        ++ " "
        ++ bracketify (List.map attr tree.attributes)
        ++ " "
        ++ bracketify (List.map (treeToString imports) tree.children)


kindaMatch : String -> Gallery.Icon msg -> Bool
kindaMatch search icon =
    (icon.name :: icon.tags)
        |> List.map (String.replace "-" " ")
        |> List.any (String.contains search)