## Get current mapbox zoom

```javascript
document.querySelector('elm-mapbox-map').map.getZoom()
```

- https://stackoverflow.com/questions/35614957/how-can-i-read-current-zoom-level-of-mapbox
- https://docs.mapbox.com/mapbox-gl-js/api/#map#getzoom

## Downloading json and elm code

- https://code.gampleman.eu/elm-mapbox/style-generator/
- mapbox://styles/mapbox/light-v10
- TOKEN
- https://api.mapbox.com/styles/v1/mapbox/light-v10?access_token=TOKEN

## As example look at landuse

```elm
      Layer.fill "landuse"
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
```

```json
    {
      "filter": [
        "match",
        [
          "get",
          "class"
        ],
        [
          "park",
          "airport",
          "glacier",
          "pitch",
          "sand"
        ],
        true,
        false
      ],
      "id": "landuse",
      "layout": {},
      "minzoom": 5,
      "paint": {
        "fill-color": "hsl(150, 6%, 93%)",
        "fill-opacity": [
          "interpolate",
          [
            "linear"
          ],
          [
            "zoom"
          ],
          5,
          0,
          6,
          [
            "match",
            [
              "get",
              "class"
            ],
            "glacier",
            0.5,
            1
          ]
        ]
      },
      "source": "composite",
      "source-layer": "landuse",
      "type": "fill"
    }
```

## Layer.fillOpacity looks finished

```elm
{-| The opacity of the entire fill layer. In contrast to the `fillColor`, this value will also affect the 1px stroke around the fill, if the stroke is used. Paint property.

Should be between `0` and `1` inclusive. Defaults to `1`.

-}
fillOpacity : Expression any Float -> LayerAttr Fill
fillOpacity =
    Expression.encode >> Paint "fill-opacity"
```

```elm
{-| Turns an expression into JSON
-}
encode : Expression exprType a -> Value
encode (Expression value) =
    value
```

## Where is Style put?

```javascript
document.querySelector('elm-mapbox-map').mapboxStyle
```

Get layer `landuse`:

```javascript
document.querySelector('elm-mapbox-map').mapboxStyle.layers.find(({id}) => id === "landuse")
```

get `fill-opacity`

```javascript
document.querySelector('elm-mapbox-map').mapboxStyle.layers.find(({id}) => id === "landuse").paint['fill-opacity']
```

```javascript
JSON.stringify(document.querySelector('elm-mapbox-map').mapboxStyle.layers.find(({id}) => id === "landuse").paint['fill-opacity'], null, 4)
"[
    \"interpolate\",
    [
        \"linear\"
    ],
    [
        \"zoom\"
    ],
    5,
    0,
    6,
    [
        \"match\",
        [
            \"get\",
            \"class\"
        ],
        \"glacier\",
        0.5,
        1
    ]
]"
```

## Expression.interpolate

```elm
interpolate : Interpolation -> List ( Float, Expression exprType2 outputType ) -> Expression exprType1 Float -> Expression exprType1 outputType
interpolate interpolation stops (Expression input) =
    call "interpolate" <| (encodeInterpolation interpolation |> encode) :: input :: List.concatMap (\( stop, Expression res ) -> [ Json.Encode.float stop, res ]) stops
```

## Expression.call

```elm
call name args =
    Expression (Json.Encode.list identity (Json.Encode.string name :: args))
```

## Express.encodeInterpolation 

```elm
encodeInterpolation interpolation =
    case interpolation of
        Linear ->
            call0 "linear"

        Exponential base ->
            call "exponential" [ Json.Encode.float base ]

        CubicBezier ( x1, y1 ) ( x2, y2 ) ->
            call "cubic-bezier" [ Json.Encode.float x1, Json.Encode.float y1, Json.Encode.float x2, Json.Encode.float y2 ]
```

## Express.call0

```elm
call0 n =
    call n []
```

## Express.encode

```elm
{-| Turns an expression into JSON
-}
encode : Expression exprType a -> Value
encode (Expression value) =
    value
```

## Expression.zoom

```elm
{-| Gets the current zoom level. Note that in style layout and paint properties, `zoom` may only appear as the input to a top-level `step` or `interpolate` expression.
-}
zoom : Expression CameraExpression Float
zoom =
    call0 "zoom"
```

