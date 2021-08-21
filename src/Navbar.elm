module Navbar exposing (view)

import Html.Styled as Html exposing (text)
import Html.Styled.Attributes as Attr exposing (css)
import Tailwind.Utilities as Tw


view inner =
    Html.div []
        [ Html.nav
            [ css
                [ Tw.bg_darkGray
                , Tw.h_32
                , Tw.flex
                , Tw.justify_around
                , Tw.px_8
                , Tw.items_center
                , Tw.text_white
                ]
            ]
            ([ text "About"
             , text "Music"
             , Html.a [ Attr.href "/press" ] [ text "Press" ]
             , Html.a
                [ Attr.href "https://conner-cherland.square.site/"
                , Attr.target "noopener"
                ]
                [ text "Store" ]
             ]
                |> List.map
                    (\navItem ->
                        Html.div [ css [] ] [ navItem ]
                    )
            )
        , inner
        ]
