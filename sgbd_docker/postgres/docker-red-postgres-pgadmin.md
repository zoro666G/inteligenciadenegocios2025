
# PGADMIN y POSTGRES

## Docker Hub Images
[postgres](https://hub.docker.com/_/postgres)
[pgadmin](https://hub.docker.com/r/dpage/pgadmin4)

1. Crear un volumen para almacenar la informacion de la base de datos

`docker volume create postgres-db3`

2. Crear el contenedor de postgres

docker container run `
-d `
--name postgres-dbbi `
-e POSTGRES_PASSWORD=123456 `
-p 5434:5432 `
-v postgres-db3:/var/lib/postgresql/data `
postgres:15.1

3. Crear el contenedor de pgadmin

docker container run --name pgadmin2 -e PGADMIN_DEFAULT_PASSWORD=123456 -e PGADMIN_DEFAULT_EMAIL=gustavo@google.com -dp 8089:8000 dpage/pgadmin4:6.17

4. Crear red

`docker network create postgres-net`

5. Conectar ambos contenedores a la red

`docker network connect nombreContenedor`