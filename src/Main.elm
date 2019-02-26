port module Main exposing (main)

import Browser exposing (Document)
import Dict exposing (Dict)
import GeoJSON exposing (Feature)
import Html exposing (Html)
import Html.Attributes as Attrs
import Html.Events as Events
import Json.Decode as JD exposing (Value)
import Json.Encode
import LngLat exposing (LngLat)
import MapCommands
import Mapbox.Cmd.Option as Opt
import Mapbox.Element exposing (..)
import Mapbox.Expression as E
import Mapbox.Layer as Layer
import Mapbox.Source as Source
import Mapbox.Style as Style exposing (Style(..))
import Styles.Light


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
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
      , stores = stores
      , storesJson = storesJson
      , symbolDraggable = False
      , maybeDraggedFeature = Nothing
      }
    , addMarkers storesJson
    )


type alias Model =
    { position : LngLat
    , features : List Value
    , stores : Dict Int Feature
    , storesJson : Value
    , symbolDraggable : Bool
    , maybeDraggedFeature : Maybe Feature
    }


type Msg
    = MouseMove EventData
    | Click EventData
    | MouseDown EventData
    | MouseUp EventData
    | SymbolDraggable Bool
    | MarkerDraggable Bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MouseMove { lngLat, renderedFeatures } ->
            case model.maybeDraggedFeature of
                Just oldFeature ->
                    let
                        oldGeometry =
                            oldFeature.geometry

                        newGeometry =
                            { oldGeometry | coordinates = [ lngLat.lng, lngLat.lat ] }

                        maybeDraggedFeature =
                            Just { oldFeature | geometry = newGeometry }
                    in
                    ( { model | maybeDraggedFeature = maybeDraggedFeature }, dragPanEnable False )

                Nothing ->
                    ( model, Cmd.none )

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
                        List.map (Result.withDefault GeoJSON.emptyRenderedFeature << JD.decodeValue GeoJSON.decodeRenderedFeature) renderedFeatures

                    maybeDraggedFeature =
                        List.head decodedRenderedFeatures
                            |> Maybe.andThen
                                (\feature ->
                                    if feature.layer.id == "locations" then
                                        Dict.get feature.id model.stores
                                            |> Maybe.map
                                                (\oldFeature ->
                                                    let
                                                        oldGeometry =
                                                            oldFeature.geometry

                                                        newGeometry =
                                                            { oldGeometry | coordinates = [ lngLat.lng, lngLat.lat ] }
                                                    in
                                                    { oldFeature | geometry = newGeometry }
                                                )

                                    else
                                        Nothing
                                )
                in
                ( { model | maybeDraggedFeature = maybeDraggedFeature }, Cmd.none )

            else
                ( model, Cmd.none )

        MouseUp { lngLat, renderedFeatures } ->
            case model.maybeDraggedFeature of
                Just draggedFeature ->
                    let
                        stores =
                            Dict.update draggedFeature.id (Maybe.map (always draggedFeature)) model.stores

                        storesJson =
                            createStoresJson stores
                    in
                    ( { model
                        | stores = stores
                        , storesJson = storesJson
                        , maybeDraggedFeature = Nothing
                      }
                    , dragPanEnable True
                    )

                Nothing ->
                    ( model, Cmd.none )

        SymbolDraggable symbolDraggable ->
            ( { model | symbolDraggable = symbolDraggable }, Cmd.none )

        MarkerDraggable enable ->
            ( model, dragEnable enable )


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
                , eventFeaturesLayers <|
                    [ "locations" ]
                        ++ (case model.maybeDraggedFeature of
                                Just _ ->
                                    [ "draggedFeatureLayer" ]

                                Nothing ->
                                    []
                           )
                , hoveredFeatures model.features
                ]
                (style model.storesJson model.maybeDraggedFeature)
            , Html.div [ Attrs.style "position" "absolute", Attrs.style "bottom" "20px", Attrs.style "left" "20px" ] [ Html.text (LngLat.toString model.position) ]
            , Html.div
                [ Attrs.style "position" "absolute"
                , Attrs.style "bottom" "20px"
                , Attrs.style "right" "20px"
                ]
                [ Html.div []
                    [ Html.label
                        [ Events.onCheck SymbolDraggable
                        ]
                        [ Html.input
                            [ Attrs.type_ "checkbox"
                            ]
                            []
                        , Html.text "draggable"
                        ]
                    , Html.label
                        [ Events.onCheck MarkerDraggable
                        ]
                        [ Html.input
                            [ Attrs.type_ "checkbox"
                            ]
                            []
                        , Html.text "marker draggable"
                        ]
                    ]
                ]
            ]
        ]
    }


style : Value -> Maybe Feature -> Style
style storesJson maybeDraggedFeature =
    let
        features =
            case maybeDraggedFeature of
                Just feature ->
                    [ feature ]

                Nothing ->
                    []
    in
    Style
        { transition = Style.defaultTransition
        , light = Style.defaultLight
        , layers = Styles.Light.style.layers ++ [ locations maybeDraggedFeature, draggedFeatureLayer ]
        , sources =
            Styles.Light.style.sources
                ++ [ Source.geoJSONFromValue "stores" [] storesJson
                   , Source.geoJSONFromValue "draggedFeatureSource" [] (createStoresJson <| featuresToStores features)
                   ]
        , misc =
            Styles.Light.style.misc
                -- manual center based on borders on google maps
                ++ [ Style.defaultCenter <| LngLat 21.0169753 52.0738102
                   , Style.defaultZoomLevel 13.1
                   ]
        }


locations maybeDraggedFeature =
    Layer.symbol "locations"
        "stores"
    <|
        [ Layer.iconImage (E.str "restaurant-15")
        , Layer.iconAllowOverlap E.true

        -- filter: "==", ["id"], "Hello-4"
        -- https://github.com/mapbox/mapbox-gl-js/issues/6552#issuecomment-383373365
        ]
            ++ (case maybeDraggedFeature of
                    Just feature ->
                        [ Layer.filter (E.notEqual E.id (E.int feature.id)) ]

                    Nothing ->
                        []
               )


draggedFeatureLayer =
    Layer.symbol "draggedFeatureLayer"
        "draggedFeatureSource"
    <|
        [ Layer.iconImage (E.str "restaurant-15")
        , Layer.iconAllowOverlap E.true
        , Layer.iconSize (E.float 2)
        ]



-- Ports
-- WARNING: Ports called asynchronously if inside Cmd.batch https://github.com/elm/core/issues/989


port dragPanEnable : Bool -> Cmd msg


port dragEnable : Bool -> Cmd msg


port addMarkers : Value -> Cmd msg
