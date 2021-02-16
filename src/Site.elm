module Site exposing (canonicalUrl, config, tagline)

--import Cloudinary

import Cloudinary
import Color
import MimeType
import Pages exposing (images, pages)
import Pages.ImagePath exposing (ImagePath)
import Pages.Manifest as Manifest
import Pages.Manifest.Category
import Pages.PagePath exposing (PagePath)
import Pages.StaticHttp as StaticHttp
import TemplateType exposing (TemplateType)


type alias SiteConfig =
    { canonicalUrl : String
    , manifest : Manifest.Config Pages.PathKey
    }


config : SiteConfig
config =
    { canonicalUrl = canonicalUrl
    , manifest = manifest
    }


type alias StaticData =
    ()


staticData :
    List ( PagePath Pages.PathKey, TemplateType )
    -> StaticHttp.Request StaticData
staticData siteMetadata =
    StaticHttp.succeed ()


canonicalUrl : String
canonicalUrl =
    "https://connercherland.netlify.app"


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
    , shortName = Just "Conner Cherland"
    , sourceIcon = images.iconPng
    , icons =
        [ icon webp 192
        , icon webp 512
        , icon MimeType.Png 192
        , icon MimeType.Png 512
        ]
    }


tagline : String
tagline =
    "Conner Cherland Music"


webp : MimeType.MimeImage
webp =
    MimeType.OtherImage "webp"


icon :
    MimeType.MimeImage
    -> Int
    -> Manifest.Icon pathKey
icon format width =
    { src = cloudinaryIcon format width
    , sizes = [ ( width, width ) ]
    , mimeType = format |> Just
    , purposes = [ Manifest.IconPurposeAny, Manifest.IconPurposeMaskable ]
    }


cloudinaryIcon :
    MimeType.MimeImage
    -> Int
    -> ImagePath pathKey
cloudinaryIcon mimeType width =
    Cloudinary.urlSquare "v1613279618/d2c8ce93487154e6ba130d9d590171ce_v155te.png" (Just mimeType) width
