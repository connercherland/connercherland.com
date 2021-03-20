module Main exposing (main)

--import Html exposing (Html)

import Element exposing (Element)
import Feed
import Head
import Html.Styled
import Json.Decode
import Markdown.Parser
import Markdown.Renderer
import MySitemap
import Pages
import Pages.PagePath exposing (PagePath)
import Pages.Platform
import Pages.StaticHttp as StaticHttp
import Shared
import Site
import TailwindMarkdownRenderer
import TemplateModulesBeta
import TemplateType exposing (TemplateType)


main : Pages.Platform.Program TemplateModulesBeta.Model TemplateModulesBeta.Msg TemplateType Shared.RenderedBody Pages.PathKey
main =
    TemplateModulesBeta.mainTemplate
        { documents = [ markdownDocument ]
        , site = Site.config
        }
        |> Pages.Platform.withFileGenerator generateFiles
        |> Pages.Platform.withGlobalHeadTags commonHeadTags
        |> Pages.Platform.toProgram


generateFiles :
    List
        { path : PagePath Pages.PathKey
        , frontmatter : TemplateType
        , body : String
        }
    ->
        StaticHttp.Request
            (List
                (Result String
                    { path : List String
                    , content : String
                    }
                )
            )
generateFiles siteMetadata =
    StaticHttp.succeed
        [ Feed.fileToGenerate { siteTagline = Site.tagline, siteUrl = Site.canonicalUrl } siteMetadata |> Ok
        , MySitemap.build { siteUrl = Site.canonicalUrl } siteMetadata |> Ok
        ]


markdownDocument : { extension : String, metadata : Json.Decode.Decoder TemplateType, body : String -> Result String (List (Html.Styled.Html msg)) }
markdownDocument =
    { extension = "md"
    , metadata = TemplateType.decoder
    , body = TailwindMarkdownRenderer.renderMarkdown
    }


commonHeadTags : List (Head.Tag Pages.PathKey)
commonHeadTags =
    [ Head.rssLink "/blog/feed.xml"
    , Head.sitemapLink "/sitemap.xml"
    ]
