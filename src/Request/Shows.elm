module Request.Shows exposing (..)

import Graphql.Document
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import Json.Encode as Encode
import Pages.Secrets as Secrets
import Pages.StaticHttp as StaticHttp
import SanityApi.Object
import SanityApi.Object.Show
import SanityApi.Query as Query
import SanityApi.Scalar


type alias Show =
    { startTime : SanityApi.Scalar.DateTime }


selection : SelectionSet (List Show) RootQuery
selection =
    Query.allShow identity showSelection


showSelection : SelectionSet Show SanityApi.Object.Show
showSelection =
    SanityApi.Object.Show.startTime
        |> SelectionSet.nonNullOrFail
        |> SelectionSet.map Show


staticRequest : SelectionSet value RootQuery -> StaticHttp.Request value
staticRequest selectionSet =
    StaticHttp.unoptimizedRequest
        (Secrets.succeed
            { url = "https://npr5ilx1.api.sanity.io/v1/graphql/production/default"
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
