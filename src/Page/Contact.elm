module Page.Contact exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes exposing (css)
import Markdown.Renderer
import MarkdownCodec
import Page exposing (Page, PageWithState, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Tailwind.Utilities as Tw
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


type alias Data =
    List (Html Msg)


data : DataSource Data
data =
    MarkdownCodec.withoutFrontmatter Markdown.Renderer.defaultHtmlRenderer "content/contact.md"
        |> DataSource.map (List.map Html.fromUnstyled)


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Contact"
    , body =
        [ Html.main_
            [ css
                [ Tw.p_16
                , Tw.flex
                , Tw.flex_col
                , Tw.items_center
                ]
            ]
            [ Html.h1
                [ css
                    [ Tw.text_3xl
                    , Tw.text_center
                    , Tw.mt_16
                    , Tw.mb_8
                    ]
                ]
                [ Html.text "Contact"
                ]
            , Html.div
                [ css
                    [ Tw.prose
                    , Tw.max_w_md
                    ]
                ]
                static.data
            ]
        ]
    }