## Expresssion.getProperty

```elm
{-| Retrieves a property value from the current feature's properties. Returns null if the requested property is missing.
-}
getProperty : Expression exprType String -> Expression DataExpression any
getProperty =
    call1 "get"
```

## Expresssion.call1

```elm
call1 n (Expression a) =
    call n [ a ]
```

## Expression.str

```elm
{-| -}
str : String -> Expression exprType String
str s =
    Expression (Json.Encode.string s)

```

## Expression.matchesStr 

```elm
{-| Selects the output whose label value matches the input value, or the fallback value if no match is found.

    getProperty (str "type")
      |> matchesStr
          [ ("hospital", str "icon-hospital")
          , ("clinic", str "icon-medical")
          ]
          (str "icon-generic") -- fallback value
      |> Layer.iconImage

-}
matchesStr : List ( String, Expression exprType2 output ) -> Expression exprType1 output -> Expression exprType3 String -> Expression exprType3 output
matchesStr options (Expression default) (Expression input) =
    let
        properOptions =
            List.concatMap (\( label, Expression output ) -> [ Json.Encode.string label, output ]) options
    in
    call "match" (input :: properOptions ++ [ default ])
```

## Summary

`call` turns name and list into json list and wraps it with Expression.

`call0` turns name into list and wraps it with Expression.

`call1` takes name and unwraps expression, turns them into list and wraps it with Expression.

`encode` extracts json value from expression.

`encodeInterpolation` runs `call` or `call0` depending of interpolation
## Set style from URI

rofrol [10:47 PM]
@gampleman How to set map style directly so that I don't need to rewrite `Debug.todo` and others? Something like:

        ```let elmMapboxMap = document.querySelector('elm-mapbox-map');
        elmMapboxMap.map.setStyle('mapbox://styles/mapbox/light-v10');```

gampleman [10:52 PM]
@rofrol would https://package.elm-lang.org/packages/gampleman/elm-mapbox/latest/Mapbox-Style#light work for you?
rofrol [11:04 PM]
@gampleman I see I can do this `(FromUrl "mapbox://styles/mapbox/light-v10")`, but then how to set `defaultCenter` and `defaultZoomLevel` etc. So basically just use `layers` from `mapbox://styles/mapbox/light-v10`?
gampleman [11:07 PM]
Ah well that won’t work. There is no way to modify a style - it works like virtual Dom. Which is why the code generator exists. I appreciate that it is a laborious solution at the moment and I hope it will improve in the near future.
Having the style checked in to your repository is best practice in my experience.

## load style object directly into mapboxStyle property of `elm-mapbox-map` element

I've tried to load style object directly into `document.querySelector('elm-mapbox-map').mapboxStyle`, but as gampleman said, it works like virtual dom. It was overwritten by style from Elm app.

The one way to load was to quickly click on page and hold during reloading side. But then after move move the style from Elm app was loaded.

The way I loaded it was like that:

```html
	<script src="createObserver.js"></script>
	<script>
	    /*
	    var rootElement = document.getElementById('elm');
	    createObserver({
	      rootElement,
	      selector: 'elm-mapbox-map',
	      onMount: initAce,
	      onUnmount: killAce
	    });
	    var styleJson;
            function initAce(node) {
		let elmMapboxMap = document.querySelector('elm-mapbox-map');
		elmMapboxMap.map.setStyle('mapbox://styles/mapbox/light-v10');
	    }
	    function killAce(node) {
	    }
	    */
	    elmMapbox.registerCustomElement({token: 'MAPBOX_TOKEN'});
	    var app = Elm.Main.init({ node: document.getElementById("elm") });
	    elmMapbox.registerPorts(app);
	</script>
```

I have also tried it with fetching json previously downloaded:



```html
	<script src="createObserver.js"></script>
	<script>
	    /*
	    var rootElement = document.getElementById('elm');
	    createObserver({
	      rootElement,
	      selector: 'elm-mapbox-map',
	      onMount: initAce,
	      onUnmount: killAce
	    });
	    var styleJson;
            function initAce(node) {
		fetch("light-v10.json")
		  .then(response => response.json())
		    .then(json => {
			console.log(json);
			styleJson = json;
			let elmMapboxMap = document.querySelector('elm-mapbox-map');
			elmMapboxMap.mapboxStyle.layers = json.layers;
		    });
	    }
	    function killAce(node) {
	    }
	    */
	    elmMapbox.registerCustomElement({token: 'MAPBOX_TOKEN'});
	    var app = Elm.Main.init({ node: document.getElementById("elm") });
	    elmMapbox.registerPorts(app);
	</script>
```

