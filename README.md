<h1 align="center">Heroicons for Elm</h1>

<p align="center">
  <img src="resources/meta-image.png" width="400" />
</p>

<p align="center">
  <a href="https://github.com/tailwindlabs/heroicons">
    Heroicons
  </a>
  ported over to <code>elm/svg</code> elements for you to use in your own Elm
  projects.
</p>



## Usage

Add `elm/svg` to your project:

```
elm install elm/svg
```

Then go to
[jasonliang.js.org/heroicons-for-elm/](https://jasonliang.js.org/heroicons-for-elm/)
and copy the code provided to you into your project:

```elm
import Html exposing (..)
import Html.Attributes exposing (class)
import Svg as S
import Svg.Attributes as SAview : Model -> Html Msg

view : Model -> Html Msg
view model =
    div [ class "p-8" ]
        [ button [ class "border rounded shadow bg-white hover:bg-gray-100 px-4 py-2 flex items-center" ]
            [ S.svg [ SA.class "w-6 h-6 mr-2", SA.fill "none", SA.viewBox "0 0 24 24", SA.strokeWidth "1.5", SA.stroke "currentColor" ] [ S.path [ SA.strokeLinecap "round", SA.strokeLinejoin "round", SA.d "M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" ] [] ]
            , span [ class "font-semibold text-gray-700 -mt-0.5" ] [ text "Verify" ]
            ]
        ]
```

Combined with [Tailwind CSS](https://tailwindcss.com/), the example above
creates a nice looking search button which you can view on
[Ellie](https://ellie-app.com/jyhrn3SKwTHa1).