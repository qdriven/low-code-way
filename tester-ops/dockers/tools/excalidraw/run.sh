#!/bin/sh
git clone https://hub.fastgit.org/excalidraw/excalidraw.git --depth=1
docker build -t excalidraw/excalidraw .
docker run --rm -dit --name excalidraw -p 5000:80 excalidraw/excalidraw:latest
