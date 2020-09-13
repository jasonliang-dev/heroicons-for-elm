<h1 align="center">Heroicons for Elm</h1>

<p align="center">
  <img src="public/meta-image.png" width="400" />
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
import Html.Attributes exposing (..)
import Svg as Svg
import Svg.Attributes as SvgAttrs


view : Model -> Html Msg
view model =
    div [ class "p-4" ]
        [ button [ class "flex items-center text-gray-600 hover:text-gray-700 bg-white hover:bg-gray-100 p-2 px-4 rounded border border-gray-300" ]
            [ Svg.svg [ SvgAttrs.class "w-5 h-5 mr-2", SvgAttrs.fill "none", SvgAttrs.viewBox "0 0 24 24", SvgAttrs.stroke "currentColor" ] [ Svg.path [ SvgAttrs.strokeLinecap "round", SvgAttrs.strokeLinejoin "round", SvgAttrs.strokeWidth "2", SvgAttrs.d "M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" ] [] ]
            , text "Search"
            ]
        ]
```

Combined with [Tailwind CSS](https://tailwindcss.com/), the example above
creates a nice looking search button which you can view on
[Ellie](https://ellie-app.com/9XTH5sfYkWXa1).
