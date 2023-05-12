#!/bin/bash

# Comprobar si la imagen Owncast existe localmente
if [[ "$(docker images -q owncast:latest 2> /dev/null)" == "" ]]; then
  echo "La imagen Owncast no se encontró localmente. Descargando..."
  docker pull owncast/owncast:latest
fi

# Detener y eliminar cualquier contenedor Owncast existente
docker stop owncast-container 2> /dev/null
docker rm owncast-container 2> /dev/null

# Crear volúmenes para almacenar los datos persistentes del contenedor
docker volume create owncast-data

# Iniciar el contenedor Owncast
docker run -d -p 8080:8080 -p 1935:1935 \
  -v owncast-data:/app/data \
  -v $(pwd)/owncast-videos:/app/videos \
  --name owncast-container \
  owncast/owncast:latest
