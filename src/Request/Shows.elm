module Request.Shows exposing (..)

import Graphql.Document
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Json.Encode as Encode
import Pages.Secrets as Secrets
import Pages.StaticHttp as StaticHttp
import SanityApi.Object
import SanityApi.Object.Show
import SanityApi.Object.Venue
import SanityApi.Query as Query
import SanityApi.Scalar
import Time


type alias Show =
    { venue : String
    , startTime : Time.Posix
    }


selection : SelectionSet (List Show) RootQuery
selection =
    Query.allShow identity showSelection


showSelection : SelectionSet Show SanityApi.Object.Show
showSelection =
    SelectionSet.map2 Show
        (SanityApi.Object.Show.venue
            (SanityApi.Object.Venue.name
                |> SelectionSet.nonNullOrFail
            )
            |> SelectionSet.nonNullOrFail
        )
        (SanityApi.Object.Show.startTime |> SelectionSet.nonNullOrFail)


graphqlEndpointUrl =
    "https://npr5ilx1.api.sanity.io/v1/graphql/production/default"


staticGraphqlRequest : SelectionSet value RootQuery -> StaticHttp.Request value
staticGraphqlRequest selectionSet =
    StaticHttp.unoptimizedRequest
        (Secrets.succeed
            { url = graphqlEndpointUrl
            , method = "POST"
            , headers = []
            , body =
                StaticHttp.jsonBody
                    (Encode.object
                        [ ( "query"
                          , selectionSet
                                |> Graphql.Document.serializeQuery
                                |> Encode.string
                          )
                        ]
                    )
            }
        )
        (selectionSet
            |> Graphql.Document.decoder
            |> StaticHttp.expectUnoptimizedJson
        )