createObserver.js and accompanying code was taken from https://gist.github.com/pablen/c07afa6a69291d771699b0e8c91fe547.

## Error: The feature id parameter must be provided and non-negative

When hovering over restaurant icon from "Build a store locator" tutorial I got error in console.

Needed to add ids to geojson, though example from tutorial does not throws an error.

Maybe because Light style in elm-mapbox is based on mapbox://sprites/mapbox/light-v9 and and the one from tutorial on mapbox://styles/mapbox/light-v10.

Also they tutorial is using mapboxgl 0.53 and I am using probably 0.51.

## restaurant-15 icons and names on the map are smaller than in tutorial

- Icons https://github.com/mapbox/mapbox-gl-styles

## Popup

rofrol5:12 PM
I can't find support for https://docs.mapbox.com/mapbox-gl-js/example/popup/ in elm-mapbox (edited) 
What do you people use instead?
gampleman5:16 PM
Either build it yourself or use ports.
You can get access to the mapbox instance by using the map property on the custom element

## I will unlock marker by using long press

- http://jsfiddle.net/kelunik/pkjze6e6/42/
  - https://stackoverflow.com/questions/2625210/long-press-in-javascript/27413909#27413909
- This does not work on ios firefox but has nice animations https://jsfiddle.net/5xrtx69z/1/
  - https://stackoverflow.com/questions/2625210/long-press-in-javascript/44459945#44459945
  - https://github.com/john-doherty/long-press-event
- https://stackoverflow.com/questions/24774139/how-to-detect-long-press-on-google-maps-markers-javascript

## Draggable point

I've added point on the javascript side and it was removed as soon as I moved mouse cursor over map.

I tried to run javascript on map object to change color of point on hover, but it was visible for very short time, probably after the elm rendering started and replaced map removing all events added in javascript.

When I used `onMouseOver`, it did not contain any data in `renderedFeatures`.

Also when I use `onMouseMove`, I get two events, probably because of bubbling.

I used this to displayed `renderedFeatures`:

```elm
        Hover { lngLat, renderedFeatures } ->
            let
                _ =
                    List.map (\jsonValue -> Debug.log "renderedFeatures" (Json.Encode.encode 2 jsonValue)) renderedFeatures

                counter =
                    model.counter + 1 |> Debug.log "counter"
            in
            ( { model | position = lngLat, features = renderedFeatures, counter = counter }, Cmd.none )
```

- https://stackoverflow.com/questions/9387433/onmouseover-running-multiple-times-while-hovering-on-element
- https://docs.mapbox.com/mapbox-gl-js/example/drag-a-point/
- https://docs.mapbox.com/mapbox-gl-js/example/drag-a-marker/

We have onMouseOver but not onMouseEnter in elm-mapbox

- https://package.elm-lang.org/packages/elm/html/latest/Html-Events
- https://package.elm-lang.org/packages/gampleman/elm-mapbox/latest/Mapbox-Element#onMouseOver

## Drag and bounce on mobile

- https://github.com/alex3165/react-mapbox-gl/issues/497
- https://github.com/lazd/iNoBounce
- https://github.com/elm/html/issues/166
  - https://github.com/elm/html/issues/167
  - https://javascript.info/mousemove-mouseover-mouseout-mouseenter-mouseleave

## Marker

I am able to add Marker in dev console. After adding 

```html
<script src='node_modules/mapbox-gl/dist/mapbox-gl.js'></script>
```

`mapboxgl` is available.

Code to add Marker taken from https://docs.mapbox.com/mapbox-gl-js/example/drag-a-marker/.

```javascript
var map = document.querySelector('elm-mapbox-map').map;
  var marker = new mapboxgl.Marker({
  draggable: true
})
.setLngLat([0, 0])
.addTo(map);
```

1. How to add this marker after map is loaded?
2. How to disable draggable?
