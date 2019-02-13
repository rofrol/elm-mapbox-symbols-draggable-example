module Main exposing (main)

-- from https://github.com/gampleman/elm-mapbox/blob/master/examples/Example01.elm

import Browser
import Html exposing (div, text)
import Html.Attributes as Attrs
import Json.Decode
import Json.Encode
import LngLat exposing (LngLat)
import MapCommands
import Mapbox.Cmd.Option as Opt
import Mapbox.Element exposing (..)
import Mapbox.Expression as E exposing (false, float, int, str, true)
import Mapbox.Layer as Layer
import Mapbox.Source as Source
import Mapbox.Style as Style exposing (Style(..))


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \m -> Sub.none
        }


init () =
    ( { position = LngLat 0 0, features = [] }, Cmd.none )


type Msg
    = Hover EventData
    | Click EventData


update msg model =
    case msg of
        Hover { lngLat, renderedFeatures } ->
            ( { model | position = lngLat, features = renderedFeatures }, Cmd.none )

        Click { lngLat, renderedFeatures } ->
            ( { model | position = lngLat, features = renderedFeatures }, MapCommands.fitBounds [ Opt.linear True, Opt.maxZoom 10 ] ( LngLat.map (\a -> a - 0.2) lngLat, LngLat.map (\a -> a + 0.2) lngLat ) )


geojson =
    Json.Decode.decodeString Json.Decode.value """
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
""" |> Result.withDefault (Json.Encode.object [])


geojson2 =
    Json.Decode.decodeString Json.Decode.value """
{
  "type": "FeatureCollection",
  "features": [
    {
      "type": "Feature",
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
""" |> Result.withDefault (Json.Encode.object [])


hoveredFeatures : List Json.Encode.Value -> MapboxAttr msg
hoveredFeatures =
    List.map (\feat -> ( feat, [ ( "hover", Json.Encode.bool True ) ] ))
        >> featureState


view model =
    { title = "Mapbox Example"
    , body =
        [ css
        , div [ Attrs.style "width" "100vw", Attrs.style "height" "100vh" ]
            [ map
                [ maxZoom 24
                , onMouseMove Hover
                , onClick Click
                , id "my-map"
                , eventFeaturesLayers [ "changes" ]
                , hoveredFeatures model.features
                ]
                style
            , div [ Attrs.style "position" "absolute", Attrs.style "bottom" "20px", Attrs.style "left" "20px" ] [ text (LngLat.toString model.position) ]
            ]
        ]
    }


style : Style
style =
    Style
        { transition = Style.defaultTransition
        , light = Style.defaultLight
        , sources =
            [ Source.vectorFromUrl "composite" "mapbox://mapbox.mapbox-terrain-v2,mapbox.mapbox-streets-v7"
            , Source.geoJSONFromValue "changes" [] geojson2
            ]
        , misc =
            [ Style.name "light"
            , Style.defaultCenter <| LngLat -77.034084 38.909671
            , Style.defaultZoomLevel 14
            , Style.sprite "mapbox://sprites/mapbox/light-v10"
            , Style.glyphs "mapbox://fonts/mapbox/{fontstack}/{range}.pbf"
            ]
        , layers = layers
        }


