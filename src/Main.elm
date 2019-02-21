module Main exposing (main)

-- from https://github.com/gampleman/elm-mapbox/blob/master/examples/Example01.elm

import Browser exposing (Document)
import Dict exposing (Dict)
import GeoJSON exposing (Feature)
import Html exposing (Html)
import Html.Attributes as Attrs
import Json.Decode as JD
import Json.Decode.Extra exposing (andMap)
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


init : () -> ( Model, Cmd Msg )
init () =
    ( { position = LngLat 0 0, features = [], over = False, counter = 0, stores = Dict.empty }, Cmd.none )


renderedFeatureJson =
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


type alias RenderedFeature =
    { geometry : JD.Value
    , type_ : String
    , properties : JD.Value
    , id : Int
    , layer : RenderedFeatureLayer
    , source : String
    , state : JD.Value
    }


emptyRenderedFeature =
    RenderedFeature
        (Json.Encode.object [])
        ""
        (Json.Encode.object [])
        0
        emptyRenderedFeatureLayer
        ""
        (Json.Encode.object [])


type alias RenderedFeatureLayer =
    { id : String
    , type_ : String
    , source : String
    , paint : JD.Value
    }


emptyRenderedFeatureLayer =
    RenderedFeatureLayer "" "" "" (Json.Encode.object [])


decodeRenderedFeatureLayer =
    JD.succeed RenderedFeatureLayer
        |> andMap (JD.field "id" JD.string)
        |> andMap (JD.field "type" JD.string)
        |> andMap (JD.field "source" JD.string)
        |> andMap (JD.field "paint" JD.value)


decodeRenderedFeature =
    JD.succeed RenderedFeature
        |> andMap (JD.field "geometry" JD.value)
        |> andMap (JD.field "type" JD.string)
        |> andMap (JD.field "properties" JD.value)
        |> andMap (JD.field "id" JD.int)
        |> andMap (JD.field "layer" decodeRenderedFeatureLayer)
        |> andMap (JD.field "source" JD.string)
        |> andMap (JD.field "state" JD.value)


decodedRenderedFeature =
    Result.withDefault emptyRenderedFeature <| JD.decodeString decodeRenderedFeature renderedFeatureJson


type alias Model =
    { position : LngLat
    , features : List JD.Value
    , over : Bool
    , counter : Int
    , stores : Dict Int Feature
    }


type Msg
    = Hover EventData
    | Click EventData
    | Over EventData


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Hover { lngLat, renderedFeatures } ->
            let
                _ =
                    List.map (\jsonValue -> Debug.log "renderedFeatures" (Json.Encode.encode 2 jsonValue)) renderedFeatures

                counter =
                    model.counter + 1 |> Debug.log "counter"

                decodedRenderedFeatures =
                    List.map (Result.withDefault emptyRenderedFeature << JD.decodeValue decodeRenderedFeature) renderedFeatures |> Debug.log "decodedRenderedFeatures"

                over =
                    case List.head decodedRenderedFeatures of
                        Just feature ->
                            feature.layer.id == "point"

                        Nothing ->
                            False
            in
            ( { model | position = lngLat, features = renderedFeatures, counter = counter, over = over }, Cmd.none )

        Click { lngLat, renderedFeatures } ->
            ( { model | position = lngLat, features = renderedFeatures }
            , MapCommands.fitBounds [ Opt.linear True, Opt.maxZoom 10 ]
                ( LngLat.map (\a -> a - 0.2) lngLat
                , LngLat.map (\a -> a + 0.2) lngLat
                )
            )

        Over { lngLat, renderedFeatures } ->
            ( { model | position = lngLat, features = renderedFeatures }, Cmd.none )


hoveredFeatures : List Json.Encode.Value -> MapboxAttr msg
hoveredFeatures =
    List.map (\feat -> ( feat, [ ( "hover", Json.Encode.bool True ) ] ))
        >> featureState


view : Model -> Document Msg
view model =
    { title = "Mapbox Example"
    , body =
        [ css
        , Html.div [ Attrs.style "width" "100vw", Attrs.style "height" "100vh" ]
            [ Html.div [] [ Html.text <| Debug.toString decodedRenderedFeature ]
            , Html.div [] [ Html.text <| Debug.toString GeoJSON.decodedFeature ]
            , Html.div [] [ Html.text <| Debug.toString (Json.Encode.encode 2 GeoJSON.encodedSampleFeature) ]
            , map
                [ maxZoom 24
                , onMouseMove Hover
                , onClick Click
                , onMouseOver Over
                , id "my-map"
                , eventFeaturesLayers [ "locations", "point" ]
                , hoveredFeatures model.features
                ]
                (style model.over)
            , Html.div [ Attrs.style "position" "absolute", Attrs.style "bottom" "20px", Attrs.style "left" "20px" ] [ Html.text (LngLat.toString model.position) ]
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
                   , Source.geoJSONFromValue "pointsJson" [] (GeoJSON.pointsJson 0 0)
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
