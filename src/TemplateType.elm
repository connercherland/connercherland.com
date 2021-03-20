module TemplateType exposing (TemplateType(..), decoder)

import Data.Author
import Date
import Json.Decode as Decode exposing (Decoder)
import Metadata exposing (Article, PageMetadata)
import Pages
import Pages.ImagePath as ImagePath


type TemplateType
    = Page PageMetadata
    | Article PageMetadata


decoder : Decoder TemplateType
decoder =
    Decode.field "type" Decode.string
        |> Decode.andThen
            (\pageType ->
                case pageType of
                    "page" ->
                        Decode.field "title" Decode.string
                            |> Decode.map (\title -> Page { title = title })

                    _ ->
                        Decode.fail ("Unexpected page type " ++ pageType)
            )
