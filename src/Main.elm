module Main exposing (main)

import Color
import Data.Author as Author
import Date
import DateFormat
import DocumentSvg
import Element exposing (Element)
import Element.Background
import Element.Border
import Element.Font as Font
import Element.Region
import Feed
import FontAwesome as Fa
import Head
import Head.Seo as Seo
import Html exposing (..)
import Html.Attributes as Attr exposing (class)
import Html.Events
import Index
import Layout
import Markdown
import MenuSvg
import Metadata exposing (Metadata)
import MySitemap
import Pages exposing (images, pages)
import Pages.Directory as Directory exposing (Directory)
import Pages.Document
import Pages.ImagePath as ImagePath exposing (ImagePath)
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Pages.PagePath as PagePath exposing (PagePath)
import Pages.Platform exposing (Page)
import Pages.Secrets as Secrets
import Pages.StaticHttp as StaticHttp
import Palette
import Request.Shows as Shows
import Task
import Time
import TimeZone
import Youtube


icon : Fa.Icon -> Element msg
icon iconType =
    --Fa.icon
    Fa.iconWithOptions iconType Fa.Solid [ Fa.InvertColor ] []
        |> Element.html
        |> Element.el
            []


manifest : Manifest.Config Pages.PathKey
manifest =
    { backgroundColor = Just Color.white
    , categories = [ Pages.Manifest.Category.education ]
    , displayMode = Manifest.Standalone
    , orientation = Manifest.Portrait
    , description = "Conner Cherland Music"
    , iarcRatingId = Nothing
    , name = "Conner Cherland Music"
    , themeColor = Just Color.white
    , startUrl = pages.index
    , shortName = Nothing
    , sourceIcon = images.icon
    }


type alias Rendered =
    Element Msg



-- the intellij-elm plugin doesn't support type aliases for Programs so we need to use this line
-- main : Platform.Program Pages.Platform.Flags (Pages.Platform.Model Model Msg Metadata Rendered) (Pages.Platform.Msg Msg Metadata Rendered)


main : Pages.Platform.Program Model Msg Metadata Rendered
main =
    Pages.Platform.application
        { init = \_ -> init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , documents = [ markdownDocument ]
        , manifest = manifest
        , canonicalSiteUrl = canonicalSiteUrl
        , onPageChange = \_ -> OnPageChange
        , generateFiles = generateFiles
        , internals = Pages.internals
        }


generateFiles :
    List
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        , body : String
        }
    ->
        List
            (Result String
                { path : List String
                , content : String
                }
            )
generateFiles siteMetadata =
    [ Feed.fileToGenerate { siteTagline = siteTagline, siteUrl = canonicalSiteUrl } siteMetadata |> Ok
    , MySitemap.build { siteUrl = canonicalSiteUrl } siteMetadata |> Ok
    ]


markdownDocument : ( String, Pages.Document.DocumentHandler Metadata Rendered )
markdownDocument =
    Pages.Document.parser
        { extension = "md"
        , metadata = Metadata.decoder
        , body =
            \markdownBody ->
                Html.div [] [ Markdown.toHtml [] markdownBody ]
                    |> Element.html
                    |> List.singleton
                    |> Element.paragraph [ Element.width Element.fill ]
                    |> Ok
        }


type alias Model =
    { timezone : NamedZone
    , menuOpen : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { timezone =
            { name = "Pacific"
            , zone = TimeZone.america__los_angeles ()
            }
      , menuOpen = False
      }
    , Cmd.none
    )


