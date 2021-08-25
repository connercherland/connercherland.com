module Footer exposing (view)

import Css
import Html.Styled as Html exposing (text)
import Html.Styled.Attributes as Attr exposing (css)
import Icon
import Tailwind.Utilities as Tw


view =
    Html.footer
        [ css
            [ Tw.h_32
            , Tw.flex
            ]
        ]
        [ Html.div
            [ css
                [ Tw.flex
                , Tw.px_8
                , Tw.flex_grow
                , Tw.justify_center
                ]
            ]
            [ Html.div
                [ css
                    [ Tw.flex
                    , Tw.justify_center
                    , Tw.max_w_md
                    , Tw.flex_grow
                    ]
                ]
                [ Html.div
                    [ css
                        [ Tw.flex
                        , Tw.flex_col
                        , Tw.justify_center
                        , Tw.space_y_4
                        ]
                    ]
                    [ Html.div
                        [ css
                            [ Tw.flex
                            , Tw.space_x_8
                            , Tw.uppercase
                            ]
                        ]
                        ([ Html.a
                            [ Attr.href "https://conner-cherland.square.site/"
                            , Attr.target "noopener"
                            ]
                            [ text "Store" ]
                         , Html.a [ Attr.href "/contact" ] [ text "Contact" ]
                         ]
                            |> List.map
                                (\navItem ->
                                    Html.div [ css [] ] [ navItem ]
                                )
                        )
                    , Html.div
                        [ css
                            [ Tw.flex
                            , Tw.space_x_3
                            , Tw.justify_center
                            ]
                        ]
                        [ icon "https://open.spotify.com/artist/33TOnR5uudaXvJjQhgNGk8" Icon.spotify
                        , icon "https://www.youtube.com/user/itsconnercherland" Icon.youtube
                        , icon "https://instagram.com/connercherland/" Icon.instagram
                        , icon "http://facebook.com/connercherland/" Icon.facebook
                        ]
                    ]
                ]
            ]
        ]


icon : String -> Html.Html msg -> Html.Html msg
icon url svgIcon =
    Html.a
        [ Attr.href url
        , css
            [ Tw.flex
            , Tw.flex_col
            , Tw.flex_grow
            ]
        ]
        [ svgIcon
        ]
