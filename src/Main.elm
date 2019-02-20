module Main exposing (main)

-- from https://github.com/gampleman/elm-mapbox/blob/master/examples/Example01.elm

import Browser
import GeoJSON
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
import Styles.Light


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \m -> Sub.none
        }


init () =
    ( { position = LngLat 0 0, features = [], over = False, counter = 0 }, Cmd.none )


renderedFeaturesJson =
    """{
  "geometry": {
    "type": "Point",
    "coordinates": [
      0,
      0
    ]
  },
  "type": "Feature",
  "properties": {},
  "id": 1,
  "layer": {
    "id": "point",
    "type": "circle",
    "source": "pointsJson",
    "paint": {
      "circle-radius": 10,
      "circle-color": "rgba(56, 135, 190, 1)"
    }
  },
  "source": "pointsJson",
  "state": {
    "hover": true
  }
}
"""


type Msg
    = Hover EventData
    | Click EventData
    | Over EventData


update msg model =
    case msg of
        Hover { lngLat, renderedFeatures } ->
            let
                _ =
                    List.map (\jsonValue -> Debug.log "renderedFeatures" (Json.Encode.encode 2 jsonValue)) renderedFeatures

                counter =
                    model.counter + 1 |> Debug.log "counter"
            in
            ( { model | position = lngLat, features = renderedFeatures, counter = counter }, Cmd.none )

        Click { lngLat, renderedFeatures } ->
            ( { model | position = lngLat, features = renderedFeatures }, MapCommands.fitBounds [ Opt.linear True, Opt.maxZoom 10 ] ( LngLat.map (\a -> a - 0.2) lngLat, LngLat.map (\a -> a + 0.2) lngLat ) )

        Over { lngLat, renderedFeatures } ->
            ( { model | position = lngLat, features = renderedFeatures, over = True }, Cmd.none )


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
                , onMouseOver Over
                , id "my-map"
                , eventFeaturesLayers [ "locations", "point" ]
                , hoveredFeatures model.features
                ]
                (style model.over)
            , div [ Attrs.style "position" "absolute", Attrs.style "bottom" "20px", Attrs.style "left" "20px" ] [ text (LngLat.toString model.position) ]
            ]
        ]
    }


style : Bool -> Style
style over =
    Style
        { transition = Style.defaultTransition
        , light = Style.defaultLight
        , layers = Styles.Light.style.layers ++ [ locations, pointsLayer over ]
        , sources =
            Styles.Light.style.sources
                ++ [ Source.geoJSONFromValue "stores" [] GeoJSON.stores
                   , Source.geoJSONFromValue "pointsJson" [] GeoJSON.pointsJson
                   ]
        , misc =
            Styles.Light.style.misc
                --++ [ Style.defaultCenter <| LngLat -77.034084 38.909671
                ++ [ Style.defaultCenter <| LngLat 0 0
                   , Style.defaultZoomLevel 4
                   ]
        }


locations =
    Layer.symbol "locations"
        "stores"
        [ Layer.iconImage (str "restaurant-15")
        , Layer.iconAllowOverlap true
        ]


pointsLayer over =
    let
        color =
            if over then
                E.rgba 59 178 208 1

            else
                E.rgba 56 135 190 1
    in
    Layer.circle "point"
        "pointsJson"
        [ Layer.circleColor color
        , Layer.circleRadius (float 10)
        ]
