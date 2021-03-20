module TailwindMarkdownRenderer exposing (renderMarkdown)

import Css
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attr exposing (class, css)
import Markdown.Block as Block exposing (Block)
import Markdown.Html
import Markdown.Parser as Markdown
import Markdown.Renderer
import Tailwind.Breakpoints as Bp
import Tailwind.Utilities as Tw



--render : Markdown.Renderer.Renderer view -> String -> Result String view


render renderer markdown =
    markdown
        |> Markdown.parse
        |> Result.mapError deadEndsToString
        |> Result.andThen (\ast -> Markdown.Renderer.render renderer ast)


deadEndsToString deadEnds =
    deadEnds
        |> List.map Markdown.deadEndToString
        |> String.join "\n"


renderMarkdown : String -> Result String (List (Html msg))
renderMarkdown markdown =
    markdown
        |> render
            { heading =
                \{ level, children } ->
                    case level of
                        Block.H1 ->
                            Html.h1 [] children

                        Block.H2 ->
                            Html.h2 [ css [ Tw.text_3xl ] ] children

                        Block.H3 ->
                            Html.h3 [ css [ Tw.text_2xl ] ] children

                        Block.H4 ->
                            Html.h4 [] children

                        Block.H5 ->
                            Html.h5 [] children

                        Block.H6 ->
                            Html.h6 [] children
            , paragraph = Html.p [ css [ Tw.mb_4 ] ]
            , hardLineBreak = Html.br [] []
            , blockQuote =
                Html.blockquote
                    [ css
                        [ Tw.p_0
                        , Tw.p_2
                        , Tw.mx_6
                        , Tw.bg_darkGray
                        , Tw.mb_4
                        , Tw.border_l_4
                        , Tw.border_darkGray
                        , Tw.italic
                        ]
                    ]
            , strong =
                \children -> Html.strong [ css [ Tw.font_bold ] ] children
            , emphasis =
                \children -> Html.em [ css [ Tw.italic ] ] children
            , codeSpan =
                \content -> Html.code [] [ Html.text content ]
            , link =
                \link content ->
                    case link.title of
                        Just title ->
                            Html.a
                                [ Attr.href link.destination
                                , Attr.title title
                                , css
                                    [ Tw.text_highlight
                                    , Css.hover
                                        [ Tw.underline
                                        ]
                                    , Css.property "overflow-wrap" "anywhere"
                                    ]
                                ]
                                content

                        Nothing ->
                            Html.a
                                [ Attr.href link.destination
                                , css
                                    [ Tw.text_highlight
                                    , Css.hover [ Tw.underline ]
                                    , Css.property "overflow-wrap" "anywhere"
                                    ]
                                ]
                                content
            , image =
                \imageInfo ->
                    case imageInfo.title of
                        Just title ->
                            Html.img
                                [ Attr.src imageInfo.src
                                , Attr.alt imageInfo.alt
                                , Attr.title title
                                ]
                                []

                        Nothing ->
                            Html.img
                                [ Attr.src imageInfo.src
                                , Attr.alt imageInfo.alt
                                ]
                                []
            , text =
                Html.text
            , unorderedList =
                \items ->
                    Html.ul
                        [ css
                            [ Tw.list_disc
                            , Tw.ml_4
                            ]
                        ]
                        (items
                            |> List.map
                                (\item ->
                                    case item of
                                        Block.ListItem task children ->
                                            let
                                                checkbox =
                                                    case task of
                                                        Block.NoTask ->
                                                            Html.text ""

                                                        Block.IncompleteTask ->
                                                            Html.input
                                                                [ Attr.disabled True
                                                                , Attr.checked False
                                                                , Attr.type_ "checkbox"
                                                                ]
                                                                []

                                                        Block.CompletedTask ->
                                                            Html.input
                                                                [ Attr.disabled True
                                                                , Attr.checked True
                                                                , Attr.type_ "checkbox"
                                                                ]
                                                                []
                                            in
                                            Html.li [] (checkbox :: children)
                                )
                        )
            , orderedList =
                \startingIndex items ->
                    Html.ol
                        (if startingIndex /= 1 then
                            [ Attr.start startingIndex
                            , css
                                [ Tw.mb_4
                                , Tw.ml_8
                                ]
                            ]

                         else
                            [ css
                                [ Tw.mb_4
                                , Tw.ml_8
                                ]
                            ]
                        )
                        (items
                            |> List.map
                                (\itemBlocks ->
                                    Html.li []
                                        itemBlocks
                                )
                        )
            , html =
                Markdown.Html.oneOf []
            , codeBlock =
                \{ body, language } ->
                    Html.div []
                        [ Html.code []
                            [ Html.text body
                            ]
                        ]
            , thematicBreak = Html.hr [] []
            , table = Html.table []
            , tableHeader = Html.thead []
            , tableBody = Html.tbody []
            , tableRow = Html.tr []
            , tableHeaderCell =
                \maybeAlignment ->
                    let
                        attrs =
                            maybeAlignment
                                |> Maybe.map
                                    (\alignment ->
                                        case alignment of
                                            Block.AlignLeft ->
                                                "left"

                                            Block.AlignCenter ->
                                                "center"

                                            Block.AlignRight ->
                                                "right"
                                    )
                                |> Maybe.map Attr.align
                                |> Maybe.map List.singleton
                                |> Maybe.withDefault []
                    in
                    Html.th attrs
            , tableCell = \maybeAlignment -> Html.td []
            }



--|> Result.map (List.map (Html.toString 0))
--|> Result.map (String.join "")
--htmlRenderer : Markdown.Html.Renderer (List (Html.Html msg) -> Html.Html msg)
--htmlRenderer =
--passthrough
--    (\tag attributes blocks ->
--        let
--            result : Result String (List (Html.Html msg) -> Html.Html msg)
--            result =
--                (\children ->
--                    Html.node tag htmlAttributes children
--                )
--                    |> Ok
--
--            htmlAttributes : List (Html.Attribute msg)
--            htmlAttributes =
--                attributes
--                    |> List.map
--                        (\{ name, value } ->
--                            Attr.attribute name value
--                        )
--        in
--        result
--    )


passThroughNode nodeName =
    Markdown.Html.tag nodeName
        (\id class href children ->
            Html.node nodeName
                ([ id |> Maybe.map Attr.id
                 , class |> Maybe.map Attr.class
                 , href |> Maybe.map Attr.href
                 ]
                    |> List.filterMap identity
                )
                children
        )
        |> Markdown.Html.withOptionalAttribute "id"
        |> Markdown.Html.withOptionalAttribute "class"
        |> Markdown.Html.withOptionalAttribute "href"



--{-| TODO come up with an API to provide a solution to do this sort of thing publicly
---}
--passthrough : (String -> List Markdown.HtmlRenderer.Attribute -> List Block -> Result String view) -> Markdown.HtmlRenderer.HtmlRenderer view
--passthrough renderFn =
--    Markdown.HtmlRenderer.HtmlRenderer renderFn
