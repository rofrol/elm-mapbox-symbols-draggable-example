# Front-end Engineer Coding Challenge

## Build a map-based web application

#### Outline
A food delivery company is planning a marketing campaign. The campaign site shows the restaurants of the user's hometown on a interactive map.

#### Specification
Create a web application that shows a map of your hometown with a marker for every restaurant. Markers have two states, locked and unlocked. Users can lock or unlock a marker, a marker can be dragged around the map when unlocked.

#### Requirements
* The map must be zoom- and draggable
* The application must work in IE > 9, Firefox and Chrome
* The application must run on the client-side
* We expect you to write code you would consider production-ready

## Run

Install node and elm and also some http server like `npm i -g serve`.

```bash
$ npm i
$ cp .env.example .env
# set your env variables in .env
$ bash prepare.sh
$ elm make src/Main.elm --output elm.js
$ serve 
```

Open http://localhost:5000/.

## Mapbox

get current zoom

```javascript
document.querySelector('elm-mapbox-map').map.getZoom()
```

- https://stackoverflow.com/questions/35614957/how-can-i-read-current-zoom-level-of-mapbox
- https://docs.mapbox.com/mapbox-gl-js/api/#map#getzoom
