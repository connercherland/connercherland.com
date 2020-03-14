module Layout exposing (view)

import FontAwesome as Fa
import Html exposing (..)
import Html.Attributes as Attr exposing (class)
import Html.Events
import MenuSvg
import Pages exposing (pages)
import Pages.PagePath as PagePath


view : { model | menuOpen : Bool } -> msg -> List (Html msg) -> Html msg
view model toggleMenuMsg main =
    Html.div [ Attr.id "body", class "font-body bg-gray-100 min-h-screen flex flex-col" ]
        [ Html.nav
            [ Attr.class "flex font-display items-center justify-between flex-wrap bg-gray-900 p-6"
            ]
            [ div [ class "flex items-center flex-shrink-0 text-white mr-6" ]
                [ span [ class "uppercase font-semibold text-xl tracking-tight" ] [ text "Conner Cherland" ]
                ]
            , div [ class "block lg:hidden" ]
                [ button
                    [ Html.Events.onClick toggleMenuMsg, class "flex items-center px-3 py-2 border rounded text-white border-gray-400 hover:text-white hover:border-white" ]
                    [ MenuSvg.view ]
                ]
            , div [ Attr.classList [ ( "hidden", not model.menuOpen ) ], class "w-full block lg:flex lg:items-center lg:w-auto text-lg" ]
                [ a [ class "block mt-4 lg:inline-block lg:mt-0 text-white hover:text-white mr-4", Attr.href "#responsive-header" ]
                    [ text "Bio" ]
                , a [ class "block mt-4 lg:inline-block lg:mt-0 text-white hover:text-white mr-4", Attr.href "#responsive-header" ]
                    [ text "Music" ]
                , a [ class "block mt-4 lg:inline-block lg:mt-0 text-white hover:text-white mr-4", Attr.href "https://conner-cherland.square.site/", Attr.target "_blank" ]
                    [ text "Store" ]
                , a [ class "block mt-4 lg:inline-block lg:mt-0 text-white hover:text-white mr-4", Attr.href "#responsive-header" ]
                    [ text "Reviews" ]
                , a [ class "block mt-4 lg:inline-block lg:mt-0 text-white hover:text-white mr-4", Attr.href (PagePath.toString Pages.pages.dates.index) ]
                    [ text "Dates" ]
                , button
                    [ class "block mt-4 lg:mt-0 bg-white lg:inline-block hover:bg-gray-200 text-gray-800 font-semibold py-2 px-4 border border-gray-400 rounded shadow-lg font-display"
                    , Attr.href "#"
                    ]
                    [ text "Plan Your Event" ]
                ]
            ]
        , div [ class "md:flex flex-grow" ] main
        , Html.footer
            [ Attr.class "flex font-display justify-center flex-wrap bg-gray-900 p-6"
            ]
            [ icons ]
        ]


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
