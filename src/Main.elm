module Main exposing (main)

-- from https://github.com/gampleman/elm-mapbox/blob/master/examples/Example01.elm

import Browser exposing (Document)
import Dict exposing (Dict)
import Flip exposing (flip)
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


createStoresJson stores =
    GeoJSON.encodeFeatureCollection (GeoJSON.FeatureCollection "FeatureCollection" (Dict.values stores))


init : () -> ( Model, Cmd Msg )
init () =
    let
        stores =
            Dict.fromList (List.map (\store -> ( store.id, store )) GeoJSON.storesFeatures)

        storesJson =
            createStoresJson stores
    in
    ( { position = LngLat 0 0, features = [], over = False, counter = 0, stores = stores, storesJson = storesJson, down = Nothing }, Cmd.none )


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
    { geometry : GeoJSON.Geometry
    , type_ : String
    , properties : JD.Value
    , id : Int
    , layer : RenderedFeatureLayer
    , source : String
    , state : JD.Value
    }


emptyRenderedFeature =
    RenderedFeature
        GeoJSON.emptyGeometry
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
        |> andMap
            (JD.oneOf
                [ JD.field "paint" JD.value
                , JD.field "layout" JD.value
                ]
            )


decodeRenderedFeature =
    JD.succeed RenderedFeature
        |> andMap (JD.field "geometry" GeoJSON.decodeGeometry)
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
    , storesJson : JD.Value
    , down : Maybe Int
    }


type Msg
    = MouseMove EventData
    | Click EventData
    | MouseDown EventData
    | MouseUp EventData


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MouseMove { lngLat, renderedFeatures } ->
            let
                counter =
                    model.counter + 1

                decodedRenderedFeatures =
                    List.map (Result.withDefault emptyRenderedFeature << JD.decodeValue decodeRenderedFeature) renderedFeatures

                over =
                    case List.head decodedRenderedFeatures of
                        Just feature ->
                            feature.layer.id == "point"

                        Nothing ->
                            False

                maybeNewFeature =
                    model.down
                        |> Maybe.andThen
                            (flip Dict.get model.stores
                                >> Maybe.map
                                    (\oldFeature ->
                                        let
                                            oldGeometry =
                                                oldFeature.geometry

                                            newGeometry =
                                                { oldGeometry | coordinates = [ lngLat.lng, lngLat.lat ] }
                                        in
                                        { oldFeature | geometry = newGeometry }
                                    )
                            )
            in
            case maybeNewFeature of
                Just newFeature ->
                    let
                        stores =
                            Dict.update newFeature.id (Maybe.map (always newFeature)) model.stores

                        storesJson =
                            createStoresJson stores
                    in
                    ( { model | position = lngLat, features = renderedFeatures, counter = counter, over = over, stores = stores, storesJson = storesJson }, Cmd.none )

                Nothing ->
                    ( { model | position = lngLat, features = renderedFeatures, counter = counter, over = over }, Cmd.none )

        Click { lngLat, renderedFeatures } ->
            ( { model | position = lngLat, features = renderedFeatures }
            , MapCommands.fitBounds [ Opt.linear True, Opt.maxZoom 10 ]
                ( LngLat.map (\a -> a - 0.2) lngLat
                , LngLat.map (\a -> a + 0.2) lngLat
                )
            )

        MouseDown { lngLat, renderedFeatures } ->
            let
                decodedRenderedFeatures =
                    List.map (Result.withDefault emptyRenderedFeature << JD.decodeValue decodeRenderedFeature) renderedFeatures

                down =
                    List.head decodedRenderedFeatures
                        |> Maybe.andThen
                            (\feature ->
                                if feature.layer.id == "locations" then
                                    Just feature.id

                                else
                                    Nothing
                            )
            in
            ( { model | position = lngLat, features = renderedFeatures, down = down }, Cmd.none )

        MouseUp { lngLat, renderedFeatures } ->
            ( { model | position = lngLat, features = renderedFeatures, down = Nothing }, Cmd.none )


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
            [ map
                [ maxZoom 24
                , onMouseMove MouseMove
                , onClick Click
                , onMouseDown MouseDown
                , onMouseUp MouseUp
                , id "my-map"

                -- , eventFeaturesLayers [ "locations", "point" ]
                , eventFeaturesLayers [ "locations" ]
                , hoveredFeatures model.features
                ]
                (style model.over model.storesJson)
            , Html.div [ Attrs.style "position" "absolute", Attrs.style "bottom" "20px", Attrs.style "left" "20px" ] [ Html.text (LngLat.toString model.position) ]
            ]
        ]
    }


style : Bool -> JD.Value -> Style
style over storesJson =
    Style
        { transition = Style.defaultTransition
        , light = Style.defaultLight

        -- , layers = Styles.Light.style.layers ++ [ locations, pointsLayer over ]
        , layers = Styles.Light.style.layers ++ [ locations ]
        , sources =
            Styles.Light.style.sources
                ++ [ Source.geoJSONFromValue "stores" [] storesJson

                   -- , Source.geoJSONFromValue "pointsJson" [] (GeoJSON.pointsJson 21.0169753 52.068688)
                   ]
        , misc =
            Styles.Light.style.misc
                -- manual center based on borders on google maps
                ++ [ Style.defaultCenter <| LngLat 21.0169753 52.0738102
                   , Style.defaultZoomLevel 13.1
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
