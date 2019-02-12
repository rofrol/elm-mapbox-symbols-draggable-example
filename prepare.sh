#!/bin/bash

source .env

cp src/index.html .
sed -i "s/MAPBOX_TOKEN/${MAPBOX_TOKEN}/" index.html