type Msg
    = OnPageChange
    | ToggleMenu


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnPageChange ->
            ( model, Cmd.none )

        ToggleMenu ->
            ( { model | menuOpen = not model.menuOpen }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view :
    List ( PagePath Pages.PathKey, Metadata )
    ->
        { path : PagePath Pages.PathKey
        , frontmatter : Metadata
        }
    ->
        StaticHttp.Request
            { view : Model -> Rendered -> { title : String, body : Html Msg }
            , head : List (Head.Tag Pages.PathKey)
            }
view siteMetadata page =
    if page.path == pages.dates.index then
        StaticHttp.map
            (\shows ->
                { view =
                    \model viewForPage ->
                        let
                            { title, body } =
                                pageView model siteMetadata page viewForPage
                        in
                        { title = title
                        , body =
                            Layout.view model
                                ToggleMenu
                                [ div [ class "flex justify-center" ]
                                    [ showsView model.timezone shows
                                    ]
                                ]

                        -- Element.column [ Element.width Element.fill, Element.height Element.fill ]
                        --     [ header page.path
                        --     , Element.row
                        --         [ Element.width Element.fill
                        --         , Element.htmlAttribute (Attr.style "flex-wrap" "wrap")
                        --         ]
                        --         [ Youtube.view "_wZ-xT_Nacg"
                        --             |> Element.html
                        --             |> Element.el [ Element.centerX ]
                        --         , Element.column
                        --             [ Element.padding 30
                        --             , Element.spacing 40
                        --             , Element.Region.mainContent
                        --             --, Element.width (Element.fill |> Element.maximum 800)
                        --             , Element.centerX
                        --             ]
                        --             [ showsView model.timezone shows
                        --             ]
                        --         ]
                        --     , footer
                        --     ]
                        --     |> Element.layout
                        --         [ Element.width Element.fill
                        --         , Font.size 20
                        --         , Font.family [ Font.typeface "Montserrat" ]
                        --         , Font.color (Element.rgba255 0 0 0 0.8)
                        --         ]
                        }
                , head = head page.frontmatter
                }
            )
            (Shows.staticGraphqlRequest Shows.selection)

    else
        StaticHttp.succeed
            { view =
                \model viewForPage ->
                    let
                        { title, body } =
                            pageView model siteMetadata page viewForPage
                    in
                    { title = title
                    , body = Layout.view model ToggleMenu landingPageBodyNew
                    }
            , head = head page.frontmatter
            }


landingPageBodyNew =
    [ div [ class "md:flex flex-grow" ]
        [ div [ class "md:flex-shrink-0 md:w-1/2 p-6 md:p-12 lg:p-24" ]
            [ Html.img
                [ Attr.src <| ImagePath.toString Pages.images.connerLandingPage
                , Attr.alt "Conner Cherland"
                , class "min-w-fullobject-center"

                -- , class "lg:w-1/2 md:flex-shrink-0"
                ]
                []
            ]
        , div [ class "lg:w-1/2 sm:flex-shrink p-6 md:p-12 lg:p-24 text-lg" ]
            [ div [ class "w-64 md:w-auto mx-auto flex justify-center flex-col h-full" ]
                [ div [ class "pb-4" ]
                    [ text "I’m a dedicated musician, based in Santa Barbara." ]
                , div []
                    [ ul
                        [ class "list-disc pb-4" ]
                        [ li [] [ text "4 albums recorded" ]
                        , li [] [ text "Over 700 shows" ]
                        ]
                    ]
                , div [ class "pb-4" ]
                    [ text "Let’s plan your next event today." ]
                , div []
                    [ ul
                        [ class "list-disc pb-4" ]
                        [ li [] [ text "Weddings" ]
                        , li [] [ text "Corporate Events" ]
                        , li [] [ text "House Concerts" ]
                        , li [] [ text "Private Events" ]
                        ]
                    ]
                , div [ class "flex justify-center md:justify-start" ]
                    [ button
                        -- [ class "bg-white hover:bg-gray-100 text-gray-800 font-semibold py-2 px-4 border border-gray-400 rounded shadow font-display"
                        [ class "bg-black hover:bg-gray-800 text-gray-100 font-semibold py-2 px-4 border border-gray-400 rounded font-display shadow-lg"
                        ]
                        [ text "Plan Your Event" ]
                    ]
                ]

            --                 [ p "4 albums recorded"
            --                 , p "Over 700 shows"
            --                 ]
            --             , p "Let’s plan your next event today."
            --             , points
            --                 [ p "Weddings"
            --                 , p "Corporate Events"
            --                 , p "House Concerts"
            --                 , p "Private Events"
            --                 ]
            ]
        ]
    ]



-- { src = ImagePath.toString Pages.images.connerLandingPage
-- , description = "Conner Cherland"
-- }
-- Element.row
--     [ -- Element.spacing 40
--       Element.htmlAttribute (Attr.style "flex-wrap" "wrap")
--     , Element.width Element.fill
--     ]
--     [ Element.row
--         [ Element.width (Element.fillPortion 1)
--         ]
--         [ Element.image
--             [ -- Element.width (Element.fill |> Element.maximum 600 |> Element.minimum 300)
--               Element.width (Element.fill |> Element.maximum 600 |> Element.minimum 200)
--             , Element.paddingEach { top = 0, right = 0, bottom = 40, left = 0 }
--             ]
--             { src = ImagePath.toString Pages.images.connerLandingPage
--             , description = "Conner Cherland"
--             }
--         ]
--     , Element.column
--         [ Element.centerX
--         -- , Element.width (Element.fill |> Element.maximum 600)
--         , Element.width (Element.fillPortion 1)
--         -- , Element.width (Element.fillPortion 1 |> Element.minimum 300)
--         -- , Element.width (Element.fillPortion 1 |> Element.minimum 150)
--         , Element.spacing 30
--         , Font.center
--         ]
--         [ p "I’m a dedicated musician, based in Santa Barbara."
--         , points
--             [ p "4 albums recorded"
--             , p "Over 700 shows"
--             ]
--         , p "Let’s plan your next event today."
--         , points
--             [ p "Weddings"
--             , p "Corporate Events"
--             , p "House Concerts"
--             , p "Private Events"
--             ]
--         , Element.row
--             [ Element.centerX
--             , Element.Border.rounded 14
--             , Element.paddingXY 18 14
--             , Element.Background.gradient
--                 { angle = 0.2
--                 , steps =
--                     [ Element.rgb255 0 10 20
--                     , Element.rgb255 40 40 40
--                     ]
--                 }
--             , Font.color (Element.rgba255 255 255 255 0.9)
--             , Font.family [ Font.typeface "Roboto Condensed" ]
--             ]
--             [ Element.text "Plan Your Event" ]
--         ]
--     ]
-- landingPageBody =
--     Element.row
--         [ -- Element.spacing 40
--           Element.htmlAttribute (Attr.style "flex-wrap" "wrap")
--         , Element.width Element.fill
--         ]
--         [ Element.row
--             [ Element.width (Element.fillPortion 1)
--             ]
--             [ Element.image
--                 [ -- Element.width (Element.fill |> Element.maximum 600 |> Element.minimum 300)
--                   Element.width (Element.fill |> Element.maximum 600 |> Element.minimum 200)
--                 , Element.paddingEach { top = 0, right = 0, bottom = 40, left = 0 }
--                 ]
--                 { src = ImagePath.toString Pages.images.connerLandingPage
--                 , description = "Conner Cherland"
--                 }
--             ]
--         , Element.column
--             [ Element.centerX
--             -- , Element.width (Element.fill |> Element.maximum 600)
--             , Element.width (Element.fillPortion 1)
--             -- , Element.width (Element.fillPortion 1 |> Element.minimum 300)
--             -- , Element.width (Element.fillPortion 1 |> Element.minimum 150)
--             , Element.spacing 30
--             , Font.center
--             ]
--             [ p "I’m a dedicated musician, based in Santa Barbara."
--             , points
--                 [ p "4 albums recorded"
--                 , p "Over 700 shows"
--                 ]
--             , p "Let’s plan your next event today."
--             , points
--                 [ p "Weddings"
--                 , p "Corporate Events"
--                 , p "House Concerts"
--                 , p "Private Events"
--                 ]
--             , Element.row
--                 [ Element.centerX
--                 , Element.Border.rounded 14
--                 , Element.paddingXY 18 14
--                 , Element.Background.gradient
--                     { angle = 0.2
--                     , steps =
--                         [ Element.rgb255 0 10 20
--                         , Element.rgb255 40 40 40
--                         ]
--                     }
--                 , Font.color (Element.rgba255 255 255 255 0.9)
--                 , Font.family [ Font.typeface "Roboto Condensed" ]
--                 ]
--                 [ Element.text "Plan Your Event" ]
--             ]
--         ]


points pointList =
    Element.column [ Element.paddingEach { left = 30, top = 0, right = 0, bottom = 0 } ] (pointList |> List.map (\point -> Element.row [ Element.spacing 10 ] [ Element.text "•", point ]))


showsView zone shows =
    div [ class "flex flex-col" ] (List.map (showView zone) shows)


showViewOld : NamedZone -> Shows.Show -> Element msg
showViewOld zone show =
    Element.column
        []
        [ dateFormatter zone show.startTime
            |> Element.text
            |> Element.el [ Font.bold ]
        , Element.text show.venue
        , timeFormatter zone show.startTime
            |> Element.text
        ]


showView : NamedZone -> Shows.Show -> Html msg
showView zone show =
    div
        [ class "mt-6 text-center" ]
        [ h2 [ class "font-bold" ]
            [ dateFormatter zone show.startTime
                |> text
            ]

        -- |> Element.el [ Font.bold ]
        , div [] [ text show.venue ]
        , div []
            [ timeFormatter zone show.startTime
                |> text
            ]
        ]


type alias NamedZone =
    { name : String
    , zone : Time.Zone
    }


dateFormatter : NamedZone -> Time.Posix -> String
dateFormatter timezone =
    DateFormat.format
        [ DateFormat.dayOfWeekNameFull
        , DateFormat.text ", "
        , DateFormat.monthNameFull
        , DateFormat.text " "
        , DateFormat.dayOfMonthNumber
        ]
        timezone.zone


timeFormatter : NamedZone -> Time.Posix -> String
timeFormatter timezone =
    DateFormat.format
        [ DateFormat.hourNumber
        , DateFormat.text ":"
        , DateFormat.minuteFixed
        , DateFormat.amPmLowercase
        , DateFormat.text <| " " ++ timezone.name
        ]
        timezone.zone


pageView : Model -> List ( PagePath Pages.PathKey, Metadata ) -> { path : PagePath Pages.PathKey, frontmatter : Metadata } -> Rendered -> { title : String, body : Element Msg }
pageView model siteMetadata page viewForPage =
    case page.frontmatter of
        Metadata.Page metadata ->
            { title = metadata.title
            , body =
                [ header page.path
                , Element.column
                    [ Element.padding 50
                    , Element.spacing 60
                    , Element.Region.mainContent
                    ]
                    [ viewForPage
                    ]
                ]
                    |> Element.textColumn
                        [ Element.width Element.fill
                        ]
            }

        Metadata.Article metadata ->
            { title = metadata.title
            , body =
                Element.column [ Element.width Element.fill ]
                    [ header page.path
                    , Element.column
                        [ Element.padding 30
                        , Element.spacing 40
                        , Element.Region.mainContent
                        , Element.width (Element.fill |> Element.maximum 800)
                        , Element.centerX
                        ]
                        (Element.column [ Element.spacing 10 ]
                            [ Element.row [ Element.spacing 10 ]
                                [ Author.view [] metadata.author
                                , Element.column [ Element.spacing 10, Element.width Element.fill ]
                                    [ Element.paragraph [ Font.bold, Font.size 24 ]
                                        [ Element.text metadata.author.name
                                        ]
                                    , Element.paragraph [ Font.size 16 ]
                                        [ Element.text metadata.author.bio ]
                                    ]
                                ]
                            ]
                            :: (publishedDateView metadata |> Element.el [ Font.size 16, Font.color (Element.rgba255 0 0 0 0.6) ])
                            :: Palette.blogHeading metadata.title
                            :: articleImageView metadata.image
                            :: [ viewForPage ]
                        )
                    ]
            }

        Metadata.Author author ->
            { title = author.name
            , body =
                Element.column
                    [ Element.width Element.fill
                    ]
                    [ header page.path
                    , Element.column
                        [ Element.padding 30
                        , Element.spacing 20
                        , Element.Region.mainContent
                        , Element.width (Element.fill |> Element.maximum 800)
                        , Element.centerX
                        ]
                        [ Palette.blogHeading author.name
                        , Author.view [] author
                        , Element.paragraph [ Element.centerX, Font.center ] [ viewForPage ]
                        ]
                    ]
            }

        Metadata.BlogIndex ->
            { title = "elm-pages blog"
            , body =
                Element.column [ Element.width Element.fill ]
                    [ header page.path
                    , Element.column [ Element.padding 20, Element.centerX ] [ Index.view siteMetadata ]
                    ]
            }


articleImageView : ImagePath Pages.PathKey -> Element msg
articleImageView articleImage =
    Element.image [ Element.width Element.fill ]
        { src = ImagePath.toString articleImage
        , description = "Article cover photo"
        }


header : PagePath Pages.PathKey -> Element msg
header currentPath =
    Element.row
        [ Element.paddingXY 25 15
        , Element.spaceEvenly
        , Font.color (Element.rgb255 250 235 250)
        , Font.family [ Font.typeface "Roboto Condensed" ]
        , Element.width Element.fill
        , Element.Region.navigation
        , Element.Border.widthEach { bottom = 1, left = 0, right = 0, top = 0 }
        , Element.Background.gradient
            { angle = 0.2
            , steps =
                [ Element.rgb255 0 10 20
                , Element.rgb255 40 40 40
                ]
            }
        ]
        [ Element.link []
            { url = "/"
            , label =
                Element.row
                    [ Font.size 30
                    , Element.spacing 16
                    , Font.bold
                    ]
                    [ Element.text "Conner Cherland" ]
            }
        , responsive
            { small = MenuSvg.view |> Element.html
            , large =
                Element.row [ Element.spacing 15 ]
                    [ highlightableLink currentPath pages.blog.directory "Store"
                    , highlightableLink currentPath pages.dates.directory "Dates"
                    , highlightableLink currentPath pages.blog.directory "Blog"
                    , highlightableLink currentPath pages.blog.directory "Contact"
                    ]
            }
        ]


footer : Element msg
footer =
    Element.row
        [ Font.color (Element.rgb255 250 235 250)
        , Font.family [ Font.typeface "Roboto Condensed" ]
        , Element.width Element.fill
        , Element.Region.footer
        , Element.alignBottom
        , Element.padding 20

        --, Element.Border.widthEach { bottom = 1, left = 0, right = 0, top = 0 }
        , Element.Background.gradient
            { angle = 0.2
            , steps =
                [ Element.rgb255 0 10 20
                , Element.rgb255 40 40 40
                ]
            }
        ]
        []


icons =
    Html.div
        [--     Element.centerX
         -- , Element.spacing 12
         -- , Font.size 30
        ]
        [ iconLink Fa.spotify "https://open.spotify.com/artist/33TOnR5uudaXvJjQhgNGk8"
        , iconLink Fa.facebookSquare "http://facebook.com/connercherland/"
        , iconLink Fa.instagram "https://instagram.com/connercherland/"
        , iconLink Fa.twitterSquare "https://twitter.com/ConnerCherland/"
        , iconLink Fa.youTubeSquare "https://www.youtube.com/user/itsconnercherland"
        ]


iconLink : Fa.Icon -> String -> Html msg
iconLink iconType url =
    a
        [ Attr.href url, class "text-gray-100 hover:text-gray-400 mr-4 text-2xl" ]
        [ Fa.icon iconType ]



-- |> Element.html
-- |> Element.el
-- [ Element.mouseOver [ Font.color (Element.rgba255 255 255 255 0.7) ] ]


responsive { small, large } =
    Element.row []
        [ small |> Element.el [ Element.htmlAttribute (Attr.class "mobileonly") ]
        , large |> Element.el [ Element.htmlAttribute (Attr.class "largeonly") ]
        ]


id name =
    Element.htmlAttribute (Attr.id name)


mobileOnly : Element.Attribute msg
mobileOnly =
    Element.htmlAttribute (Attr.class "mobile-only")


highlightableLink :
    PagePath Pages.PathKey
    -> Directory Pages.PathKey Directory.WithIndex
    -> String
    -> Element msg
highlightableLink currentPath linkDirectory displayName =
    let
        isHighlighted =
            currentPath |> Directory.includes linkDirectory
    in
    Element.link
        ((if isHighlighted then
            [ Font.underline
            , Font.color Palette.color.primary
            ]

          else
            []
         )
            ++ [ Element.mouseOver [ Font.color (Element.rgba255 255 255 255 0.7) ]
               ]
        )
        { url = linkDirectory |> Directory.indexPath |> PagePath.toString
        , label = Element.text displayName
        }


commonHeadTags : List (Head.Tag Pages.PathKey)
commonHeadTags =
    [ Head.rssLink "/blog/feed.xml"
    , Head.sitemapLink "/sitemap.xml"
    ]


{-| <https://developer.twitter.com/en/docs/tweets/optimize-with-cards/overview/abouts-cards>
<https://htmlhead.dev>
<https://html.spec.whatwg.org/multipage/semantics.html#standard-metadata-names>
<https://ogp.me/>
-}
head : Metadata -> List (Head.Tag Pages.PathKey)
head metadata =
    commonHeadTags
        ++ (case metadata of
                Metadata.Page meta ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = "elm-pages-starter"
                        , image =
                            { url = images.iconPng
                            , alt = "elm-pages logo"
                            , dimensions = Nothing
                            , mimeType = Nothing
                            }
                        , description = siteTagline
                        , locale = Nothing
                        , title = meta.title
                        }
                        |> Seo.website

                Metadata.Article meta ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = "elm-pages starter"
                        , image =
                            { url = meta.image
                            , alt = meta.description
                            , dimensions = Nothing
                            , mimeType = Nothing
                            }
                        , description = meta.description
                        , locale = Nothing
                        , title = meta.title
                        }
                        |> Seo.article
                            { tags = []
                            , section = Nothing
                            , publishedTime = Just (Date.toIsoString meta.published)
                            , modifiedTime = Nothing
                            , expirationTime = Nothing
                            }

                Metadata.Author meta ->
                    let
                        ( firstName, lastName ) =
                            case meta.name |> String.split " " of
                                [ first, last ] ->
                                    ( first, last )

                                [ first, middle, last ] ->
                                    ( first ++ " " ++ middle, last )

                                [] ->
                                    ( "", "" )

                                _ ->
                                    ( meta.name, "" )
                    in
                    Seo.summary
                        { canonicalUrlOverride = Nothing
                        , siteName = "elm-pages-starter"
                        , image =
                            { url = meta.avatar
                            , alt = meta.name ++ "'s elm-pages articles."
                            , dimensions = Nothing
                            , mimeType = Nothing
                            }
                        , description = meta.bio
                        , locale = Nothing
                        , title = meta.name ++ "'s elm-pages articles."
                        }
                        |> Seo.profile
                            { firstName = firstName
                            , lastName = lastName
                            , username = Nothing
                            }

                Metadata.BlogIndex ->
                    Seo.summaryLarge
                        { canonicalUrlOverride = Nothing
                        , siteName = "elm-pages"
                        , image =
                            { url = images.iconPng
                            , alt = "elm-pages logo"
                            , dimensions = Nothing
                            , mimeType = Nothing
                            }
                        , description = siteTagline
                        , locale = Nothing
                        , title = "elm-pages blog"
                        }
                        |> Seo.website
           )


canonicalSiteUrl : String
canonicalSiteUrl =
    "https://elm-pages-starter.netlify.com"


siteTagline : String
siteTagline =
    "Starter blog for elm-pages"


publishedDateView metadata =
    Element.text
        (metadata.published
            |> Date.format "MMMM ddd, yyyy"
        )


githubRepoLink : Element msg
githubRepoLink =
    Element.newTabLink []
        { url = "https://github.com/dillonkearns/elm-pages"
        , label =
            Element.image
                [ Element.width (Element.px 22)
                , Font.color Palette.color.primary
                ]
                { src = ImagePath.toString Pages.images.github, description = "Github repo" }
        }


elmDocsLink : Element msg
elmDocsLink =
    Element.newTabLink []
        { url = "https://package.elm-lang.org/packages/dillonkearns/elm-pages/latest/"
        , label =
            Element.image
                [ Element.width (Element.px 22)
                , Font.color Palette.color.primary
                ]
                { src = ImagePath.toString Pages.images.elmLogo, description = "Elm Package Docs" }
        }
