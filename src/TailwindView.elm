module TailwindView exposing (view)

import Css exposing (px)
import Css.Global
import Html.Styled exposing (Html, button, div, img, text)
import Html.Styled.Attributes exposing (css, href, src)
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw


view =
    Html.Styled.toUnstyled <|
        div []
            [ div
                [ css
                    [ Tw.bg_gray_50
                    , Css.backgroundImage (Css.url imageUrl)
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
                    [ img
                        [ src logoUrl
                        , css
                            [ Css.height (px 160)
                            ]
                        ]
                        []
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
            ]


navItems : Html msg
navItems =
    div
        [ css
            [ --Tw.justify_center
              Tw.flex

            --, Tw.p_16
            --, maxWidth (px 1400)
            , Tw.justify_center
            ]
        ]
        [ div
            [ css
                [ Tw.text_white
                , Tw.flex
                , Tw.justify_evenly
                , Tw.p_4
                , Tw.w_full
                , Tw.max_w_screen_lg
                , Tw.text_lg
                ]
            ]
            ([ "About"
             , "Music"
             , "Press"
             , "Dates"
             , "Store"
             ]
                |> List.map (\navItem -> div [] [ text navItem ])
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
                [ button
                    [ css
                        [ Tw.border_4
                        , Tw.border_yellow_300
                        , Tw.text_yellow_300
                        , Tw.px_12
                        , Tw.py_2
                        , Tw.uppercase
                        ]
                    ]
                    [ text "Listen"
                    ]
                ]
            ]
        ]
