port module Main exposing (main)

import Browser exposing (Document)
import Dict exposing (Dict)
import Flip exposing (flip)
import GeoJSON exposing (Feature)
import Html exposing (Html)
import Html.Attributes as Attrs
import Html.Events as Events
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


featuresToStores storesFeatures =
    Dict.fromList (List.map (\store -> ( store.id, store )) storesFeatures)


init : () -> ( Model, Cmd Msg )
init () =
    let
        stores =
            featuresToStores GeoJSON.storesFeatures

        storesJson =
            createStoresJson stores
    in
    ( { position = LngLat 0 0
      , features = []
      , counter = 0
      , stores = stores
      , storesJson = storesJson
      , down = Nothing
      , symbolDraggable = False
      }
    , Cmd.none
    )


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
    , counter : Int
    , stores : Dict Int Feature
    , storesJson : JD.Value
    , down : Maybe Int
    , symbolDraggable : Bool
    }


type Msg
    = MouseMove EventData
    | Click EventData
    | MouseDown EventData
    | MouseUp EventData
    | SymbolDraggable Bool


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
                    ( { model
                        | stores = stores
                        , storesJson = storesJson
                      }
                    , dragPanEnable False
                    )

                Nothing ->
                    ( { model | position = lngLat, features = renderedFeatures, counter = counter }, Cmd.none )

        Click { lngLat, renderedFeatures } ->
            ( { model | position = lngLat, features = renderedFeatures }
            , MapCommands.fitBounds [ Opt.linear True, Opt.maxZoom 10 ]
                ( LngLat.map (\a -> a - 0.2) lngLat
                , LngLat.map (\a -> a + 0.2) lngLat
                )
            )

        MouseDown { lngLat, renderedFeatures } ->
            if model.symbolDraggable then
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
                ( { model | down = down }, Cmd.none )

            else
                ( model, Cmd.none )

        MouseUp { lngLat, renderedFeatures } ->
            ( { model | down = Nothing }, dragPanEnable True )

        SymbolDraggable symbolDraggable ->
            ( { model | symbolDraggable = symbolDraggable }, Cmd.none )


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
                , eventFeaturesLayers [ "locations" ]
                , hoveredFeatures model.features
                ]
                (style model.storesJson)
            , Html.div [ Attrs.style "position" "absolute", Attrs.style "bottom" "20px", Attrs.style "left" "20px" ] [ Html.text (LngLat.toString model.position) ]
            , Html.div
                [ Attrs.style "position" "absolute"
                , Attrs.style "bottom" "20px"
                , Attrs.style "right" "20px"
                ]
                [ Html.label
                    [ Events.onCheck SymbolDraggable
                    ]
                    [ Html.input
                        [ Attrs.type_ "checkbox"
                        ]
                        []
                    , Html.text "symobol draggable"
                    ]
                ]
            ]
        ]
    }


style : JD.Value -> Style
style storesJson =
    Style
        { transition = Style.defaultTransition
        , light = Style.defaultLight
        , layers = Styles.Light.style.layers ++ [ locations Nothing ]
        , sources =
            Styles.Light.style.sources
                ++ [ Source.geoJSONFromValue "stores" [] storesJson
                   ]
        , misc =
            Styles.Light.style.misc
                -- manual center based on borders on google maps
                ++ [ Style.defaultCenter <| LngLat 21.0169753 52.0738102
                   , Style.defaultZoomLevel 13.1
                   ]
        }


locations maybeId =
    Layer.symbol "locations"
        "stores"
    <|
        [ Layer.iconImage (str "restaurant-15")
        , Layer.iconAllowOverlap true

        -- filter: "==", ["id"], "Hello-4"
        -- https://github.com/mapbox/mapbox-gl-js/issues/6552#issuecomment-383373365
        ]
            ++ (case maybeId of
                    Just id ->
                        [ Layer.filter (E.notEqual E.id (E.int id)) ]

                    Nothing ->
                        []
               )



-- Ports
-- WARNING: Ports called asynchronously if inside Cmd.batch https://github.com/elm/core/issues/989


port dragPanEnable : Bool -> Cmd msg