layers =
    [ Layer.background "background"
        [ E.rgba 246 246 244 1 |> Layer.backgroundColor
        ]
    , Layer.fill "landcover"
        "composite"
        [ Layer.sourceLayer "landcover"
        , E.any
            [ E.getProperty (str "class") |> E.isEqual (str "wood")
            , E.getProperty (str "class") |> E.isEqual (str "scrub")
            , E.getProperty (str "class") |> E.isEqual (str "grass")
            , E.getProperty (str "class") |> E.isEqual (str "crop")
            ]
            |> Layer.filter
        , Layer.fillColor (E.rgba 227 227 227 1)
        , Layer.fillOpacity (float 0.6)
        ]
    , Layer.symbol "place-city-lg-n"
        "composite"
        [ Layer.sourceLayer "place_label"
        , Layer.minzoom 1
        , Layer.maxzoom 24
        , Layer.filter <|
            E.all
                [ E.getProperty (str "scalerank") |> E.greaterThan (int 2)
                , E.getProperty (str "type") |> E.isEqual (str "city")
                ]
        , Layer.textField <|
            E.format
                [ E.getProperty (str "name_en")
                    |> E.formatted
                    |> E.fontScaledBy (float 1.2)
                , E.formatted (str "\n")
                , E.getProperty (str "name")
                    |> E.formatted
                    |> E.fontScaledBy (float 0.8)
                    |> E.withFont (E.strings [ "DIN Offc Pro Medium" ])
                ]
        ]
    , Layer.fill "changes"
        "changes"
        [ Layer.fillOpacity (E.ifElse (E.toBool (E.featureState (str "hover"))) (float 0.9) (float 0.1))
        ]
    , Layer.fill "national-park"
        "composite"
        [ Layer.sourceLayer "landuse_overlay"
        , Layer.minzoom 5
        , Layer.filter (E.getProperty (str "class") |> E.isEqual (str "national_park"))
        , Layer.fillColor (E.rgba 236 238 237 1)
        , Layer.fillOpacity
            (E.zoom
                |> E.interpolate E.Linear
                    [ ( 5, float 0 )
                    , ( 6, float 0.5 )
                    ]
            )
        ]
    , Layer.fill "landuse"
        "composite"
        [ Layer.sourceLayer "landuse"
        , Layer.minzoom 5

        -- , Layer.filter (Debug.todo "The expression [" match ",[" get "," class "],[" park "," airport "," glacier "," pitch "," sand "],true,false] is not yet supported")
        , Layer.fillOpacity
            (E.zoom
                |> E.interpolate E.Linear
                    [ ( 5, float 0 )
                    , ( 6, E.getProperty (str "class") |> E.matchesStr [ ( "glacier", float 0.5 ) ] (float 1) )
                    ]
            )
        , Layer.fillColor (E.rgba 236 238 237 1)
        ]
    , Layer.fill "water-shadow"
        "composite"
        [ Layer.sourceLayer "water"
        , Layer.fillTranslateAnchor E.anchorViewport
        , Layer.fillTranslate
            (E.zoom
                |> E.interpolate (E.Exponential 1.2)
                    [ ( 7
                      , E.floats
                            [ 0
                            , 0
                            ]
                      )
                    , ( 16
                      , E.floats
                            [ -1
                            , -1
                            ]
                      )
                    ]
            )
        , Layer.fillColor (E.rgba 181 190 190 1)
        ]
    , Layer.fill "water"
        "composite"
        [ Layer.sourceLayer "water"
        , Layer.fillColor (E.rgba 202 210 210 1)
        ]
    , Layer.fill "hillshade"
        "composite"
        [ Layer.sourceLayer "hillshade"
        , Layer.maxzoom 16
        , Layer.fillColor (E.getProperty (str "class") |> E.matchesStr [ ( "shadow", E.rgba 89 89 89 1 ) ] (E.rgba 255 255 255 1))
        , Layer.fillOpacity
            (E.zoom
                |> E.interpolate E.Linear
                    [ --( 14, Debug.todo "The expression [" match ",[" get "," level "],[67,56],0.06,[89,78],0.03,0.04] is not yet supported" )
                      --,
                      ( 16, float 0 )
                    ]
            )
        , Layer.fillAntialias false
        ]
    , Layer.fill "land-structure-polygon"
        "composite"
        [ Layer.sourceLayer "structure"
        , Layer.minzoom 13

        --, Layer.filter (E.all (E.geometryType |> E.isEqual (str "Polygon")) (E.getProperty (str "class") |> E.isEqual (str "land")))
        , Layer.fillColor (E.rgba 239 244 242 1)
        ]
    , Layer.line "land-structure-line"
        "composite"
        [ Layer.sourceLayer "structure"
        , Layer.minzoom 13

        --, Layer.filter (E.all (E.geometryType |> E.isEqual (str "LineString")) (E.getProperty (str "class") |> E.isEqual (str "land")))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.99)
                    [ ( 14, float 0.75 )
                    , ( 20, float 40 )
                    ]
            )
        , Layer.lineColor (E.rgba 239 244 242 1)
        , Layer.lineCap E.lineCapRound
        ]
    , Layer.fill "aeroway-polygon"
        "composite"
        [ Layer.sourceLayer "aeroway"
        , Layer.minzoom 11

        --, (Layer.filter ((E.all ((((E.geometryType)) |> (E.isEqual ((str "Polygon"))))) (((Debug.todo "The expression ["match",["get","type"],["runway","taxiway","helipad"],true,false] is not yet supported"))))))
        , Layer.fillOpacity
            (E.zoom
                |> E.interpolate E.Linear
                    [ ( 11, float 0 )
                    , ( 11.5, float 1 )
                    ]
            )
        , Layer.fillColor (E.rgba 247 247 247 1)
        ]
    , Layer.line "aeroway-line"
        "composite"
        [ Layer.sourceLayer "aeroway"
        , Layer.minzoom 9
        , Layer.filter (E.geometryType |> E.isEqual (str "LineString"))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 9
                      , E.getProperty (str "type")
                            |> E.matchesStr
                                [ ( "runway", float 1 )
                                , ( "taxiway", float 0.5 )
                                ]
                                (float 0.5)
                      )
                    , ( 18
                      , E.getProperty (str "type")
                            |> E.matchesStr
                                [ ( "runway", float 80 )
                                , ( "taxiway", float 20 )
                                ]
                                (float 20)
                      )
                    ]
            )
        , Layer.lineColor (E.rgba 247 247 247 1)
        ]
    , Layer.line "building-outline"
        "composite"
        [ Layer.sourceLayer "building"
        , Layer.minzoom 15

        -- , Layer.filter (E.all (E.getProperty (str "type") |> E.notEqual (str "building:part")) (E.getProperty (str "underground") |> E.isEqual (str "false")))
        , Layer.lineColor (E.rgba 222 222 220 1)
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 15, float 0.75 )
                    , ( 20, float 3 )
                    ]
            )
        , Layer.lineOpacity
            (E.zoom
                |> E.interpolate E.Linear
                    [ ( 15, float 0 )
                    , ( 16, float 1 )
                    ]
            )
        ]
    , Layer.fill "building"
        "composite"
        [ Layer.sourceLayer "building"
        , Layer.minzoom 15

        --, Layer.filter (E.all (E.getProperty (str "type") |> E.notEqual (str "building:part")) (E.getProperty (str "underground") |> E.isEqual (str "false")))
        , Layer.fillOutlineColor (E.rgba 222 222 220 1)
        , Layer.fillOpacity
            (E.zoom
                |> E.interpolate E.Linear
                    [ ( 15, float 0 )
                    , ( 16, float 1 )
                    ]
            )
        , Layer.fillColor (E.rgba 233 233 230 1)
        ]
    , Layer.line "tunnel-street-minor-low"
        "composite"
        [ --(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855769305.6016"} is not yet supported"))))
          --,
          Layer.sourceLayer "road"
        , Layer.minzoom 13

        --, Layer.filter (E.all (E.getProperty (str "structure") |> E.isEqual (str "tunnel")) (E.zoom |> E.step (Debug.todo "The expression [" match ",[" get "," class "],[" street "," street_limited "," track "," primary_link "],true,false] is not yet supported") [ ( 14, Debug.todo "The expression [" match ",[" get "," class "],[" street "," street_limited "," track "," primary_link "," secondary_link "," tertiary_link "," service "],true,false] is not yet supported" ) ]) (E.geometryType |> E.isEqual (str "LineString")))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 12, float 0.5 )

                    --, ( 14, Debug.todo "The expression [" match ",[" get "," class "],[" street "," street_limited "," primary_link "],2," track ",1,0.5] is not yet supported" )
                    --, ( 18, Debug.todo "The expression [" match ",[" get "," class "],[" street "," street_limited "," primary_link "],18,12] is not yet supported" )
                    ]
            )
        , Layer.lineColor (E.rgba 222 226 226 1)
        , Layer.lineOpacity (E.zoom |> E.step (float 1) [ ( 14, float 0 ) ])
        , Layer.lineCap E.lineCapRound

        --, Layer.lineJoin E.lineCapRound
        ]
    , Layer.line "tunnel-construction"
        "composite"
        [ --(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855769305.6016"} is not yet supported"))))
          --,
          Layer.sourceLayer "road"
        , Layer.minzoom 14

        --, Layer.filter (E.all (E.getProperty (str "structure") |> E.isEqual (str "tunnel")) (E.getProperty (str "class") |> E.isEqual (str "construction")) (E.geometryType |> E.isEqual (str "LineString")))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 14, float 2 )
                    , ( 18, float 18 )
                    ]
            )
        , Layer.lineColor (E.rgba 222 226 226 1)
        , Layer.lineDasharray
            (E.zoom
                |> E.step
                    (E.floats
                        [ 0.4
                        , 0.8
                        ]
                    )
                    [ ( 15
                      , E.floats
                            [ 0.3
                            , 0.6
                            ]
                      )
                    , ( 16
                      , E.floats
                            [ 0.2
                            , 0.3
                            ]
                      )
                    , ( 17
                      , E.floats
                            [ 0.2
                            , 0.25
                            ]
                      )
                    , ( 18
                      , E.floats
                            [ 0.15
                            , 0.15
                            ]
                      )
                    ]
            )
        ]
    , Layer.line "tunnel-path"
        "composite"
        [ --(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855769305.6016"} is not yet supported"))))
          --,
          Layer.sourceLayer "road"
        , Layer.minzoom 13

        --, Layer.filter (E.all (E.getProperty (str "structure") |> E.isEqual (str "tunnel")) (E.getProperty (str "class") |> E.isEqual (str "path")) (E.getProperty (str "type") |> E.notEqual (str "steps")) (E.geometryType |> E.isEqual (str "LineString")))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 15, float 1 )
                    , ( 18, float 4 )
                    ]
            )
        , Layer.lineDasharray
            (E.zoom
                |> E.step
                    (E.floats
                        [ 1
                        , 0
                        ]
                    )
                    [ ( 15
                      , E.floats
                            [ 1.75
                            , 1
                            ]
                      )
                    , ( 16
                      , E.floats
                            [ 1
                            , 0.75
                            ]
                      )
                    , ( 17
                      , E.floats
                            [ 1
                            , 0.5
                            ]
                      )
                    ]
            )
        , Layer.lineColor (E.rgba 216 216 216 1)

        --, Layer.lineJoin E.lineCapRound
        ]
    , Layer.line "tunnel-steps"
        "composite"
        [ --(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855769305.6016"} is not yet supported"))))
          --,
          Layer.sourceLayer "road"
        , Layer.minzoom 14

        --, Layer.filter (E.all (E.getProperty (str "structure") |> E.isEqual (str "tunnel")) (E.getProperty (str "class") |> E.isEqual (str "steps")) (E.geometryType |> E.isEqual (str "LineString")))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 15, float 1 )
                    , ( 16, float 1.6 )
                    , ( 18, float 6 )
                    ]
            )
        , Layer.lineColor (E.rgba 216 216 216 1)
        , Layer.lineDasharray
            (E.zoom
                |> E.step
                    (E.floats
                        [ 1
                        , 0
                        ]
                    )
                    [ ( 15
                      , E.floats
                            [ 1.75
                            , 1
                            ]
                      )
                    , ( 16
                      , E.floats
                            [ 1
                            , 0.75
                            ]
                      )
                    , ( 17
                      , E.floats
                            [ 0.3
                            , 0.3
                            ]
                      )
                    ]
            )

        --, Layer.lineJoin E.lineCapRound
        ]
    , Layer.line "tunnel-major-link"
        "composite"
        [ --(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855769305.6016"} is not yet supported"))))
          --,
          Layer.sourceLayer "road"
        , Layer.minzoom 13

        --, Layer.filter (E.all (E.getProperty (str "structure") |> E.isEqual (str "tunnel")) (Debug.todo "The expression [" match ",[" get "," class "],[" motorway_link "," trunk_link "],true,false] is not yet supported") (E.geometryType |> E.isEqual (str "LineString")))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 12, float 0.5 )
                    , ( 14, float 2 )
                    , ( 18, float 18 )
                    ]
            )
        , Layer.lineColor (E.rgba 222 226 226 1)
        , Layer.lineCap E.lineCapRound

        --, Layer.lineJoin E.lineCapRound
        ]
    , Layer.line "tunnel-pedestrian"
        "composite"
        [ --(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855769305.6016"} is not yet supported"))))
          --,
          Layer.sourceLayer "road"
        , Layer.minzoom 13

        --, (Layer.filter ((E.all ((((E.getProperty ((str "structure")))) |> (E.isEqual ((str "tunnel"))))) ((((E.getProperty ((str "class")))) |> (E.isEqual ((str "pedestrian"))))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 14, float 0.5 )
                    , ( 18, float 12 )
                    ]
            )
        , Layer.lineColor (E.rgba 222 226 226 1)
        , Layer.lineDasharray
            (E.zoom
                |> E.step
                    (E.floats
                        [ 1
                        , 0
                        ]
                    )
                    [ ( 15
                      , E.floats
                            [ 1.5
                            , 0.4
                            ]
                      )
                    , ( 16
                      , E.floats
                            [ 1
                            , 0.2
                            ]
                      )
                    ]
            )

        --, Layer.lineJoin E.lineCapRound
        ]
    , Layer.line "tunnel-street-minor"
        "composite"
        [ --(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855769305.6016"} is not yet supported"))))
          --,
          Layer.sourceLayer "road"
        , Layer.minzoom 13

        --, Layer.filter (E.all (E.getProperty (str "structure") |> E.isEqual (str "tunnel")) (E.zoom |> E.step (Debug.todo "The expression [" match ",[" get "," class "],[" street "," street_limited "," track "," primary_link "],true,false] is not yet supported") [ ( 14, Debug.todo "The expression [" match ",[" get "," class "],[" street "," street_limited "," track "," primary_link "," secondary_link "," tertiary_link "," service "],true,false] is not yet supported" ) ]) (E.geometryType |> E.isEqual (str "LineString")))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 12, float 0.5 )

                    --, ( 14, Debug.todo "The expression [" match ",[" get "," class "],[" street "," street_limited "," primary_link "],2," track ",1,0.5] is not yet supported" )
                    --, ( 18, Debug.todo "The expression [" match ",[" get "," class "],[" street "," street_limited "," primary_link "],18,12] is not yet supported" )
                    ]
            )
        , Layer.lineColor (E.rgba 222 226 226 1)
        , Layer.lineOpacity (E.zoom |> E.step (float 0) [ ( 14, float 1 ) ])
        , Layer.lineCap E.lineCapRound

        --, Layer.lineJoin E.lineCapRound
        ]
    , Layer.line "tunnel-motorway-trunk"
        "composite"
        [ --(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855769305.6016"} is not yet supported"))))
          --,
          Layer.sourceLayer "road"
        , Layer.minzoom 13

        --, Layer.filter (E.all (E.getProperty (str "structure") |> E.isEqual (str "tunnel")) (Debug.todo "The expression [" match ",[" get "," class "],[" motorway "," trunk "],true,false] is not yet supported") (E.geometryType |> E.isEqual (str "LineString")))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 5, float 0.75 )
                    , ( 18, float 32 )
                    ]
            )
        , Layer.lineColor (E.rgba 222 226 226 1)
        , Layer.lineCap E.lineCapRound

        --, Layer.lineJoin E.lineCapRound
        ]
    , Layer.line "road-pedestrian-case"
        "composite"
        [ --(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855786460.0557"} is not yet supported"))))
          --,
          Layer.sourceLayer "road"
        , Layer.minzoom 12

        --, Layer.filter (E.all (E.getProperty (str "class") |> E.isEqual (str "pedestrian")) (Debug.todo "The expression [" match ",[" get "," structure "],[" none "," ford "],true,false] is not yet supported") (E.geometryType |> E.isEqual (str "LineString")))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 14, float 2 )
                    , ( 18, float 14.5 )
                    ]
            )
        , Layer.lineColor (E.rgba 232 237 235 1)
        , Layer.lineOpacity (E.zoom |> E.step (float 0) [ ( 14, float 1 ) ])

        --, Layer.lineJoin E.lineCapRound
        ]
    , Layer.line "road-minor-low"
        "composite"
        [ --(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855786460.0557"} is not yet supported"))))
          --,
          Layer.sourceLayer "road"
        , Layer.minzoom 13

        --, Layer.filter (E.all (E.zoom |> E.step (E.getProperty (str "class") |> E.isEqual (str "track")) [ ( 14, Debug.todo "The expression [" match ",[" get "," class "],[" track "," secondary_link "," tertiary_link "," service "],true,false] is not yet supported" ) ]) (Debug.todo "The expression [" match ",[" get "," structure "],[" none "," ford "],true,false] is not yet supported") (E.geometryType |> E.isEqual (str "LineString")))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 14, E.getProperty (str "class") |> E.matchesStr [ ( "track", float 1 ) ] (float 0.5) )
                    , ( 18, float 12 )
                    ]
            )
        , Layer.lineColor (E.rgba 255 255 255 1)
        , Layer.lineOpacity (E.zoom |> E.step (float 1) [ ( 14, float 0 ) ])
        , Layer.lineCap E.lineCapRound

        --, Layer.lineJoin E.lineCapRound
        ]
    , Layer.line "road-street-low"
        "composite"
        [ --(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855786460.0557"} is not yet supported"))))
          -- ,
          Layer.sourceLayer "road"
        , Layer.minzoom 11

        --, (Layer.filter ((E.all (((Debug.todo "The expression ["match",["get","class"],["street","street_limited","primary_link"],true,false] is not yet supported"))) (((Debug.todo "The expression ["match",["get","structure"],["none","ford"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 12, float 0.5 )
                    , ( 14, float 2 )
                    , ( 18, float 18 )
                    ]
            )
        , Layer.lineColor (E.rgba 255 255 255 1)
        , Layer.lineOpacity (E.zoom |> E.step (float 1) [ ( 14, float 0 ) ])
        , Layer.lineCap E.lineCapRound

        --, Layer.lineJoin E.lineCapRound
        ]
    , Layer.line "road-minor-case"
        "composite"
        [ --(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855786460.0557"} is not yet supported"))))
          --,
          Layer.sourceLayer "road"
        , Layer.minzoom 13

        --, Layer.filter (E.all (E.zoom |> E.step (E.getProperty (str "class") |> E.isEqual (str "track")) [ ( 14, Debug.todo "The expression [" match ",[" get "," class "],[" track "," secondary_link "," tertiary_link "," service "],true,false] is not yet supported" ) ]) (Debug.todo "The expression [" match ",[" get "," structure "],[" none "," ford "],true,false] is not yet supported") (E.geometryType |> E.isEqual (str "LineString")))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 12, float 0.75 )
                    , ( 20, float 2 )
                    ]
            )
        , Layer.lineColor (E.rgba 232 237 235 1)
        , Layer.lineGapWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 14, E.getProperty (str "class") |> E.matchesStr [ ( "track", float 1 ) ] (float 0.5) )
                    , ( 18, float 12 )
                    ]
            )
        , Layer.lineOpacity (E.zoom |> E.step (float 0) [ ( 14, float 1 ) ])
        , Layer.lineCap E.lineCapRound

        --, Layer.lineJoin E.lineCapRound
        ]
    , Layer.line "road-street-case"
        "composite"
        [ --(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855786460.0557"} is not yet supported"))))
          --,
          Layer.sourceLayer "road"
        , Layer.minzoom 11

        --, (Layer.filter ((E.all (((Debug.todo "The expression ["match",["get","class"],["street","street_limited","primary_link"],true,false] is not yet supported"))) (((Debug.todo "The expression ["match",["get","structure"],["none","ford"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 12, float 0.75 )
                    , ( 20, float 2 )
                    ]
            )
        , Layer.lineColor (E.rgba 232 237 235 1)
        , Layer.lineGapWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 12, float 0.5 )
                    , ( 14, float 2 )
                    , ( 18, float 18 )
                    ]
            )
        , Layer.lineOpacity (E.zoom |> E.step (float 0) [ ( 14, float 1 ) ])
        , Layer.lineCap E.lineCapRound

        --, (Layer.lineJoin (E.lineCapRound))
        ]
    , Layer.line "road-secondary-tertiary-case"
        "composite"
        [ --(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855786460.0557"} is not yet supported"))))
          --,
          Layer.sourceLayer "road"

        --, (Layer.filter ((E.all (((Debug.todo "The expression ["match",["get","class"],["secondary","tertiary"],true,false] is not yet supported"))) (((Debug.todo "The expression ["match",["get","structure"],["none","ford"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 10, float 0.75 )
                    , ( 18, float 2 )
                    ]
            )
        , Layer.lineColor (E.rgba 232 237 235 1)
        , Layer.lineGapWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 5, float 0.1 )
                    , ( 18, float 26 )
                    ]
            )
        , Layer.lineCap E.lineCapRound

        --, (Layer.lineJoin (E.lineCapRound))
        ]

    -- TODO: Roads now looke much worse
    , Layer.line "road-primary-case"
        "composite"
        [ --(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855786460.0557"} is not yet supported"))))
          -- ,
          Layer.sourceLayer "road"

        --, (Layer.filter ((E.all ((((E.getProperty ((str "class")))) |> (E.isEqual ((str "primary"))))) (((Debug.todo "The expression ["match",["get","structure"],["none","ford"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 10, float 1 )
                    , ( 18, float 2 )
                    ]
            )
        , Layer.lineColor (E.rgba 232 237 235 1)
        , Layer.lineGapWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 5, float 0.75 )
                    , ( 18, float 32 )
                    ]
            )
        , Layer.lineCap E.lineCapRound

        --, (Layer.lineJoin (E.lineCapRound))
        ]
    , Layer.line "road-major-link-case"
        "composite"
        [ --(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855786460.0557"} is not yet supported"))))
          --,
          Layer.sourceLayer "road"
        , Layer.minzoom 10

        --, (Layer.filter ((E.all (((Debug.todo "The expression ["match",["get","class"],["motorway_link","trunk_link"],true,false] is not yet supported"))) (((Debug.todo "The expression ["match",["get","structure"],["none","ford"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 12, float 0.75 )
                    , ( 20, float 2 )
                    ]
            )
        , Layer.lineColor (E.rgba 232 237 235 1)
        , Layer.lineGapWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 12, float 0.5 )
                    , ( 14, float 2 )
                    , ( 18, float 18 )
                    ]
            )
        , Layer.lineOpacity (E.zoom |> E.step (float 0) [ ( 11, float 1 ) ])
        , Layer.lineCap E.lineCapRound

        --, (Layer.lineJoin (E.lineCapRound))
        ]
    ]



