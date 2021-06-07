# matrix-env
Docker-based development environment for Matrix.

## Instructions
Add `matrix.test` to your `/etc/hosts`:

```
127.0.0.1 matrix.test
```

Then start everything with:

```shell
docker compose up
```

- The server is available at http://localhost:8008. You should see a page that displays "Synapse is running".
- You can access Element (the client) at http://localhost:8009.

## References

- https://github.com/matrix-org/synapse/tree/master/docker
- https://github.com/matrix-org/synapse/tree/master/contrib/docker
- https://github.com/matrix-org/synapse/blob/master/INSTALL.md
- https://github.com/spantaleev/matrix-docker-ansible-deploy
