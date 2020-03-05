module Youtube exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


view : String -> Html msg
view id =
    iframe
        [ attribute "allow" "accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
        , attribute "allowfullscreen" ""
        , attribute "frameborder" "0"
        , attribute "height" "315"
        , src <| "https://www.youtube-nocookie.com/embed/" ++ id

        --, attribute "width" "560"
        , attribute "width" "315"
        ]
        []
