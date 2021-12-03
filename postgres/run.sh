#!/bin/bash

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    CREATE USER slackbridge_user WITH PASSWORD 'slackbridgesecret';
    CREATE DATABASE slack_bridge;
    GRANT ALL PRIVILEGES ON DATABASE slack_bridge to slackbridge_user;
EOSQL
