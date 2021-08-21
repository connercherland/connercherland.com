module Navbar exposing (view)

import Css
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
                ]
            ]
            [ logo
            , Html.div
                [ css
                    [ Tw.flex
                    , Tw.justify_around
                    , Tw.flex_grow
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
            ]
        , inner
        ]


logo : Html.Html msg
logo =
    Html.img
        [ Attr.src logoUrl
        , css
            [ Css.height (Css.px 160)
            ]
        ]
        []


logoUrl : String
logoUrl =
    "https://res.cloudinary.com/connercherland/image/upload/v1613279618/d2c8ce93487154e6ba130d9d590171ce_v155te.png"
