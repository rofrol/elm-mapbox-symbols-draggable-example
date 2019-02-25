module GeoJSON exposing (Feature, FeatureCollection, Geometry, decodeGeometry, decodedFeature, emptyGeometry, encodeFeatureCollection, storesFeatures)

import Json.Decode as JD
import Json.Decode.Extra exposing (andMap)
import Json.Encode as JE


type alias Geometry =
    { type_ : String
    , coordinates : List Float
    }


emptyGeometry =
    Geometry "" []


decodeGeometry =
    JD.succeed Geometry
        |> andMap (JD.field "type" JD.string)
        |> andMap (JD.field "coordinates" (JD.list JD.float))


encodeGeometry geometry =
    JE.object
        [ ( "type", JE.string geometry.type_ )
        , ( "coordinates", JE.list JE.float geometry.coordinates )
        ]


type alias Feature =
    { type_ : String
    , id : Int
    , geometry : Geometry
    , properties : JD.Value
    }


emptyFeature =
    Feature "" 0 emptyGeometry (JE.object [])


encodeFeature feature =
    JE.object
        [ ( "type", JE.string feature.type_ )
        , ( "id", JE.int feature.id )
        , ( "geometry", encodeGeometry feature.geometry )
        , ( "properties", feature.properties )
        ]


decodeFeature =
    JD.succeed Feature
        |> andMap (JD.field "type" JD.string)
        |> andMap (JD.field "id" JD.int)
        |> andMap (JD.field "geometry" decodeGeometry)
        |> andMap (JD.field "properties" JD.value)


type alias FeatureCollection =
    { type_ : String
    , features : List Feature
    }


decodeFeatureCollection =
    JD.succeed FeatureCollection
        |> andMap (JD.field "type" JD.string)
        |> andMap (JD.field "features" (JD.list decodeFeature))


encodeFeatureCollection featureCollection =
    JE.object
        [ ( "type", JE.string featureCollection.type_ )
        , ( "features", JE.list encodeFeature featureCollection.features )
        ]


emptyFeatureCollection =
    FeatureCollection "FeatureCollection" []


sampleFeatureJson =
    """
{
      "type": "Feature",
      "id": 12,
      "geometry": {
        "type": "Point",
        "coordinates": [
          21.024688,
          52.068688
        ]
      },
      "properties": {}
}
"""


sampleFeature =
    Feature
        "Feature"
        12
        (Geometry
            "Point"
            [ 21.024688
            , 52.068688
            ]
        )
        (JE.object [])


storesFeatures =
    [ Feature
        "Feature"
        1
        (Geometry
            "Point"
            [ 21.024688
            , 52.068688
            ]
        )
        (JE.object [])
    , Feature
        "Feature"
        2
        (Geometry
            "Point"
            [ 21.022688
            , 52.068688
            ]
        )
        (JE.object [])
    ]


encodedSampleFeature =
    encodeFeature sampleFeature


decodedFeature =
    Result.withDefault emptyFeature <|
        JD.decodeString decodeFeature sampleFeatureJson
