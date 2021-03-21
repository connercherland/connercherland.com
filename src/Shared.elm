module Shared exposing (Model, Msg(..), PageView, RenderedBody, SharedMsg(..), StaticData, template)

import Css
import Css.Global
import Element exposing (Element)
import Html exposing (Html)
import Html.Styled as H exposing (div)
import Html.Styled.Attributes as Attr exposing (css)
import Icon
import Pages
import Pages.PagePath exposing (PagePath)
import Pages.StaticHttp as StaticHttp
import Tailwind.Utilities as Tw
import TailwindView
import TemplateType exposing (TemplateType)


type alias SharedTemplate templateDemuxMsg msg1 msg2 =
    { init :
        Maybe
            { path :
                { path : PagePath Pages.PathKey
                , query : Maybe String
                , fragment : Maybe String
                }
            , metadata : TemplateType
            }
        -> ( Model, Cmd Msg )
    , update : Msg -> Model -> ( Model, Cmd Msg )
    , view :
        StaticData
        ->
            { path : PagePath Pages.PathKey
            , frontmatter : TemplateType
            }
        -> Model
        -> (Msg -> templateDemuxMsg)
        -> PageView templateDemuxMsg
        -> { body : Html templateDemuxMsg, title : String }
    , map : (msg1 -> msg2) -> PageView msg1 -> PageView msg2
    , staticData : List ( PagePath Pages.PathKey, TemplateType ) -> StaticHttp.Request StaticData
    , subscriptions : TemplateType -> PagePath Pages.PathKey -> Model -> Sub Msg
    , onPageChange :
        Maybe
            ({ path : PagePath Pages.PathKey
             , query : Maybe String
             , fragment : Maybe String
             }
             -> Msg
            )
    }


template : SharedTemplate msg msg1 msg2
template =
    { init = init
    , update = update
    , view = view
    , map = map
    , staticData = staticData
    , subscriptions = subscriptions
    , onPageChange = Just OnPageChange
    }


type alias RenderedBody =
    List (H.Html Never)


type alias PageView msg =
    { title : String, body : List (H.Html msg) }


type Msg
    = OnPageChange
        { path : PagePath Pages.PathKey
        , query : Maybe String
        , fragment : Maybe String
        }
    | SharedMsg SharedMsg


type alias StaticData =
    ()


type SharedMsg
    = IncrementFromChild


type alias Model =
    { showMobileMenu : Bool
    , counter : Int
    }


map : (msg1 -> msg2) -> PageView msg1 -> PageView msg2
map fn doc =
    { title = doc.title
    , body = List.map (H.map fn) doc.body
    }


init :
    Maybe
        { path :
            { path : PagePath Pages.PathKey
            , query : Maybe String
            , fragment : Maybe String
            }
        , metadata : TemplateType
        }
    -> ( Model, Cmd Msg )
init maybePagePath =
    ( { showMobileMenu = False
      , counter = 0
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange page ->
            ( { model | showMobileMenu = False }, Cmd.none )

        SharedMsg globalMsg ->
            case globalMsg of
                IncrementFromChild ->
                    ( { model | counter = model.counter + 1 }, Cmd.none )


subscriptions : TemplateType -> PagePath Pages.PathKey -> Model -> Sub Msg
subscriptions _ _ _ =
    Sub.none


staticData : a -> StaticHttp.Request StaticData
staticData siteMetadata =
    StaticHttp.succeed ()


view :
    StaticData
    ->
        { path : PagePath Pages.PathKey
        , frontmatter : TemplateType
        }
    -> Model
    -> (Msg -> msg)
    -> PageView msg
    -> { body : Html msg, title : String }
view globalStaticData page model toMsg pageView =
    { title = pageView.title
    , body =
        H.toUnstyled <|
            div
                [ css
                    [ Tw.flex
                    , Tw.flex_col
                    , Tw.h_screen

                    --, Tw.max_w_xl
                    ]
                ]
                [ -- This will give us the standard tailwind style-reset as well as the fonts
                  Css.Global.global Tw.globalStyles
                , if page.path == Pages.pages.index then
                    TailwindView.view

                  else
                    div
                        [ css
                            [ Tw.flex
                            , Tw.flex_col
                            , Tw.max_w_2xl
                            , Tw.items_center
                            , Tw.justify_center
                            , Tw.justify_between
                            , Tw.mx_auto
                            , Tw.flex_grow
                            ]
                        ]
                        pageView.body
                , footer
                ]
    }


footer =
    H.footer []
        [ div []
            [ div
                [ css
                    [ Tw.py_8
                    , Tw.bg_darkGray
                    , Tw.justify_center
                    , Tw.flex
                    ]
                ]
                [ div
                    [ css
                        [ Tw.flex
                        , Tw.max_w_sm
                        , Tw.w_full
                        , Tw.justify_around
                        ]
                    ]
                    ([ ( Icon.youtube, "https://www.youtube.com/user/itsconnercherland" )
                     , ( Icon.spotify, "https://open.spotify.com/artist/33TOnR5uudaXvJjQhgNGk8" )
                     , ( Icon.facebook, "https://facebook.com/connercherland/" )
                     , ( Icon.instagram, "https://instagram.com/connercherland/" )
                     , ( Icon.twitter, "https://twitter.com/ConnerCherland/" )
                     ]
                        |> List.map
                            (\( icon, url ) ->
                                div [ css [ Tw.w_8 ] ]
                                    [ H.a
                                        [ Attr.href url
                                        , Attr.target "noopener"
                                        ]
                                        [ icon ]
                                    ]
                            )
                    )
                ]
            , div
                [ css
                    [ Tw.flex
                    , Tw.w_full
                    , Tw.justify_center
                    , Tw.py_8
                    , Tw.bg_darkGray
                    ]
                ]
                [ logo
                ]
            ]
        ]


logo =
    H.img
        [ Attr.src logoUrl
        , css
            [ Css.height (Css.px 160)
            ]
        ]
        []


logoUrl : String
logoUrl =
    "https://res.cloudinary.com/connercherland/image/upload/v1613279618/d2c8ce93487154e6ba130d9d590171ce_v155te.png"
