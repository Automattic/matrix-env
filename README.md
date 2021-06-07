# matrix-env
Docker-based development environment for [Matrix](https://matrix.org), containing the following:

- [Synapse](https://github.com/matrix-org/synapse): the reference homeserver implementation
- [Element](https://github.com/vector-im/element-web): a web-based client
- Postgres: the database (used by Synapse)

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

## Database access
The database can be accessed from the host machine, using the following credentials:

- Host: `localhost`
- Port: `5432`
- User: `synapse`
- Password: `synapse`
- Database: `synapse`

## References

- https://github.com/matrix-org/synapse/tree/master/docker
- https://github.com/matrix-org/synapse/tree/master/contrib/docker
- https://github.com/matrix-org/synapse/blob/master/INSTALL.md
- https://github.com/spantaleev/matrix-docker-ansible-deploy
