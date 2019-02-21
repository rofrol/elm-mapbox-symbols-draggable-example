module GeoJSON exposing (decodedFeature, encodedSampleFeature, geojson, pointsJson, stores)

import Json.Decode as JD
import Json.Decode.Extra exposing (andMap)
import Json.Encode as JE


geojson =
    JD.decodeString JD.value """
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "id": 1,
      "properties": {
        "name": "Bermuda Triangle",
        "area": 1150180
      },
      "geometry": {
        "type": "Polygon",
        "coordinates": [
          [
            [-64.73, 32.31],
            [-80.19, 25.76],
            [-66.09, 18.43],
            [-64.73, 32.31]
          ]
        ]
      }
    }
  ]
}
""" |> Result.withDefault (JE.object [])


storesJson =
    """
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
      "id": 1,
      "geometry": {
        "type": "Point",
        "coordinates": [
          -77.034084142948,
          38.909671288923
        ]
      },
      "properties": {
        "phoneFormatted": "(202) 234-7336",
        "phone": "2022347336",
        "address": "1471 P St NW",
        "city": "Washington DC",
        "country": "United States",
        "crossStreet": "at 15th St NW",
        "postalCode": "20005",
        "state": "D.C."
      }
    },
    {
      "type": "Feature",
      "id": 2,
      "geometry": {
        "type": "Point",
        "coordinates": [
          -77.049766,
          38.900772
        ]
      },
      "properties": {
        "phoneFormatted": "(202) 507-8357",
        "phone": "2025078357",
        "address": "2221 I St NW",
        "city": "Washington DC",
        "country": "United States",
        "crossStreet": "at 22nd St NW",
        "postalCode": "20037",
        "state": "D.C."
      }
    },
    {
      "type": "Feature",
      "id": 3,
      "geometry": {
        "type": "Point",
        "coordinates": [
          -77.043929,
          38.910525
        ]
      },
      "properties": {
        "phoneFormatted": "(202) 387-9338",
        "phone": "2023879338",
        "address": "1512 Connecticut Ave NW",
        "city": "Washington DC",
        "country": "United States",
        "crossStreet": "at Dupont Circle",
        "postalCode": "20036",
        "state": "D.C."
      }
    },
    {
      "type": "Feature",
      "id": 4,
      "geometry": {
        "type": "Point",
        "coordinates": [
          -77.0672,
          38.90516896
        ]
      },
      "properties": {
        "phoneFormatted": "(202) 337-9338",
        "phone": "2023379338",
        "address": "3333 M St NW",
        "city": "Washington DC",
        "country": "United States",
        "crossStreet": "at 34th St NW",
        "postalCode": "20007",
        "state": "D.C."
      }
    },
    {
      "type": "Feature",
      "id": 5,
      "geometry": {
        "type": "Point",
        "coordinates": [
          -77.002583742142,
          38.887041080933
        ]
      },
      "properties": {
        "phoneFormatted": "(202) 547-9338",
        "phone": "2025479338",
        "address": "221 Pennsylvania Ave SE",
        "city": "Washington DC",
        "country": "United States",
        "crossStreet": "btwn 2nd & 3rd Sts. SE",
        "postalCode": "20003",
        "state": "D.C."
      }
    },
    {
      "type": "Feature",
      "id": 6,
      "geometry": {
        "type": "Point",
        "coordinates": [
          -76.933492720127,
          38.99225245786
        ]
      },
      "properties": {
        "address": "8204 Baltimore Ave",
        "city": "College Park",
        "country": "United States",
        "postalCode": "20740",
        "state": "MD"
      }
    },
    {
      "type": "Feature",
      "id": 7,
      "geometry": {
        "type": "Point",
        "coordinates": [
          -77.097083330154,
          38.980979
        ]
      },
      "properties": {
        "phoneFormatted": "(301) 654-7336",
        "phone": "3016547336",
        "address": "4831 Bethesda Ave",
        "cc": "US",
        "city": "Bethesda",
        "country": "United States",
        "postalCode": "20814",
        "state": "MD"
      }
    },
    {
      "type": "Feature",
      "id": 8,
      "geometry": {
        "type": "Point",
        "coordinates": [
          -77.359425054188,
          38.958058116661
        ]
      },
      "properties": {
        "phoneFormatted": "(571) 203-0082",
        "phone": "5712030082",
        "address": "11935 Democracy Dr",
        "city": "Reston",
        "country": "United States",
        "crossStreet": "btw Explorer & Library",
        "postalCode": "20190",
        "state": "VA"
      }
    },
    {
      "type": "Feature",
      "id": 9,
      "geometry": {
        "type": "Point",
        "coordinates": [
          -77.10853099823,
          38.880100922392
        ]
      },
      "properties": {
        "phoneFormatted": "(703) 522-2016",
        "phone": "7035222016",
        "address": "4075 Wilson Blvd",
        "city": "Arlington",
        "country": "United States",
        "crossStreet": "at N Randolph St.",
        "postalCode": "22203",
        "state": "VA"
      }
    },
    {
      "type": "Feature",
      "id": 10,
      "geometry": {
        "type": "Point",
        "coordinates": [
          -75.28784,
          40.008008
        ]
      },
      "properties": {
        "phoneFormatted": "(610) 642-9400",
        "phone": "6106429400",
        "address": "68 Coulter Ave",
        "city": "Ardmore",
        "country": "United States",
        "postalCode": "19003",
        "state": "PA"
      }
    },
    {
      "type": "Feature",
      "id": 11,
      "geometry": {
        "type": "Point",
        "coordinates": [
          -75.20121216774,
          39.954030175164
        ]
      },
      "properties": {
        "phoneFormatted": "(215) 386-1365",
        "phone": "2153861365",
        "address": "3925 Walnut St",
        "city": "Philadelphia",
        "country": "United States",
        "postalCode": "19104",
        "state": "PA"
      }
    },
    {
      "type": "Feature",
      "id": 12,
      "geometry": {
        "type": "Point",
        "coordinates": [
          -77.043959498405,
          38.903883387232
        ]
      },
      "properties": {
        "phoneFormatted": "(202) 331-3355",
        "phone": "2023313355",
        "address": "1901 L St. NW",
        "city": "Washington DC",
        "country": "United States",
        "crossStreet": "at 19th St",
        "postalCode": "20036",
        "state": "D.C."
      }
    }
  ]
}
"""


storesOld =
    JD.decodeString JD.value storesJson |> Result.withDefault (JE.object [])


stores =
    let
        featureCollection =
            JD.decodeString decodeFeatureCollection storesJson |> Result.withDefault emptyFeatureCollection
    in
    encodeFeatureCollection featureCollection


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
          -77.043959498405,
          38.903883387232
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
            [ -77.043959498405
            , 38.903883387232
            ]
        )
        (JE.object [])


encodedSampleFeature =
    encodeFeature sampleFeature


decodedFeature =
    Result.withDefault emptyFeature <|
        JD.decodeString decodeFeature sampleFeatureJson


pointsJson lng ltd =
    """
{
    "type": "FeatureCollection",
    "features": [{
        "type": "Feature",
        "id": 1,
        "geometry": {
            "type": "Point",
            "coordinates": ["""
        ++ String.fromInt lng
        ++ ","
        ++ String.fromInt ltd
        ++ """]
        }
    }]
}
"""
        |> JD.decodeString JD.value
        |> Result.withDefault (JE.object [])
