module TailwindView exposing (view)

import Css exposing (px)
import Css.Global
import Html.Styled as Html exposing (Html, a, button, div, h2, img, text)
import Html.Styled.Attributes as Attr exposing (css, href, src)
import Icon
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw


view : Html msg
view =
    div []
        [ div
            [ css
                [ Css.backgroundImage (Css.url imageUrl)
                , Tw.bg_cover
                , Tw.min_h_screen
                , Css.backgroundRepeat Css.noRepeat
                , Css.backgroundPosition Css.center
                ]
            ]
            [ -- This will give us the standard tailwind style-reset as well as the fonts
              Css.Global.global Tw.globalStyles
            , div
                [ css
                    [ Tw.flex
                    , Tw.w_full
                    , Tw.justify_center
                    , Tw.py_8
                    ]
                ]
                [ logo
                ]
            , navItems
            , div
                [ css
                    [ Tw.mt_8
                    , Tw.flex

                    -- We use breakpoints like this
                    -- However, you need to order your breakpoints from hight to low :/
                    , Bp.lg [ Tw.mt_0, Tw.flex_shrink_0 ]
                    ]
                ]
                []
            ]
        , merchSection
        , covidDatesSection
        ]


navItems : Html msg
navItems =
    div
        [ css
            [ Tw.flex
            , Tw.justify_center
            ]
        ]
        [ div
            [ css
                [ Tw.text_white
                , Tw.flex
                , Tw.justify_evenly
                , Tw.w_full
                , Tw.max_w_screen_lg
                , Tw.text_lg
                , Tw.items_center
                , Tw.flex_wrap
                ]
            ]
            (([ text "About"
              , text "Music"
              , a [ href "/press" ] [ text "Press" ]
              , a
                    [ href "https://conner-cherland.square.site/"
                    , Attr.target "noopener"
                    ]
                    [ text "Store" ]
              ]
                |> List.map
                    (\navItem ->
                        div [ css [] ] [ navItem ]
                    )
             )
                ++ [ div
                        [ css
                            []
                        ]
                        [ myButtonSolid "Plan Your Event"
                        ]
                   ]
            )
        ]


imageUrl : String
imageUrl =
    "https://res.cloudinary.com/connercherland/image/upload/c_scale,f_auto,q_auto:best,w_1500,b_rgb:000000,o_42/v1613276747/65849884afeb5ebd2a5f78c106b5a283_hffbhh.avif"


logoUrl : String
logoUrl =
    "https://res.cloudinary.com/connercherland/image/upload/v1613279618/d2c8ce93487154e6ba130d9d590171ce_v155te.png"


merchUrl : String
merchUrl =
    "https://res.cloudinary.com/connercherland/image/upload/v1613326220/f56bedce048951b704c5cec31d38b06d_vv2mnj.png"


merchSection : Html msg
merchSection =
    div
        [ css
            [ Tw.flex
            , Tw.flex_wrap
            , Tw.flex_col
            , Bp.md [ Tw.flex_row ]
            ]
        ]
        [ div
            [ css
                [ Tw.flex_1
                ]
            ]
            [ img
                [ src merchUrl
                , css
                    [ Tw.w_full
                    ]
                ]
                []
            ]
        , div
            [ css
                [ Tw.flex_1
                , Tw.flex
                , Tw.flex_col
                , Tw.justify_center
                , Tw.text_center
                , Tw.p_4
                , Tw.uppercase
                , Tw.space_y_4
                ]
            ]
            [ div
                [ css
                    [ Tw.font_bold
                    , Tw.text_4xl
                    ]
                ]
                [ text "Love Songs"
                ]
            , div []
                [ text "Listen to my newest album!"
                ]
            , div []
                [ myButton
                    [ Attr.href "https://open.spotify.com/album/4HacgsEJ1GBWFb1XcrXI8t?si=toBv05h1Tcih-4k75F269w"
                    , Attr.target "noopener"
                    ]
                    "Listen"
                ]
            ]
        ]


myButton attrs title =
    a
        (css
            [ Tw.border_4
            , Tw.border_highlight
            , Tw.text_highlight
            , Tw.px_12
            , Tw.py_2
            , Tw.uppercase
            , Tw.bg_white
            , Css.hover
                [ Tw.text_white
                , Tw.bg_highlight
                ]
            ]
            :: attrs
        )
        [ text title
        ]


myButtonSolid : String -> Html msg
myButtonSolid title =
    button
        [ css
            [ Tw.border_4
            , Tw.border_highlight
            , Tw.bg_highlight
            , Tw.text_white
            , Tw.px_12
            , Tw.py_2
            , Tw.uppercase
            , Tw.rounded_xl
            ]
        ]
        [ text title ]


covidDatesSection : Html msg
covidDatesSection =
    div
        [ css
            [ Tw.flex
            , Tw.flex_col
            , Tw.space_y_8
            , Tw.bg_lightGray
            , Tw.p_8
            ]
        ]
        [ h2
            [ css
                [ Tw.text_center
                , Tw.text_4xl
                , Tw.font_bold
                , Tw.uppercase
                ]
            ]
            [ text "Dates" ]
        , div
            [ css
                [ Tw.space_y_8
                , Tw.flex_col
                , Bp.md
                    [ Tw.flex_row
                    , Tw.text_center
                    ]
                ]
            ]
            [ Html.p [] [ text "Due to COVID19, most of my public shows are now socially distant house concerts." ]
            , div
                [ css
                    [ Tw.flex
                    , Tw.items_center
                    , Tw.justify_center
                    ]
                ]
                [ div [ css [ Tw.max_w_sm ] ]
                    [ Html.iframe
                        [ Attr.src "https://www.youtube.com/embed/bIjLIrRrt3M"
                        , Attr.title "YouTube video player"
                        , Attr.attribute "frameborder" "0"
                        , Attr.attribute "allow" "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                        , Attr.attribute "allowfullscreen" ""
                        ]
                        []
                    ]
                ]
            , Html.p [] [ text "Please let me know if you’d like one, and we’ll figure out a date!" ]
            , Html.p []
                [ text "Love," ]
            , Html.p [] [ text "Conner" ]
            ]
        ]


showsSection : Html msg
showsSection =
    div
        [ css
            [ Tw.flex
            , Tw.flex_col
            , Tw.space_y_8
            , Tw.bg_lightGray
            , Tw.p_8
            ]
        ]
        [ h2
            [ css
                [ Tw.text_center
                , Tw.text_4xl
                , Tw.font_bold
                , Tw.uppercase
                ]
            ]
            [ text "Dates" ]
        , div
            [ css
                [ Tw.space_y_8
                , Tw.flex_col
                , Bp.md
                    [ Tw.flex_row
                    ]
                ]
            ]
            [ showView
            , showView
            , showView
            ]
        ]


showView =
    div
        [ css
            [ Tw.flex
            , Tw.flex_col
            , Tw.text_center
            , Tw.space_y_4
            , Bp.md
                [ Tw.flex_row
                , Tw.justify_around
                ]
            ]
        ]
        [ div
            [ css
                [ Tw.flex
                , Tw.flex_col
                ]
            ]
            [ div [] [ text show.dateString ]
            , div [] [ text show.venueName ]
            ]
        , div [] [ text show.cityName ]
        , div []
            [ myButton [] show.showType
            ]
        ]


show =
    { dateString = "Aug 7, 2020 - 8PM"
    , venueName = "BEST VENUE EVER."
    , cityName = "Santa Barbara, CA"
    , showType = "Free Event"
    }


logo =
    img
        [ src logoUrl
        , css
            [ Css.height (px 160)
            ]
        ]
        []
