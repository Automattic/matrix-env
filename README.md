# matrix-env

Docker-based development environment for [Matrix](https://matrix.org). Provides a local sandbox with the following pre-configured services:

- [Synapse](https://github.com/matrix-org/synapse): the reference Homeserver implementation
- [Element](https://github.com/vector-im/element-web): a web-based client

## Instructions
Create the `.env.local` file, which you can use to override environment variables defined in `.env`, if you so wish:

```shell
touch .env.local
```

Then start everything with:

```shell
docker compose up
```

- The server is available at http://localhost:8008. You should see a page that displays "Synapse is running".
- You can access Element (the client) at http://localhost:8009.

## Creating users
There are no pre-configured users, and registration through the client is disabled. Before you can login, you must create a user. To do so, you can use the [bin/register_new_matrix_user](bin/register_new_matrix_user) command:

```shell
# Create a privileged user with username 'admin' and password 'admin'.
# Add --help to see documentation.

bin/register_new_matrix_user -u admin -p admin --admin
```

## Database access
Synapse uses a PostgreSQL database, which is accessible from the host machine using the following credentials:

- Host: `localhost`
- Port: `5432`
- User: `synapse`
- Password: `synapse`
- Database: `synapse`

## Starting from scratch
Use the following commands to remove all containers and all data:

```shell
docker compose down
docker volume rm matrix-env_synapse-database
```

Also note that Element stores data in the browser's local storage. To really start from scratch, you must also delete all browser data related to http://localhost:8009. 

## References

- https://github.com/matrix-org/synapse/tree/master/docker
- https://github.com/matrix-org/synapse/tree/master/contrib/docker
- https://github.com/matrix-org/synapse/blob/master/INSTALL.md
- https://github.com/spantaleev/matrix-docker-ansible-deploy
