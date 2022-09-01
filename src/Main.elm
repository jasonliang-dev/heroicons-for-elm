-- elm-live src\Main.elm --start-page=dev.html -- --output=main.js --debug


module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (class)
import Http
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


type alias Model =
    {}


init : () -> ( Model, Cmd Msg )
init _ =
    ( {}
    , Cmd.none
    )



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
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
            [ nav [ class "py-4 px-4 container mx-auto flex justify-end gap-8 text-blue-100 border-b border-blue-400" ]
                [ a [ class "hover:text-blue-50", Html.Attributes.href "#" ] [ text "Heroicons" ]
                , a [ class "hover:text-blue-50", Html.Attributes.href "#" ] [ text "Elm Package" ]
                , a [ class "hover:text-blue-50", Html.Attributes.href "#" ] [ text "GitHub" ]
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
                        , div [ class "px-6 py-4" ]
                            [ pre [ class "overflow-x-auto" ]
                                [ text
                                    """import Svg exposing (..)
import Svg.Attributes exposing (..)

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
            , input [ class "placeholder:italic placeholder:text-slate-400 block bg-white w-full border border-slate-300 rounded-md py-3 pl-9 pr-3 shadow-sm focus:outline-none focus:border-sky-500 focus:ring-sky-500 focus:ring-1", Html.Attributes.placeholder "Search..." ] []
            ]
        ]
