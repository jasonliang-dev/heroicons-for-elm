-- elm-live src\Main.elm --start-page=dev.html -- --output=main.js --debug


module Main exposing (main)

import Browser
import Gallery
import Gallery.Mini
import Gallery.Outline
import Gallery.Solid
import Html exposing (..)
import Html.Attributes as Attributes exposing (class)
import Html.Events as Events
import Html.Keyed as Keyed
import Svg
import Svg.Attributes



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
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = ChangeSearch String
    | ChangeIconKind IconKind
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeSearch str ->
            ( { model | search = str }, Cmd.none )

        ChangeIconKind kind ->
            ( { model | iconKind = kind }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ header [ class "bg-elm-blue text-white mb-28" ]
            [ nav [ class "py-4 px-4 container mx-auto flex justify-end gap-8 text-blue-100 border-b border-sky-600" ]
                [ a [ class "hover:text-blue-50", Attributes.href "#" ] [ text "Heroicons" ]
                , a [ class "hover:text-blue-50", Attributes.href "#" ] [ text "Elm Package" ]
                , a [ class "hover:text-blue-50", Attributes.href "#" ] [ text "GitHub" ]
                ]
            , div [ class "grid grid-cols-12 container mx-auto px-4 pt-16 pb-20" ]
                [ div [ class "col-span-5" ]
                    [ h1 [ class "text-5xl font-bold flex items-center" ]
                        [ text "Elm + Heroicons = "
                        , Svg.svg [ Svg.Attributes.class "w-20 h-20 pl-2", Svg.Attributes.viewBox "0 0 20 20", Svg.Attributes.fill "currentColor" ] [ Svg.path [ Svg.Attributes.fillRule "evenodd", Svg.Attributes.d "M3.172 5.172a4 4 0 015.656 0L10 6.343l1.172-1.171a4 4 0 115.656 5.656L10 17.657l-6.828-6.829a4 4 0 010-5.656z", Svg.Attributes.clipRule "evenodd" ] [] ]
                        ]
                    , p [ class "text-xl text-blue-200 font-semibold" ] [ text "elm/svg icons for your Elm project" ]
                    ]
                , div [ class "col-span-7 relative" ]
                    [ div [ class "inset-x-0 absolute bg-slate-800 border border-slate-900 text-slate-200 rounded-lg shadow-lg" ]
                        [ div [ class "border-b border-slate-900 flex gap-2 py-3 px-4" ]
                            [ div [ class "rounded-full bg-slate-400 w-2 h-2" ] []
                            , div [ class "rounded-full bg-slate-400 w-2 h-2" ] []
                            , div [ class "rounded-full bg-slate-400 w-2 h-2" ] []
                            ]
                        , div [ class "px-6 py-4 overflow-x-auto leading-6" ]
                            [ pre [ class "mb-2" ]
                                [ text "import Svg            as "
                                , input [ class "mx-1 px-1 bg-slate-900 rounded outline-none w-40" ] []
                                , text " exposing ("
                                , input [ class "mx-1 px-1 bg-slate-900 rounded outline-none w-40" ] []
                                , text ")"
                                ]
                            , pre [ class "mb-2" ]
                                [ text "import Svg.Attributes as "
                                , input [ class "mx-1 px-1 bg-slate-900 rounded outline-none w-40" ] []
                                , text " exposing ("
                                , input [ class "mx-1 px-1 bg-slate-900 rounded outline-none w-40" ] []
                                , text ")"
                                ]
                            , pre []
                                [ text
                                    """
icon : Html msg
icon =
    svg [ viewBox "0 0 20 20", fill "currentColor" ] [ path [ d "M5 4a1 1 0 00-2 0v7.268a2 2 0 000 3.464V16a1 1 0 102 0v-1.268a2 2 0 000-3.464V4zM11 4a1 1 0 10-2 0v1.268a2 2 0 000 3.464V16a1 1 0 102 0V8.732a2 2 0 000-3.464V4zM16 3a1 1 0 011 1v7.268a2 2 0 010 3.464V16a1 1 0 11-2 0v-1.268a2 2 0 010-3.464V4a1 1 0 011-1z" ] [] ]
"""
                                ]
                            ]
                        ]
                    ]
                ]
            ]
        , div [ class "max-w-lg relative mx-auto" ]
            [ span [ class "absolute inset-y-0 left-0 flex items-center pl-3 text-gray-800" ]
                [ Svg.svg [ Svg.Attributes.class "absolute w-4 h-4", Svg.Attributes.viewBox "0 0 20 20", Svg.Attributes.fill "currentColor" ] [ Svg.path [ Svg.Attributes.fillRule "evenodd", Svg.Attributes.d "M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z", Svg.Attributes.clipRule "evenodd" ] [] ]
                ]
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
        ]


viewkindButton : { kind : IconKind, short : String, long : String, current : IconKind } -> Html Msg
viewkindButton { kind, short, long, current } =
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
                [ text (kindStr kind) ]
            , span [ class "text-gray-500 text-sm" ] [ text short ]
            , div [ class "text-gray-600" ] [ text long ]
            ]
        ]


viewIcon : IconKind -> String -> Gallery.Icon msg -> Html msg
viewIcon kind search i =
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
    div [ Attributes.classList [ ( "text-center", True ), ( "hidden", not (kindaMatch search i) ) ] ]
        [ button [ Attributes.id i.name, class "w-full h-28 flex flex-col justify-center items-center bg-white hover:bg-sky-100 rounded-lg border border-gray-200 hover:border-sky-500 text-gray-600 hover:text-sky-700 transition-colors" ]
            [ div [ class dim ] [ i.viewIcon ] ]
        , label [ Attributes.for i.name, Attributes.title i.name, class "block mt-1 text-gray-500 truncate text-sm" ]
            [ text i.name ]
        ]



-- UTILS


kindaMatch : String -> Gallery.Icon msg -> Bool
kindaMatch search i =
    (i.name :: i.tags)
        |> List.map (String.replace "-" " ")
        |> List.any (String.contains search)


kindStr : IconKind -> String
kindStr kind =
    case kind of
        Outline ->
            "Outline"

        Solid ->
            "Solid"

        Mini ->
            "Mini"