{-
   layers =
               [
       , (Layer.line "road-motorway-trunk-case" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855786460.0557"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.filter ((E.all (((Debug.todo "The expression ["match",["get","class"],["motorway","trunk"],true,false] is not yet supported"))) (((Debug.todo "The expression ["match",["get","structure"],["none","ford"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(10, ((float 1)))
       , (18, ((float 2)))]))))
       , (Layer.lineColor ((E.rgba 232 237 235 1)))
       , (Layer.lineGapWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(5, ((float 0.75)))
       , (18, ((float 32)))]))))
       , (Layer.lineOpacity ((((E.zoom)) |> (E.step ((((E.getProperty ((str "class")))) |> (E.matchesStr [("motorway", ((float 1)))] ((float 0))))) [(6, ((float 1)))]))))
       , (Layer.lineCap (E.lineCapRound))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "road-construction" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855786460.0557"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 14)
       , (Layer.filter ((E.all ((((E.getProperty ((str "class")))) |> (E.isEqual ((str "construction"))))) (((Debug.todo "The expression ["match",["get","structure"],["none","ford"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(14, ((float 2)))
       , (18, ((float 18)))]))))
       , (Layer.lineColor ((E.rgba 255 255 255 1)))
       , (Layer.lineDasharray ((((E.zoom)) |> (E.step ((E.floats [0.4
       , 0.8])) [(15, ((E.floats [0.3
       , 0.6])))
       , (16, ((E.floats [0.2
       , 0.3])))
       , (17, ((E.floats [0.2
       , 0.25])))
       , (18, ((E.floats [0.15
       , 0.15])))]))))])
       , (Layer.line "road-path" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855786460.0557"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 12)
       , (Layer.filter ((E.all ((((E.getProperty ((str "class")))) |> (E.isEqual ((str "path"))))) ((((E.zoom)) |> (E.step ((E. (((Debug.todo "The expression ["match",["get","type"],["steps","sidewalk","crossing"],true,false] is not yet supported"))))) [(16, ((((E.getProperty ((str "type")))) |> (E.notEqual ((str "steps"))))))]))) (((Debug.todo "The expression ["match",["get","structure"],["none","ford"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(13, ((float 0.5)))
       , (14, ((float 1)))
       , (15, ((float 1)))
       , (18, ((float 4)))]))))
       , (Layer.lineColor ((E.rgba 255 255 255 1)))
       , (Layer.lineDasharray ((((E.zoom)) |> (E.step ((E.floats [1
       , 0])) [(15, ((E.floats [1.75
       , 1])))
       , (16, ((E.floats [1
       , 0.75])))
       , (17, ((E.floats [1
       , 0.5])))]))))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "road-steps" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855786460.0557"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 14)
       , (Layer.filter ((E.all ((((E.getProperty ((str "type")))) |> (E.isEqual ((str "steps"))))) (((Debug.todo "The expression ["match",["get","structure"],["none","ford"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(15, ((float 1)))
       , (16, ((float 1.6)))
       , (18, ((float 6)))]))))
       , (Layer.lineColor ((E.rgba 255 255 255 1)))
       , (Layer.lineDasharray ((((E.zoom)) |> (E.step ((E.floats [1
       , 0])) [(15, ((E.floats [1.75
       , 1])))
       , (16, ((E.floats [1
       , 0.75])))
       , (17, ((E.floats [0.3
       , 0.3])))]))))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "road-major-link" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855786460.0557"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 10)
       , (Layer.filter ((E.all (((Debug.todo "The expression ["match",["get","class"],["motorway_link","trunk_link"],true,false] is not yet supported"))) (((Debug.todo "The expression ["match",["get","structure"],["none","ford"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(12, ((float 0.5)))
       , (14, ((float 2)))
       , (18, ((float 18)))]))))
       , (Layer.lineColor ((E.rgba 255 255 255 1)))
       , (Layer.lineCap (E.lineCapRound))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "road-pedestrian" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855786460.0557"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 12)
       , (Layer.filter ((E.all ((((E.getProperty ((str "class")))) |> (E.isEqual ((str "pedestrian"))))) (((Debug.todo "The expression ["match",["get","structure"],["none","ford"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(14, ((float 0.5)))
       , (18, ((float 12)))]))))
       , (Layer.lineColor ((E.rgba 255 255 255 1)))
       , (Layer.lineDasharray ((((E.zoom)) |> (E.step ((E.floats [1
       , 0])) [(15, ((E.floats [1.5
       , 0.4])))
       , (16, ((E.floats [1
       , 0.2])))]))))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "road-minor" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855786460.0557"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 13)
       , (Layer.filter ((E.all ((((E.zoom)) |> (E.step ((((E.getProperty ((str "class")))) |> (E.isEqual ((str "track"))))) [(14, (((Debug.todo "The expression ["match",["get","class"],["track","secondary_link","tertiary_link","service"],true,false] is not yet supported"))))]))) (((Debug.todo "The expression ["match",["get","structure"],["none","ford"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(14, ((((E.getProperty ((str "class")))) |> (E.matchesStr [("track", ((float 1)))] ((float 0.5))))))
       , (18, ((float 12)))]))))
       , (Layer.lineColor ((E.rgba 255 255 255 1)))
       , (Layer.lineOpacity ((((E.zoom)) |> (E.step ((float 0)) [(14, ((float 1)))]))))
       , (Layer.lineCap (E.lineCapRound))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "road-street" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855786460.0557"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 11)
       , (Layer.filter ((E.all (((Debug.todo "The expression ["match",["get","class"],["street","street_limited","primary_link"],true,false] is not yet supported"))) (((Debug.todo "The expression ["match",["get","structure"],["none","ford"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(12, ((float 0.5)))
       , (14, ((float 2)))
       , (18, ((float 18)))]))))
       , (Layer.lineColor ((E.rgba 255 255 255 1)))
       , (Layer.lineOpacity ((((E.zoom)) |> (E.step ((float 0)) [(14, ((float 1)))]))))
       , (Layer.lineCap (E.lineCapRound))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "road-secondary-tertiary" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855786460.0557"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.filter ((E.all (((Debug.todo "The expression ["match",["get","class"],["secondary","tertiary"],true,false] is not yet supported"))) (((Debug.todo "The expression ["match",["get","structure"],["none","ford"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(5, ((float 0.1)))
       , (18, ((float 26)))]))))
       , (Layer.lineColor ((E.rgba 255 255 255 1)))
       , (Layer.lineCap (E.lineCapRound))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "road-primary" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855786460.0557"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.filter ((E.all ((((E.getProperty ((str "class")))) |> (E.isEqual ((str "primary"))))) (((Debug.todo "The expression ["match",["get","structure"],["none","ford"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(5, ((float 0.75)))
       , (18, ((float 32)))]))))
       , (Layer.lineColor ((E.rgba 255 255 255 1)))
       , (Layer.lineCap (E.lineCapRound))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "road-motorway-trunk" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855786460.0557"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.filter ((E.all (((Debug.todo "The expression ["match",["get","class"],["motorway","trunk"],true,false] is not yet supported"))) (((Debug.todo "The expression ["match",["get","structure"],["none","ford"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(5, ((float 0.75)))
       , (18, ((float 32)))]))))
       , (Layer.lineColor ((E.rgba 255 255 255 1)))
       , (Layer.lineCap (E.lineCapRound))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "road-rail" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855786460.0557"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 13)
       , (Layer.filter ((E.all (((Debug.todo "The expression ["match",["get","class"],["major_rail","minor_rail"],true,false] is not yet supported"))) (((Debug.todo "The expression ["match",["get","structure"],["none","ford"],true,false] is not yet supported"))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(14, ((float 0.5)))
       , (20, ((float 1)))]))))
       , (Layer.lineColor ((E.rgba 232 237 235 1)))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "bridge-pedestrian-case" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855799204.86"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 13)
       , (Layer.filter ((E.all ((((E.getProperty ((str "structure")))) |> (E.isEqual ((str "bridge"))))) ((((E.getProperty ((str "class")))) |> (E.isEqual ((str "pedestrian"))))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(14, ((float 2)))
       , (18, ((float 14.5)))]))))
       , (Layer.lineOpacity ((((E.zoom)) |> (E.step ((float 0)) [(14, ((float 1)))]))))
       , (Layer.lineColor ((E.rgba 232 237 235 1)))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "bridge-street-minor-low" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855799204.86"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 13)
       , (Layer.filter ((E.all ((((E.getProperty ((str "structure")))) |> (E.isEqual ((str "bridge"))))) ((((E.zoom)) |> (E.step (((Debug.todo "The expression ["match",["get","class"],["street","street_limited","track","primary_link"],true,false] is not yet supported"))) [(14, (((Debug.todo "The expression ["match",["get","class"],["street","street_limited","track","primary_link","secondary_link","tertiary_link","service"],true,false] is not yet supported"))))]))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(12, ((float 0.5)))
       , (14, (((Debug.todo "The expression ["match",["get","class"],["street","street_limited","primary_link"],2,"track",1,0.5] is not yet supported"))))
       , (18, (((Debug.todo "The expression ["match",["get","class"],["street","street_limited","primary_link"],18,12] is not yet supported"))))]))))
       , (Layer.lineColor ((E.rgba 255 255 255 1)))
       , (Layer.lineOpacity ((((E.zoom)) |> (E.step ((float 1)) [(14, ((float 0)))]))))
       , (Layer.lineCap (E.lineCapRound))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "bridge-street-minor-case" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855799204.86"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 13)
       , (Layer.filter ((E.all ((((E.getProperty ((str "structure")))) |> (E.isEqual ((str "bridge"))))) ((((E.zoom)) |> (E.step (((Debug.todo "The expression ["match",["get","class"],["street","street_limited","track","primary_link"],true,false] is not yet supported"))) [(14, (((Debug.todo "The expression ["match",["get","class"],["street","street_limited","track","primary_link","secondary_link","tertiary_link","service"],true,false] is not yet supported"))))]))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(12, ((float 0.75)))
       , (20, ((float 2)))]))))
       , (Layer.lineOpacity ((((E.zoom)) |> (E.step ((float 0)) [(14, ((float 1)))]))))
       , (Layer.lineGapWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(12, ((float 0.5)))
       , (14, (((Debug.todo "The expression ["match",["get","class"],["street","street_limited","primary_link"],2,"track",1,0.5] is not yet supported"))))
       , (18, (((Debug.todo "The expression ["match",["get","class"],["street","street_limited","primary_link"],18,12] is not yet supported"))))]))))
       , (Layer.lineColor ((E.rgba 232 237 235 1)))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "bridge-primary-secondary-tertiary-case" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855799204.86"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 13)
       , (Layer.filter ((E.all ((((E.getProperty ((str "structure")))) |> (E.isEqual ((str "bridge"))))) (((Debug.todo "The expression ["match",["get","class"],["primary","secondary","tertiary"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(10, (((Debug.todo "The expression ["match",["get","class"],"primary",1,["secondary","tertiary"],0.75,0.75] is not yet supported"))))
       , (18, ((float 2)))]))))
       , (Layer.lineOpacity ((((E.zoom)) |> (E.step ((float 0)) [(10, ((float 1)))]))))
       , (Layer.lineGapWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(5, (((Debug.todo "The expression ["match",["get","class"],"primary",0.75,["secondary","tertiary"],0.1,0.1] is not yet supported"))))
       , (18, (((Debug.todo "The expression ["match",["get","class"],"primary",32,["secondary","tertiary"],26,26] is not yet supported"))))]))))
       , (Layer.lineColor ((E.rgba 232 237 235 1)))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "bridge-major-link-case" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855799204.86"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 13)
       , (Layer.filter ((E.all ((((E.getProperty ((str "structure")))) |> (E.isEqual ((str "bridge"))))) (((Debug.todo "The expression ["match",["get","class"],["motorway_link","trunk_link"],true,false] is not yet supported"))) ((((E.getProperty ((str "layer")))) |> (E.lessThanOrEqual ((float 1))))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(12, ((float 0.75)))
       , (20, ((float 2)))]))))
       , (Layer.lineGapWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(12, ((float 0.5)))
       , (14, ((float 2)))
       , (18, ((float 18)))]))))
       , (Layer.lineColor ((E.rgba 232 237 235 1)))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "bridge-motorway-trunk-case" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855799204.86"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 13)
       , (Layer.filter ((E.all ((((E.getProperty ((str "structure")))) |> (E.isEqual ((str "bridge"))))) (((Debug.todo "The expression ["match",["get","class"],["motorway","trunk"],true,false] is not yet supported"))) ((((E.getProperty ((str "layer")))) |> (E.lessThanOrEqual ((float 1))))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(10, ((float 1)))
       , (18, ((float 2)))]))))
       , (Layer.lineGapWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(5, ((float 0.75)))
       , (18, ((float 32)))]))))
       , (Layer.lineColor ((E.rgba 232 237 235 1)))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "bridge-construction" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855799204.86"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 14)
       , (Layer.filter ((E.all ((((E.getProperty ((str "structure")))) |> (E.isEqual ((str "bridge"))))) ((((E.getProperty ((str "class")))) |> (E.isEqual ((str "construction"))))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(14, ((float 2)))
       , (18, ((float 18)))]))))
       , (Layer.lineDasharray ((((E.zoom)) |> (E.step ((E.floats [0.4
       , 0.8])) [(15, ((E.floats [0.3
       , 0.6])))
       , (16, ((E.floats [0.2
       , 0.3])))
       , (17, ((E.floats [0.2
       , 0.25])))
       , (18, ((E.floats [0.15
       , 0.15])))]))))
       , (Layer.lineColor ((E.rgba 255 255 255 1)))])
       , (Layer.line "bridge-path" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855799204.86"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 13)
       , (Layer.filter ((E.all ((((E.getProperty ((str "structure")))) |> (E.isEqual ((str "bridge"))))) ((((E.getProperty ((str "class")))) |> (E.isEqual ((str "path"))))) ((((E.getProperty ((str "type")))) |> (E.notEqual ((str "steps"))))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(15, ((float 1)))
       , (18, ((float 4)))]))))
       , (Layer.lineColor ((E.rgba 255 255 255 1)))
       , (Layer.lineDasharray ((((E.zoom)) |> (E.step ((E.floats [1
       , 0])) [(15, ((E.floats [1.75
       , 1])))
       , (16, ((E.floats [1
       , 0.75])))
       , (17, ((E.floats [1
       , 0.5])))]))))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "bridge-steps" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855799204.86"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 14)
       , (Layer.filter ((E.all ((((E.getProperty ((str "type")))) |> (E.isEqual ((str "steps"))))) ((((E.getProperty ((str "structure")))) |> (E.isEqual ((str "bridge"))))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(15, ((float 1)))
       , (16, ((float 1.6)))
       , (18, ((float 6)))]))))
       , (Layer.lineColor ((E.rgba 255 255 255 1)))
       , (Layer.lineDasharray ((((E.zoom)) |> (E.step ((E.floats [1
       , 0])) [(15, ((E.floats [1.75
       , 1])))
       , (16, ((E.floats [1
       , 0.75])))
       , (17, ((E.floats [0.3
       , 0.3])))]))))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "bridge-major-link" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855799204.86"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 13)
       , (Layer.filter ((E.all ((((E.getProperty ((str "structure")))) |> (E.isEqual ((str "bridge"))))) (((Debug.todo "The expression ["match",["get","class"],["motorway_link","trunk_link"],true,false] is not yet supported"))) ((((E.getProperty ((str "layer")))) |> (E.lessThanOrEqual ((float 1))))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(12, ((float 0.5)))
       , (14, ((float 2)))
       , (18, ((float 18)))]))))
       , (Layer.lineColor ((E.rgba 255 255 255 1)))
       , (Layer.lineCap (E.lineCapRound))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "bridge-pedestrian" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855799204.86"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 13)
       , (Layer.filter ((E.all ((((E.getProperty ((str "structure")))) |> (E.isEqual ((str "bridge"))))) ((((E.getProperty ((str "class")))) |> (E.isEqual ((str "pedestrian"))))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(14, ((float 0.5)))
       , (18, ((float 12)))]))))
       , (Layer.lineColor ((E.rgba 255 255 255 1)))
       , (Layer.lineDasharray ((((E.zoom)) |> (E.step ((E.floats [1
       , 0])) [(15, ((E.floats [1.5
       , 0.4])))
       , (16, ((E.floats [1
       , 0.2])))]))))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "bridge-street-minor" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855799204.86"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 13)
       , (Layer.filter ((E.all ((((E.getProperty ((str "structure")))) |> (E.isEqual ((str "bridge"))))) ((((E.zoom)) |> (E.step (((Debug.todo "The expression ["match",["get","class"],["street","street_limited","track","primary_link"],true,false] is not yet supported"))) [(14, (((Debug.todo "The expression ["match",["get","class"],["street","street_limited","track","primary_link","secondary_link","tertiary_link","service"],true,false] is not yet supported"))))]))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(12, ((float 0.5)))
       , (14, (((Debug.todo "The expression ["match",["get","class"],["street","street_limited","primary_link"],2,"track",1,0.5] is not yet supported"))))
       , (18, (((Debug.todo "The expression ["match",["get","class"],["street","street_limited","primary_link"],18,12] is not yet supported"))))]))))
       , (Layer.lineColor ((E.rgba 255 255 255 1)))
       , (Layer.lineOpacity ((((E.zoom)) |> (E.step ((float 0)) [(14, ((float 1)))]))))
       , (Layer.lineCap (E.lineCapRound))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "bridge-primary-secondary-tertiary" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855799204.86"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 13)
       , (Layer.filter ((E.all ((((E.getProperty ((str "structure")))) |> (E.isEqual ((str "bridge"))))) (((Debug.todo "The expression ["match",["get","class"],["primary","secondary","tertiary"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(5, (((Debug.todo "The expression ["match",["get","class"],"primary",0.75,["secondary","tertiary"],0.1,0.1] is not yet supported"))))
       , (18, (((Debug.todo "The expression ["match",["get","class"],"primary",32,["secondary","tertiary"],26,26] is not yet supported"))))]))))
       , (Layer.lineColor ((E.rgba 255 255 255 1)))
       , (Layer.lineCap (E.lineCapRound))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "bridge-motorway-trunk" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855799204.86"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 13)
       , (Layer.filter ((E.all ((((E.getProperty ((str "structure")))) |> (E.isEqual ((str "bridge"))))) (((Debug.todo "The expression ["match",["get","class"],["motorway","trunk"],true,false] is not yet supported"))) ((((E.getProperty ((str "layer")))) |> (E.lessThanOrEqual ((float 1))))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(5, ((float 0.75)))
       , (18, ((float 32)))]))))
       , (Layer.lineColor ((E.rgba 255 255 255 1)))
       , (Layer.lineCap (E.lineCapRound))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "bridge-rail" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855799204.86"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 13)
       , (Layer.filter ((E.all ((((E.getProperty ((str "structure")))) |> (E.isEqual ((str "bridge"))))) (((Debug.todo "The expression ["match",["get","class"],["major_rail","minor_rail"],true,false] is not yet supported"))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(14, ((float 0.5)))
       , (20, ((float 1)))]))))
       , (Layer.lineColor ((E.rgba 232 237 235 1)))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "bridge-major-link-2-case" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855799204.86"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 13)
       , (Layer.filter ((E.all ((((E.getProperty ((str "structure")))) |> (E.isEqual ((str "bridge"))))) ((((E.getProperty ((str "layer")))) |> (E.greaterThanOrEqual ((float 2))))) (((Debug.todo "The expression ["match",["get","class"],["motorway_link","trunk_link"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(12, ((float 0.75)))
       , (20, ((float 2)))]))))
       , (Layer.lineColor ((E.rgba 232 237 235 1)))
       , (Layer.lineGapWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(12, ((float 0.5)))
       , (14, ((float 2)))
       , (18, ((float 18)))]))))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "bridge-motorway-trunk-2-case" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855799204.86"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 13)
       , (Layer.filter ((E.all ((((E.getProperty ((str "structure")))) |> (E.isEqual ((str "bridge"))))) ((((E.getProperty ((str "layer")))) |> (E.greaterThanOrEqual ((float 2))))) (((Debug.todo "The expression ["match",["get","class"],["motorway","trunk"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(10, ((float 1)))
       , (18, ((float 2)))]))))
       , (Layer.lineColor ((E.rgba 232 237 235 1)))
       , (Layer.lineGapWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(5, ((float 0.75)))
       , (18, ((float 32)))]))))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "bridge-major-link-2" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855799204.86"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 13)
       , (Layer.filter ((E.all ((((E.getProperty ((str "structure")))) |> (E.isEqual ((str "bridge"))))) ((((E.getProperty ((str "layer")))) |> (E.greaterThanOrEqual ((float 2))))) (((Debug.todo "The expression ["match",["get","class"],["motorway_link","trunk_link"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(12, ((float 0.5)))
       , (14, ((float 2)))
       , (18, ((float 18)))]))))
       , (Layer.lineColor ((E.rgba 255 255 255 1)))
       , (Layer.lineCap (E.lineCapRound))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "bridge-motorway-trunk-2" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855799204.86"} is not yet supported"))))
       , (Layer.sourceLayer "road")
       , (Layer.minzoom 13)
       , (Layer.filter ((E.all ((((E.getProperty ((str "structure")))) |> (E.isEqual ((str "bridge"))))) ((((E.getProperty ((str "layer")))) |> (E.greaterThanOrEqual ((float 2))))) (((Debug.todo "The expression ["match",["get","class"],["motorway","trunk"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Exponential 1.5)) [(5, ((float 0.75)))
       , (18, ((float 32)))]))))
       , (Layer.lineColor ((E.rgba 255 255 255 1)))
       , (Layer.lineCap (E.lineCapRound))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.line "admin-1-boundary-bg" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444934295202.7542"} is not yet supported"))))
       , (Layer.sourceLayer "admin")
       , (Layer.filter ((E.all ((((E.getProperty ((str "admin_level")))) |> (E.isEqual ((float 1))))) ((((E.getProperty ((str "maritime")))) |> (E.isEqual ((str "false"))))) (((Debug.todo "The expression ["match",["get","worldview"],["all","US"],true,false] is not yet supported"))))))
       , (Layer.lineBlur ((((E.zoom)) |> (E.interpolate ((E.Linear)) [(3, ((float 0)))
       , (8, ((float 3)))]))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Linear)) [(7, ((float 3.75)))
       , (12, ((float 5.5)))]))))
       , (Layer.lineOpacity ((((E.zoom)) |> (E.interpolate ((E.Linear)) [(7, ((float 0)))
       , (8, ((float 0.75)))]))))
       , (Layer.lineDasharray (((Debug.todo "The expression [1,0] is not yet supported"))))
       , (Layer.lineTranslate (((Debug.todo "The expression [0,0] is not yet supported"))))
       , (Layer.lineColor ((E.rgba 214 214 214 1)))
       , (Layer.lineJoin (E.lineJoinBevel))])
       , (Layer.line "admin-0-boundary-bg" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444934295202.7542"} is not yet supported"))))
       , (Layer.sourceLayer "admin")
       , (Layer.minzoom 1)
       , (Layer.filter ((E.all ((((E.getProperty ((str "admin_level")))) |> (E.isEqual ((float 0))))) ((((E.getProperty ((str "maritime")))) |> (E.isEqual ((str "false"))))) (((Debug.todo "The expression ["match",["get","worldview"],["all","US"],true,false] is not yet supported"))))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Linear)) [(3, ((float 3.5)))
       , (10, ((float 8)))]))))
       , (Layer.lineColor ((E.rgba 214 214 214 1)))
       , (Layer.lineOpacity ((((E.zoom)) |> (E.interpolate ((E.Linear)) [(3, ((float 0)))
       , (4, ((float 0.5)))]))))
       , (Layer.lineTranslate (((Debug.todo "The expression [0,0] is not yet supported"))))
       , (Layer.lineBlur ((((E.zoom)) |> (E.interpolate ((E.Linear)) [(3, ((float 0)))
       , (10, ((float 2)))]))))])
       , (Layer.line "admin-1-boundary" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444934295202.7542"} is not yet supported"))))
       , (Layer.sourceLayer "admin")
       , (Layer.filter ((E.all ((((E.getProperty ((str "admin_level")))) |> (E.isEqual ((float 1))))) ((((E.getProperty ((str "maritime")))) |> (E.isEqual ((str "false"))))) (((Debug.todo "The expression ["match",["get","worldview"],["all","US"],true,false] is not yet supported"))))))
       , (Layer.lineDasharray ((((E.zoom)) |> (E.step ((E.floats [2
       , 0])) [(7, ((E.floats [2
       , 2
       , 6
       , 2])))]))))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Linear)) [(7, ((float 0.75)))
       , (12, ((float 1.5)))]))))
       , (Layer.lineOpacity ((((E.zoom)) |> (E.interpolate ((E.Linear)) [(2, ((float 0)))
       , (3, ((float 1)))]))))
       , (Layer.lineColor ((((E.zoom)) |> (E.interpolate ((E.Linear)) [(3, ((E.rgba 204 204 204 1)))
       , (7, ((E.rgba 178 178 178 1)))]))))
       , (Layer.lineJoin (E.lineCapRound))
       , (Layer.lineCap (E.lineCapRound))])
       , (Layer.line "admin-0-boundary" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444934295202.7542"} is not yet supported"))))
       , (Layer.sourceLayer "admin")
       , (Layer.minzoom 1)
       , (Layer.filter ((E.all ((((E.getProperty ((str "admin_level")))) |> (E.isEqual ((float 0))))) ((((E.getProperty ((str "disputed")))) |> (E.isEqual ((str "false"))))) ((((E.getProperty ((str "maritime")))) |> (E.isEqual ((str "false"))))) (((Debug.todo "The expression ["match",["get","worldview"],["all","US"],true,false] is not yet supported"))))))
       , (Layer.lineColor ((E.rgba 158 158 158 1)))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Linear)) [(3, ((float 0.5)))
       , (10, ((float 2)))]))))
       , (Layer.lineJoin (E.lineCapRound))
       , (Layer.lineCap (E.lineCapRound))])
       , (Layer.line "admin-0-boundary-disputed" "composite" [(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444934295202.7542"} is not yet supported"))))
       , (Layer.sourceLayer "admin")
       , (Layer.minzoom 1)
       , (Layer.filter ((E.all ((((E.getProperty ((str "disputed")))) |> (E.isEqual ((str "true"))))) ((((E.getProperty ((str "admin_level")))) |> (E.isEqual ((float 0))))) ((((E.getProperty ((str "maritime")))) |> (E.isEqual ((str "false"))))) (((Debug.todo "The expression ["match",["get","worldview"],["all","US"],true,false] is not yet supported"))))))
       , (Layer.lineDasharray (((Debug.todo "The expression [1.5,1.5] is not yet supported"))))
       , (Layer.lineColor ((E.rgba 158 158 158 1)))
       , (Layer.lineWidth ((((E.zoom)) |> (E.interpolate ((E.Linear)) [(3, ((float 0.5)))
       , (10, ((float 2)))]))))
       , (Layer.lineJoin (E.lineCapRound))])
       , (Layer.symbol "road-label" "composite" [(Layer.sourceLayer "road")
       , (Layer.minzoom 10)
       , (Layer.filter ((((E.zoom)) |> (E.step (((Debug.todo "The expression ["match",["get","class"],["motorway","trunk","primary","secondary","tertiary"],true,false] is not yet supported"))) [(12, (((Debug.todo "The expression ["match",["get","class"],["motorway","trunk","primary","secondary","tertiary","pedestrian","street","street_limited"],true,false] is not yet supported"))))
       , (15, (((Debug.todo "The expression ["match",["get","class"],["ferry","golf","path"],false,true] is not yet supported"))))]))))
       , (Layer.textColor ((E.rgba 107 107 107 1)))
       , (Layer.textHaloColor (((Debug.todo "The expression ["match",["get","class"],["motorway","trunk"],"hsla(0, 0%, 100%, 0.75)","hsl(0, 0%, 100%)"] is not yet supported"))))
       , (Layer.textHaloWidth ((float 1)))
       , (Layer.textHaloBlur ((float 1)))
       , (Layer.textSize ((((E.zoom)) |> (E.interpolate ((E.Linear)) [(10, (((Debug.todo "The expression ["match",["get","class"],["motorway","trunk","primary","secondary","tertiary"],10,["motorway_link","trunk_link","primary_link","secondary_link","tertiary_link","pedestrian","street","street_limited"],9,6.5] is not yet supported"))))
       , (18, (((Debug.todo "The expression ["match",["get","class"],["motorway","trunk","primary","secondary","tertiary"],16,["motorway_link","trunk_link","primary_link","secondary_link","tertiary_link","pedestrian","street","street_limited"],14,13] is not yet supported"))))]))))
       , (Layer.textMaxAngle ((float 30)))
       , (Layer.textFont ((E.strings ["DIN Offc Pro Regular"
       , "Arial Unicode MS Regular"])))
       , (Layer.symbolPlacement (E.symbolPlacementLine))
       , (Layer.textPadding ((float 1)))
       , (Layer.textRotationAlignment (E.anchorMap))
       , (Layer.textPitchAlignment (E.anchorViewport))
       , (Layer.textField ((E.coalesce ((E.getProperty ((str "name_en")))) ((E.getProperty ((str "name")))))))
       , (Layer.textLetterSpacing ((float 0.01)))])
       , (Layer.symbol "waterway-label" "composite" [(Layer.sourceLayer "natural_label")
       , (Layer.minzoom 13)
       , (Layer.filter ((E.all (((Debug.todo "The expression ["match",["get","class"],["canal","river","stream"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.textColor ((E.rgba 121 136 138 1)))
       , (Layer.textFont ((E.strings ["DIN Offc Pro Italic"
       , "Arial Unicode MS Regular"])))
       , (Layer.textMaxAngle ((float 30)))
       , (Layer.symbolSpacing ((((E.zoom)) |> (E.interpolate ((E.Linear ((float 1)))) [(15, ((float 250)))
       , (17, ((float 400)))]))))
       , (Layer.textSize ((((E.zoom)) |> (E.interpolate ((E.Linear)) [(13, ((float 12)))
       , (18, ((float 16)))]))))
       , (Layer.symbolPlacement (E.symbolPlacementLine))
       , (Layer.textPitchAlignment (E.anchorViewport))
       , (Layer.textField ((E.coalesce ((E.getProperty ((str "name_en")))) ((E.getProperty ((str "name")))))))])
       , (Layer.symbol "natural-line-label" "composite" [(Layer.sourceLayer "natural_label")
       , (Layer.minzoom 4)
       , (Layer.filter ((E.all (((Debug.todo "The expression ["match",["get","class"],["glacier","landform"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))) ((((E.getProperty ((str "filterrank")))) |> (E.lessThanOrEqual ((float 1))))))))
       , (Layer.textHaloWidth ((float 0.5)))
       , (Layer.textHaloColor ((E.rgba 255 255 255 1)))
       , (Layer.textHaloBlur ((float 0.5)))
       , (Layer.textColor ((E.rgba 107 107 107 1)))
       , (Layer.textSize ((((E.zoom)) |> (E.step ((((E.getProperty ((str "sizerank")))) |> (E.step ((float 18)) [(5, ((float 12)))]))) [(17, ((((E.getProperty ((str "sizerank")))) |> (E.step ((float 18)) [(13, ((float 12)))]))))]))))
       , (Layer.textMaxAngle ((float 30)))
       , (Layer.textField ((E.coalesce ((E.getProperty ((str "name_en")))) ((E.getProperty ((str "name")))))))
       , (Layer.textFont ((E.strings ["DIN Offc Pro Medium"
       , "Arial Unicode MS Regular"])))
       , (Layer.symbolPlacement (E.symbolPlacementLineCenter))
       , (Layer.textPitchAlignment (E.anchorViewport))])
       , (Layer.symbol "natural-point-label" "composite" [(Layer.sourceLayer "natural_label")
       , (Layer.minzoom 4)
       , (Layer.filter ((E.all (((Debug.todo "The expression ["match",["get","class"],["dock","glacier","landform","water_feature","wetland"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "Point"))))) ((((E.getProperty ((str "filterrank")))) |> (E.lessThanOrEqual ((float 1))))))))
       , (Layer.textColor ((E.rgba 107 107 107 1)))
       , (Layer.textHaloColor ((E.rgba 255 255 255 1)))
       , (Layer.textHaloWidth ((float 0.5)))
       , (Layer.textHaloBlur ((float 0.5)))
       , (Layer.textSize ((((E.zoom)) |> (E.step ((((E.getProperty ((str "sizerank")))) |> (E.step ((float 18)) [(5, ((float 12)))]))) [(17, ((((E.getProperty ((str "sizerank")))) |> (E.step ((float 18)) [(13, ((float 12)))]))))]))))
       , (Layer.textField ((E.coalesce ((E.getProperty ((str "name_en")))) ((E.getProperty ((str "name")))))))
       , (Layer.textFont ((E.strings ["DIN Offc Pro Medium"
       , "Arial Unicode MS Regular"])))
       , (Layer.textOffset ((E.floats [0
       , 0])))])
       , (Layer.symbol "water-line-label" "composite" [(Layer.sourceLayer "natural_label")
       , (Layer.filter ((E.all (((Debug.todo "The expression ["match",["get","class"],["bay","ocean","reservoir","sea","water"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "LineString"))))))))
       , (Layer.textColor ((E.rgba 121 136 138 1)))
       , (Layer.textSize ((((E.zoom)) |> (E.interpolate ((E.Linear)) [(7, ((((E.getProperty ((str "sizerank")))) |> (E.step ((float 24)) [(6, ((float 18)))
       , (12, ((float 12)))]))))
       , (10, ((((E.getProperty ((str "sizerank")))) |> (E.step ((float 18)) [(9, ((float 12)))]))))
       , (18, ((((E.getProperty ((str "sizerank")))) |> (E.step ((float 18)) [(9, ((float 16)))]))))]))))
       , (Layer.textMaxAngle ((float 30)))
       , (Layer.textLetterSpacing (((Debug.todo "The expression ["match",["get","class"],"ocean",0.25,["sea","bay"],0.15,0] is not yet supported"))))
       , (Layer.textFont ((E.strings ["DIN Offc Pro Italic"
       , "Arial Unicode MS Regular"])))
       , (Layer.symbolPlacement (E.symbolPlacementLineCenter))
       , (Layer.textPitchAlignment (E.anchorViewport))
       , (Layer.textField ((E.coalesce ((E.getProperty ((str "name_en")))) ((E.getProperty ((str "name")))))))])
       , (Layer.symbol "water-point-label" "composite" [(Layer.sourceLayer "natural_label")
       , (Layer.filter ((E.all (((Debug.todo "The expression ["match",["get","class"],["bay","ocean","reservoir","sea","water"],true,false] is not yet supported"))) ((((E.geometryType)) |> (E.isEqual ((str "Point"))))))))
       , (Layer.textColor ((E.rgba 121 136 138 1)))
       , (Layer.textLineHeight ((float 1.3)))
       , (Layer.textSize ((((E.zoom)) |> (E.interpolate ((E.Linear)) [(7, ((((E.getProperty ((str "sizerank")))) |> (E.step ((float 24)) [(6, ((float 18)))
       , (12, ((float 12)))]))))
       , (10, ((((E.getProperty ((str "sizerank")))) |> (E.step ((float 18)) [(9, ((float 12)))]))))]))))
       , (Layer.textFont ((E.strings ["DIN Offc Pro Italic"
       , "Arial Unicode MS Regular"])))
       , (Layer.textField ((E.coalesce ((E.getProperty ((str "name_en")))) ((E.getProperty ((str "name")))))))
       , (Layer.textLetterSpacing (((Debug.todo "The expression ["match",["get","class"],"ocean",0.25,["bay","sea"],0.15,0.01] is not yet supported"))))
       , (Layer.textMaxWidth (((Debug.todo "The expression ["match",["get","class"],"ocean",4,"sea",5,["bay","water"],7,10] is not yet supported"))))])
       , (Layer.symbol "poi-label" "composite" [(Layer.sourceLayer "poi_label")
       , (Layer.minzoom 6)
       , (Layer.filter ((((E.getProperty ((str "filterrank")))) |> (E.lessThanOrEqual ((float 1))))))
       , (Layer.textHaloColor ((E.rgba 255 255 255 1)))
       , (Layer.textHaloWidth ((float 0.5)))
       , (Layer.textHaloBlur ((float 0.5)))
       , (Layer.textColor ((((E.zoom)) |> (E.step ((((E.getProperty ((str "sizerank")))) |> (E.step ((E.rgba 168 168 168 1)) [(5, ((E.rgba 142 142 142 1)))]))) [(17, ((((E.getProperty ((str "sizerank")))) |> (E.step ((E.rgba 168 168 168 1)) [(13, ((E.rgba 142 142 142 1)))]))))]))))
       , (Layer.textSize ((((E.zoom)) |> (E.step ((((E.getProperty ((str "sizerank")))) |> (E.step ((float 18)) [(5, ((float 12)))]))) [(17, ((((E.getProperty ((str "sizerank")))) |> (E.step ((float 18)) [(13, ((float 12)))]))))]))))
       , (Layer.textFont ((E.strings ["DIN Offc Pro Medium"
       , "Arial Unicode MS Regular"])))
       , (Layer.textField ((E.coalesce ((E.getProperty ((str "name_en")))) ((E.getProperty ((str "name")))))))])
       , (Layer.symbol "airport-label" "composite" [(Layer.sourceLayer "airport_label")
       , (Layer.minzoom 8)
       , (Layer.textColor ((E.rgba 107 107 107 1)))
       , (Layer.textHaloColor ((E.rgba 255 255 255 1)))
       , (Layer.textHaloWidth ((float 1)))
       , (Layer.textLineHeight ((float 1.1)))
       , (Layer.textSize ((((E.getProperty ((str "sizerank")))) |> (E.step ((float 18)) [(9, ((float 12)))]))))
       , (Layer.iconImage ((((E.getProperty ((str "sizerank")))) |> (E.step ((((E.getProperty ((str "maki")))) |> (E.append ((str "-15"))))) [(9, ((((E.getProperty ((str "maki")))) |> (E.append ((str "-11"))))))]))))
       , (Layer.textFont ((E.strings ["DIN Offc Pro Medium"
       , "Arial Unicode MS Regular"])))
       , (Layer.textOffset (((Debug.todo "The expression [0,0.75] is not yet supported"))))
       , (Layer.textRotationAlignment (E.anchorViewport))
       , (Layer.textAnchor (E.positionTop))
       , (Layer.textField ((((E.getProperty ((str "sizerank")))) |> (E.step ((E.coalesce ((E.getProperty ((str "name_en")))) ((E.getProperty ((str "name")))))) [(15, ((E.getProperty ((str "ref")))))]))))
       , (Layer.textLetterSpacing ((float 0.01)))
       , (Layer.textMaxWidth ((float 9)))])
       , (Layer.symbol "settlement-subdivision-label" "composite" [(Layer.sourceLayer "place_label")
       , (Layer.minzoom 10)
       , (Layer.maxzoom 15)
       , (Layer.filter ((E.all ((((E.getProperty ((str "class")))) |> (E.isEqual ((str "settlement_subdivision"))))) ((((E.getProperty ((str "filterrank")))) |> (E.lessThanOrEqual ((float 4))))))))
       , (Layer.textHaloColor ((E.rgba 255 255 255 1)))
       , (Layer.textHaloWidth ((float 1)))
       , (Layer.textColor ((E.rgba 158 158 158 1)))
       , (Layer.textHaloBlur ((float 0.5)))
       , (Layer.textField ((E.coalesce ((E.getProperty ((str "name_en")))) ((E.getProperty ((str "name")))))))
       , (Layer.textTransform (E.textTransformUppercase))
       , (Layer.textFont ((E.strings ["DIN Offc Pro Regular"
       , "Arial Unicode MS Regular"])))
       , (Layer.textLetterSpacing (((Debug.todo "The expression ["match",["get","type"],"suburb",0.15,["quarter","neighborhood"],0.1,0.1] is not yet supported"))))
       , (Layer.textMaxWidth ((float 7)))
       , (Layer.textPadding ((float 3)))
       , (Layer.textSize ((((E.zoom)) |> (E.interpolate ((E.cubicBezier ((float 0.5)) ((float 0)) ((float 1)) ((float 1)))) [(11, (((Debug.todo "The expression ["match",["get","type"],"suburb",11,["quarter","neighborhood"],10.5,10.5] is not yet supported"))))
       , (15, (((Debug.todo "The expression ["match",["get","type"],"suburb",17,["quarter","neighborhood"],16,16] is not yet supported"))))]))))])
       , (Layer.symbol "settlement-label" "composite" [(Layer.sourceLayer "place_label")
       , (Layer.maxzoom 15)
       , (Layer.filter ((E.all ((((E.getProperty ((str "filterrank")))) |> (E.lessThanOrEqual ((float 3))))) ((((E.getProperty ((str "class")))) |> (E.isEqual ((str "settlement"))))) ((((E.zoom)) |> (E.step (true) [(13, ((((E.getProperty ((str "symbolrank")))) |> (E.greaterThanOrEqual ((float 11))))))
       , (14, ((((E.getProperty ((str "symbolrank")))) |> (E.greaterThanOrEqual ((float 13))))))]))))))
       , (Layer.textColor ((((E.getProperty ((str "symbolrank")))) |> (E.step ((E.rgba 107 107 107 1)) [(11, ((E.rgba 140 140 140 1)))
       , (16, ((E.rgba 158 158 158 1)))]))))
       , (Layer.textHaloColor ((E.rgba 255 255 255 1)))
       , (Layer.textHaloWidth ((float 1)))
       , (Layer.iconOpacity ((((E.zoom)) |> (E.step ((float 1)) [(8, ((float 0)))]))))
       , (Layer.textHaloBlur ((float 1)))
       , (Layer.textLineHeight ((float 1.1)))
       , (Layer.textSize ((((E.zoom)) |> (E.interpolate ((E.cubicBezier ((float 0.2)) ((float 0)) ((float 0.9)) ((float 1)))) [(3, ((((E.getProperty ((str "symbolrank")))) |> (E.step ((float 12)) [(9, ((float 11)))
       , (10, ((float 10.5)))
       , (12, ((float 9.5)))
       , (14, ((float 8.5)))
       , (16, ((float 6.5)))
       , (17, ((float 4)))]))))
       , (15, ((((E.getProperty ((str "symbolrank")))) |> (E.step ((float 28)) [(9, ((float 26)))
       , (10, ((float 23)))
       , (11, ((float 21)))
       , (12, ((float 20)))
       , (13, ((float 19)))
       , (15, ((float 17)))]))))]))))
       , (Layer.iconImage ((E.case ((((E.getProperty ((str "capital")))) |> (E.isEqual ((float 2))))) ((str "border-dot-13")) ((((E.getProperty ((str "symbolrank")))) |> (E.step ((str "dot-11")) [(9, ((str "dot-10")))
       , (11, ((str "dot-9")))]))))))
       , (Layer.textFont ((((E.zoom)) |> (E.step ((E.strings ["DIN Offc Pro Regular"
       , "Arial Unicode MS Regular"])) [(8, ((((E.getProperty ((str "symbolrank")))) |> (E.step ((E.strings ["DIN Offc Pro Medium"
       , "Arial Unicode MS Regular"])) [(11, ((E.strings ["DIN Offc Pro Regular"
       , "Arial Unicode MS Regular"])))]))))
       , (10, ((((E.getProperty ((str "symbolrank")))) |> (E.step ((E.strings ["DIN Offc Pro Medium"
       , "Arial Unicode MS Regular"])) [(12, ((E.strings ["DIN Offc Pro Regular"
       , "Arial Unicode MS Regular"])))]))))
       , (11, ((((E.getProperty ((str "symbolrank")))) |> (E.step ((E.strings ["DIN Offc Pro Medium"
       , "Arial Unicode MS Regular"])) [(13, ((E.strings ["DIN Offc Pro Regular"
       , "Arial Unicode MS Regular"])))]))))
       , (12, ((((E.getProperty ((str "symbolrank")))) |> (E.step ((E.strings ["DIN Offc Pro Medium"
       , "Arial Unicode MS Regular"])) [(15, ((E.strings ["DIN Offc Pro Regular"
       , "Arial Unicode MS Regular"])))]))))
       , (13, ((E.strings ["DIN Offc Pro Medium"
       , "Arial Unicode MS Regular"])))]))))
       , (Layer.textJustify ((((E.zoom)) |> (E.step (((Debug.todo "The expression ["match",["get","text_anchor"],["bottom","top"],"center",["left","bottom-left","top-left"],"left",["right","bottom-right","top-right"],"right","center"] is not yet supported"))) [(8, (E.positionCenter))]))))
       , (Layer.textOffset ((((E.zoom)) |> (E.step ((((E.getProperty ((str "capital")))) |> (E.matchesFloat [(2, ((((E.getProperty ((str "text_anchor")))) |> (E.matchesStr [("bottom", ((E.floats [0
       , -0.3])))
       , ("bottom-left", ((E.floats [0.3
       , -0.1])))
       , ("left", ((E.floats [0.45
       , 0.1])))
       , ("top-left", ((E.floats [0.3
       , 0.1])))
       , ("top", ((E.floats [0
       , 0.3])))
       , ("top-right", ((E.floats [-0.3
       , 0.1])))
       , ("right", ((E.floats [-0.45
       , 0])))
       , ("bottom-right", ((E.floats [-0.3
       , -0.1])))] ((E.floats [0
       , -0.3]))))))] ((((E.getProperty ((str "text_anchor")))) |> (E.matchesStr [("bottom", ((E.floats [0
       , -0.25])))
       , ("bottom-left", ((E.floats [0.2
       , -0.05])))
       , ("left", ((E.floats [0.4
       , 0.05])))
       , ("top-left", ((E.floats [0.2
       , 0.05])))
       , ("top", ((E.floats [0
       , 0.25])))
       , ("top-right", ((E.floats [-0.2
       , 0.05])))
       , ("right", ((E.floats [-0.4
       , 0.05])))
       , ("bottom-right", ((E.floats [-0.2
       , -0.05])))] ((E.floats [0
       , -0.25])))))))) [(8, ((E.floats [0
       , 0])))]))))
       , (Layer.textAnchor ((((E.zoom)) |> (E.step ((E.getProperty ((str "text_anchor")))) [(8, (E.positionCenter))]))))
       , (Layer.textField ((E.coalesce ((E.getProperty ((str "name_en")))) ((E.getProperty ((str "name")))))))
       , (Layer.textMaxWidth ((float 7)))])
       , (Layer.symbol "state-label" "composite" [(Layer.sourceLayer "place_label")
       , (Layer.minzoom 3)
       , (Layer.maxzoom 9)
       , (Layer.filter ((((E.getProperty ((str "class")))) |> (E.isEqual ((str "state"))))))
       , (Layer.textHaloWidth ((float 1)))
       , (Layer.textHaloColor ((E.rgba 255 255 255 1)))
       , (Layer.textColor ((E.rgba 168 168 168 1)))
       , (Layer.textSize ((((E.zoom)) |> (E.interpolate ((E.cubicBezier ((float 0.85)) ((float 0.7)) ((float 0.65)) ((float 1)))) [(4, ((((E.getProperty ((str "symbolrank")))) |> (E.step ((float 10)) [(6, ((float 9.5)))
       , (7, ((float 9)))]))))
       , (9, ((((E.getProperty ((str "symbolrank")))) |> (E.step ((float 24)) [(6, ((float 18)))
       , (7, ((float 14)))]))))]))))
       , (Layer.textTransform (E.textTransformUppercase))
       , (Layer.textFont ((E.strings ["DIN Offc Pro Bold"
       , "Arial Unicode MS Bold"])))
       , (Layer.textField ((((E.zoom)) |> (E.step ((((E.getProperty ((str "symbolrank")))) |> (E.step ((E.coalesce ((E.getProperty ((str "name_en")))) ((E.getProperty ((str "name")))))) [(5, ((E.coalesce ((E.getProperty ((str "abbr")))) ((E.getProperty ((str "name_en")))) ((E.getProperty ((str "name")))))))]))) [(5, ((E.coalesce ((E.getProperty ((str "name_en")))) ((E.getProperty ((str "name")))))))]))))
       , (Layer.textLetterSpacing ((float 0.15)))
       , (Layer.textMaxWidth ((float 6)))])
       , (Layer.symbol "country-label" "composite" [(Layer.sourceLayer "place_label")
       , (Layer.minzoom 1)
       , (Layer.maxzoom 10)
       , (Layer.filter ((((E.getProperty ((str "class")))) |> (E.isEqual ((str "country"))))))
       , (Layer.iconOpacity ((((E.zoom)) |> (E.step ((E.case ((E.has ((str "text_anchor")))) ((float 1)) ((float 0)))) [(7, ((float 0)))]))))
       , (Layer.textColor ((E.rgba 107 107 107 1)))
       , (Layer.textHaloColor ((((E.zoom)) |> (E.interpolate ((E.Linear)) [(2, ((str "rgba(255,255,255,0.75)")))
       , (3, ((E.rgba 255 255 255 1)))]))))
       , (Layer.textHaloWidth ((float 1.25)))
       , (Layer.textLineHeight ((float 1.1)))
       , (Layer.textSize ((((E.zoom)) |> (E.interpolate ((E.cubicBezier ((float 0.2)) ((float 0)) ((float 0.7)) ((float 1)))) [(1, ((((E.getProperty ((str "symbolrank")))) |> (E.step ((float 11)) [(4, ((float 9)))
       , (5, ((float 8)))]))))
       , (9, ((((E.getProperty ((str "symbolrank")))) |> (E.step ((float 28)) [(4, ((float 22)))
       , (5, ((float 21)))]))))]))))
       , (Layer.iconImage ((str "dot-11")))
       , (Layer.textFont ((E.strings ["DIN Offc Pro Medium"
       , "Arial Unicode MS Regular"])))
       , (Layer.textJustify ((((E.zoom)) |> (E.step (((Debug.todo "The expression ["match",["get","text_anchor"],["bottom","top"],"center",["left","bottom-left","top-left"],"left",["right","bottom-right","top-right"],"right","center"] is not yet supported"))) [(7, (E.positionCenter))]))))
       , (Layer.textOffset ((((E.zoom)) |> (E.step ((((E.getProperty ((str "text_anchor")))) |> (E.matchesStr [("bottom", ((E.floats [0
       , -0.25])))
       , ("bottom-left", ((E.floats [0.2
       , -0.05])))
       , ("left", ((E.floats [0.4
       , 0.05])))
       , ("top-left", ((E.floats [0.2
       , 0.05])))
       , ("top", ((E.floats [0
       , 0.25])))
       , ("top-right", ((E.floats [-0.2
       , 0.05])))
       , ("right", ((E.floats [-0.4
       , 0.05])))
       , ("bottom-right", ((E.floats [-0.2
       , -0.05])))] ((E.floats [0
       , -0.25]))))) [(7, ((E.floats [0
       , 0])))]))))
       , (Layer.textAnchor ((((E.zoom)) |> (E.step ((E.coalesce ((E.getProperty ((str "text_anchor")))) (E.positionCenter))) [(7, (E.positionCenter))]))))
       , (Layer.textField ((E.coalesce ((E.getProperty ((str "name_en")))) ((E.getProperty ((str "name")))))))
       , (Layer.textMaxWidth ((float 6)))])
       ]

-}


style2 : Style
style2 =
    Style
        { transition = Style.defaultTransition
        , light = Style.defaultLight
        , layers = layers
        , sources = [ Source.vectorFromUrl "composite" "mapbox://mapbox.mapbox-streets-v8,mapbox.mapbox-terrain-v2" ]
        , misc = []
        }


layers2 =
    [ Layer.background "land" [ Layer.backgroundColor (E.rgba 245 245 243 1) ]
    , Layer.fill "landcover"
        "composite"
        [ Layer.sourceLayer "landcover"
        , Layer.maxzoom 7
        , Layer.fillColor (E.rgba 226 226 226 1)
        , Layer.fillOpacity
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 2, float 0.1 )
                    , ( 7, float 0 )
                    ]
            )
        , Layer.fillAntialias false
        ]
    , Layer.line "waterway"
        "composite"
        [ Layer.sourceLayer "waterway"
        , Layer.minzoom 8
        , Layer.lineColor (E.rgba 202 209 210 1)
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.3)
                    [--( 9, Debug.todo "The expression [" match ",[" get "," class "],[" canal "," river "],0.1,0] is not yet supported" )
                     --, ( 20, Debug.todo "The expression [" match ",[" get "," class "],[" canal "," river "],8,3] is not yet supported" )
                    ]
            )
        , Layer.lineOpacity
            (E.zoom
                |> E.interpolate E.Linear
                    [ ( 8, float 0 )
                    , ( 8.5, float 1 )
                    ]
            )
        , Layer.lineCap (E.zoom |> E.step E.lineCapButt [ ( 11, E.lineCapRound ) ])

        --, Layer.lineJoin E.lineCapRound
        ]
    , Layer.line "tunnel-street-minor-case"
        "composite"
        [ --(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855769305.6016"} is not yet supported"))))
          --,
          Layer.sourceLayer "road"
        , Layer.minzoom 13

        --, Layer.filter (E.all (E.getProperty (str "structure") |> E.isEqual (str "tunnel")) (E.zoom |> E.step (Debug.todo "The expression [" match ",[" get "," class "],[" street "," street_limited "," track "," primary_link "],true,false] is not yet supported") [ ( 14, Debug.todo "The expression [" match ",[" get "," class "],[" street "," street_limited "," track "," primary_link "," secondary_link "," tertiary_link "," service "],true,false] is not yet supported" ) ]) (E.geometryType |> E.isEqual (str "LineString")))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 12, float 0.75 )
                    , ( 20, float 2 )
                    ]
            )
        , Layer.lineColor (E.rgba 223 229 230 1)
        , Layer.lineGapWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 12, float 0.5 )

                    --, ( 14, Debug.todo "The expression [" match ",[" get "," class "],[" street "," street_limited "," primary_link "],2," track ",1,0.5] is not yet supported" )
                    --, ( 18, Debug.todo "The expression [" match ",[" get "," class "],[" street "," street_limited "," primary_link "],18,12] is not yet supported" )
                    ]
            )
        , Layer.lineOpacity (E.zoom |> E.step (float 0) [ ( 14, float 1 ) ])
        , Layer.lineDasharray (Debug.todo "The expression [3,3] is not yet supported")
        , Layer.lineCap E.lineCapRound

        --, Layer.lineJoin E.lineCapRound
        ]
    , Layer.line "tunnel-primary-secondary-tertiary-case"
        "composite"
        [ --(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855769305.6016"} is not yet supported"))))
          --,
          Layer.sourceLayer "road"
        , Layer.minzoom 13

        --, Layer.filter (E.all (E.getProperty (str "structure") |> E.isEqual (str "tunnel")) (Debug.todo "The expression [" match ",[" get "," class "],[" primary "," secondary "," tertiary "],true,false] is not yet supported") (E.geometryType |> E.isEqual (str "LineString")))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ --( 10, Debug.todo "The expression [" match ",[" get "," class "]," primary ",1,[" secondary "," tertiary "],0.75,0.75] is not yet supported" )
                      --,
                      ( 18, float 2 )
                    ]
            )
        , Layer.lineColor (E.rgba 223 229 230 1)
        , Layer.lineGapWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [--( 5, Debug.todo "The expression [" match ",[" get "," class "]," primary ",0.75,[" secondary "," tertiary "],0.1,0.1] is not yet supported" )
                     --, ( 18, Debug.todo "The expression [" match ",[" get "," class "]," primary ",32,[" secondary "," tertiary "],26,26] is not yet supported" )
                    ]
            )
        , Layer.lineDasharray (Debug.todo "The expression [3,3] is not yet supported")
        , Layer.lineCap E.lineCapRound

        --, Layer.lineJoin E.lineCapRound
        ]
    , Layer.line "tunnel-major-link-case"
        "composite"
        [ --(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855769305.6016"} is not yet supported"))))
          --,
          Layer.sourceLayer "road"
        , Layer.minzoom 13

        --, Layer.filter (E.all (E.getProperty (str "structure") |> E.isEqual (str "tunnel")) (Debug.todo "The expression [" match ",[" get "," class "],[" motorway_link "," trunk_link "],true,false] is not yet supported") (E.geometryType |> E.isEqual (str "LineString")))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 12, float 0.75 )
                    , ( 20, float 2 )
                    ]
            )
        , Layer.lineColor (E.rgba 223 229 230 1)
        , Layer.lineGapWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 12, float 0.5 )
                    , ( 14, float 2 )
                    , ( 18, float 18 )
                    ]
            )
        , Layer.lineDasharray (Debug.todo "The expression [3,3] is not yet supported")
        , Layer.lineCap E.lineCapRound

        --, Layer.lineJoin E.lineCapRound
        ]
    , Layer.line "tunnel-motorway-trunk-case"
        "composite"
        [ --(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855769305.6016"} is not yet supported"))))
          --,
          Layer.sourceLayer "road"
        , Layer.minzoom 13

        --, Layer.filter (E.all (E.getProperty (str "structure") |> E.isEqual (str "tunnel")) (Debug.todo "The expression [" match ",[" get "," class "],[" motorway "," trunk "],true,false] is not yet supported") (E.geometryType |> E.isEqual (str "LineString")))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 10, float 1 )
                    , ( 18, float 2 )
                    ]
            )
        , Layer.lineColor (E.rgba 223 229 230 1)
        , Layer.lineGapWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [ ( 5, float 0.75 )
                    , ( 18, float 32 )
                    ]
            )
        , Layer.lineDasharray (Debug.todo "The expression [3,3] is not yet supported")
        , Layer.lineCap E.lineCapRound

        --, Layer.lineJoin E.lineCapRound
        ]
    , Layer.line "tunnel-primary-secondary-tertiary"
        "composite"
        [ --(Layer.metadata (((Debug.todo "The expression {"mapbox:group":"1444855769305.6016"} is not yet supported"))))
          --,
          Layer.sourceLayer "road"
        , Layer.minzoom 13

        --, Layer.filter (E.all (E.getProperty (str "structure") |> E.isEqual (str "tunnel")) (Debug.todo "The expression [" match ",[" get "," class "],[" primary "," secondary "," tertiary "],true,false] is not yet supported") (E.geometryType |> E.isEqual (str "LineString")))
        , Layer.lineWidth
            (E.zoom
                |> E.interpolate (E.Exponential 1.5)
                    [--( 5, Debug.todo "The expression [" match ",[" get "," class "]," primary ",0.75,[" secondary "," tertiary "],0.1,0.1] is not yet supported" )
                     --, ( 18, Debug.todo "The expression [" match ",[" get "," class "]," primary ",32,[" secondary "," tertiary "],26,26] is not yet supported" )
                    ]
            )
        , Layer.lineColor (E.rgba 222 226 226 1)
        , Layer.lineCap E.lineCapRound

        --, Layer.lineJoin E.lineCapRound
        ]
    ]
