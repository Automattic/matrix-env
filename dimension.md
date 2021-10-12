## Configuring Dimension
You should go through all the following sections in order for Dimension to be fully functional.

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
