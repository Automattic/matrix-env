# matrix-env
This project provides a self-contained [Matrix.org](https://matrix.org) sandbox, using [Docker Compose](https://docs.docker.com/compose). It allows you to quickly get a Matrix _node_ running on your local machine, for exploration or hacking on the Matrix ecosystem.

It gives you the following pre-configured services:

| Service  | Description | URL |
| ------------- | ------------- | ------------- |
| [synapse](https://github.com/matrix-org/synapse) | The reference homeserver implementation | [localhost:8008](http://localhost:8008) |
| [synapse-admin](https://github.com/Awesome-Technologies/synapse-admin) | Homeserver admin UI | [localhost:8009](http://localhost:8009) |
| [element](https://github.com/vector-im/element-web) | Web-based Matrix client | [localhost:8010](http://localhost:8010) |
| [dimension](https://dimension.t2bot.io/) | Integration manager | [localhost:8011](http://localhost:8011) |
| [go-neb](https://github.com/matrix-org/go-neb) | Extensible bot, written in Go | [localhost:8012](http://localhost:8012) |
| [maubot](https://github.com/maubot/maubot) | extensible bot, written in Python | [localhost:8013](http://localhost:8013) |

## Instructions
Create the `.env.local` file, which you can use to override environment variables defined in `.env`, if you so wish:

```shell
echo "# Environment variables defined in this file override the ones defined in .env" > .env.local
```

Then start everything with:

```shell
docker compose up
```

> You might notice Dimension exits with an error. This is expected, since Dimension requires [further configuration](#configuring-dimension) to properly boot. However, if you don't plan on using Dimension, you can safely ignore this error.

## Creating users
There are no pre-configured users, and registration through the client is disabled. Before you can login, you must create a user. To do so, you can use the [bin/register_new_matrix_user](bin/register_new_matrix_user) command:

```shell
# Create a privileged user with username 'admin' and password 'admin'.
# Add --help to see documentation.

bin/register_new_matrix_user -u admin -p admin --admin
```

## Configuring Dimension
Out of the box, Dimension (the integration manager) will not properly start since it requires further configuration. You should go through all the following subsections in order for Dimension to be fully functional.

### Create a user for Dimension
Start by creating a `dimension` user, with the following command:

```shell
bin/register_new_matrix_user -u dimension -p dimension --no-admin
```

Once the `dimension` user is created, its access token must be set in `dimension/config.yaml`. You can retrieve the user's access token [directly from the synapse database](#database-access) (in the `access_tokens` table), or [by following these instructions](https://t2bot.io/docs/access_tokens/).

Once you retrieved the access token, you must enter it into Dimension's configuration file:

```yaml
# dimension/config.yaml

homeserver:
  accessToken: "access-token-goes-here"
```

Alternatively, if you don't want the `dimension/config.yaml` file to be modified, you could instead *hack it* by entering the default access token present in that file, into the `access_tokens` database table for the `dimension` user.

Finally, you should restart the Dimension service, so the new configuration is used:

```shell
docker compose restart
```

### Configure go-neb usage with Dimension
Dimension provides an [Application Service](https://matrix.org/docs/guides/application-services) that simplifies usage of *go-neb*. The following steps are required for this application service to work correctly.

1. Open [Element](http://localhost:8010) and login using the `admin` user (password is `admin`)
1. Create a room, with no end-to-end encryption
1. Open the room info sidebar (the `i` on top-right)
1. Click *Add widgets, bridges & bots*
1. Click the gear icon on top-right
1. Click on *go-neb* in the sidebar
1. Click *Add self-hosted go-neb*
1. Leave *User Prefix* as is
1. As *API URL*, enter `http://matrix-env-go-neb:4050`
1. Click *Save*

A modal will appear with the `appservice` configuration. You should copy the configuration and paste it into `synapse/config/appservice-dimension.yaml`.

Alternatively, if you don't want to modify the `synapse/config/appservice-dimension.yaml` you can take the values in that file for `id`, `as_token` and `hs_token`, and enter them into the `dimension_appservice` table, in the [Dimension database](#database-access).

Finally, you should restart Synapse so it takes the new appservice configuration in account:

```shell
docker compose restart
```

Once containers are running again, clicking the *Test configuration* button in the appservice configuration modal, should display a success message.

## Database access
Each service uses its own SQLite database. To access each database, simply open the file with an SQLite client. The files are stored under:

- synapse: `synapse/data/homeserver.db`
- dimension: `dimension/dimension.db`
- maubot: `maubot/maubot.db`
- go-neb: `go-neb/go-neb.db`

## Credentials

- Matrix users
    - admin:
        - username: `admin`
        - password: `admin`
    - dimension:
        - username: `dimension`
        - password: `dimension`
- maubot
    - username: `admin`
    - password: `admin`

## Starting from scratch
Use the following commands to remove all containers and all data:

```shell
docker compose down
rm synapse/data/homeserver.db dimension/dimension.db maubot/maubot.db go-neb/go-neb.db
```

Also note that Element stores data in the browser's local storage. To really start from scratch, you must also delete all browser data related to http://localhost:8010.
